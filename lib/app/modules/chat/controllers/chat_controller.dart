import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/base/base_viewmodel.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/strings_manager.dart';
import '../../../data/model/conversation.dart';
import '../../../data/model/user.dart';
import '../../../gobal_controllers/user_controller.dart';
import '../../project/controllers/project_controller.dart';
import '../../../services/chat_hub_service.dart';
import '../../../services/conversation_services.dart';

class ChatController extends BaseController {
  ChatController({ChatHubService? chatHubService})
      : _chatHubService = chatHubService ?? Get.find<ChatHubService>();

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final RxBool isLoading = false.obs;
  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isUploadingAttachment = false.obs;
  final RxBool isLoadingMore = false.obs;

  final ChatHubService _chatHubService;

  static const int _messagesPageSize = 50;

  late int conversationId;
  late final String contractorId;
  late final String projectId;
  late final UserModel _currentUser;
  late final bool _isProjectOwnerInitiator;
  late final dynamic _contractorArgument;
  late final String _offerId;

  int _currentPage = 1;
  final RxBool _hasMorePages = true.obs;
  bool _isInitialMessagesLoaded = false;
  final Set<int> _messageIds = <int>{};

  bool get hasMoreMessages => _hasMorePages.value;

  StreamSubscription<ConversationMessage>? _messageSubscription;

  @override
  void onInit() {
    super.onInit();

    final args = (Get.arguments ?? {}) as Map<dynamic, dynamic>;
    conversationId = _parseConversationId(args['conversationId']);
    contractorId = args['contractorId']?.toString() ?? '';
    projectId = args['projectId']?.toString() ?? '';
    _offerId = args['offerId']?.toString() ?? '';
    _isProjectOwnerInitiator = args['isProjectOwner'] == true;
    _contractorArgument = int.tryParse(contractorId) ?? contractorId;

    scrollController.addListener(_handleScroll);

    final user = Get.find<UserController>().user();
    if (user == null) {
      appSnackbar(AppStrings.defaultError.tr, type: SnackbarType.ERROR);
      return;
    }
    _currentUser = user;

    _subscribeToIncomingMessages();
    _initialiseChat();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.removeListener(_handleScroll);
    scrollController.dispose();
    _messageSubscription?.cancel();
    super.onClose();
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) {
      return;
    }

    messageController.clear();

    try {
      final resolvedConversationId = await _chatHubService.sendMessage(
        conversationId: conversationId,
        contractorId: _contractorArgument,
        projectId: projectId,
        text: text,
        allowConversationCreation: _isProjectOwnerInitiator,
        files: null,
      );
      if (resolvedConversationId != conversationId) {
        _handleConversationResolved(resolvedConversationId);
      }
    } catch (error, stackTrace) {
        debugPrint('Failed to send message: $error\n$stackTrace');
      appSnackbar(AppStrings.genericRetryMessage.tr, type: SnackbarType.ERROR);
      messageController.text = text;
    }
  }

  Future<void> pickAndUploadFiles({FileType fileType = FileType.any}) async {
    if (isUploadingAttachment.value) {
      return;
    }

    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: fileType,
      );
      if (result == null || result.files.isEmpty) {
        return;
      }

      final validFiles = result.files
          .where((file) => file.path?.isNotEmpty == true || file.bytes != null)
          .toList();

      if (validFiles.isEmpty) {
        appSnackbar(AppStrings.genericRetryMessage.tr,
            type: SnackbarType.ERROR);
        return;
      }

      isUploadingAttachment.value = true;

      final shouldTreatAsImages =
          fileType == FileType.image || _areImages(validFiles);
      _uploadFiles(validFiles, shouldTreatAsImages);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('Failed to upload attachments: $error\n$stackTrace');
      }
      appSnackbar(AppStrings.genericRetryMessage.tr, type: SnackbarType.ERROR);
    } finally {
      isUploadingAttachment.value = false;
    }
  }

  _uploadFiles(
    List<PlatformFile> validFiles,
    bool shouldTreatAsImages,
  ) async {
    final uploadResult = await ConversationServices.uploadConversationFiles(
      files: validFiles,
      isImage: shouldTreatAsImages,
    );

    await uploadResult.fold(
      (failure) => handleError(
          failure, () => _uploadFiles(validFiles, shouldTreatAsImages)),
      (uploaded) async {
        if (uploaded.isEmpty) {
          return;
        }
        final serializedFiles =
            uploaded.map((file) => jsonEncode(file)).toList();
        final resolvedConversationId = await _chatHubService.sendMessage(
          conversationId: conversationId,
          contractorId: _contractorArgument,
          projectId: projectId,
          text: '',
          allowConversationCreation: _isProjectOwnerInitiator,
          files: serializedFiles,
        );
        if (resolvedConversationId != conversationId) {
          _handleConversationResolved(resolvedConversationId);
        }
      },
    );
  }

  bool isSender(MessageModel message) =>
      message.senderId.toString() == _currentUser.id;

  Future<void> _initialiseChat() async {
    isLoading.value = true;
    try {
      await _chatHubService.connectIfNeeded(userId: _currentUser.id);
      if (conversationId > 0) {
        await _chatHubService.joinConversation(conversationId);
        await _loadInitialMessages();
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('Failed to initialise chat: $error\n$stackTrace');
      }
      appSnackbar(AppStrings.genericRetryMessage.tr, type: SnackbarType.ERROR);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadInitialMessages() async {
    if (conversationId <= 0) {
      return;
    }

    final result = await ConversationServices.getMessages(
      conversationId: conversationId.toString(),
      pageNumber: 1,
      pageSize: _messagesPageSize,
    );

    result.fold(
      (failure) => handleError(failure, _loadInitialMessages),
      (paginatedMessages) {
        final sortedMessages =
            _sortMessagesAscending(paginatedMessages.messages);
        messages.assignAll(sortedMessages);
        _messageIds
          ..clear()
          ..addAll(sortedMessages.map((message) => message.messageId));
        _currentPage = paginatedMessages.pageNumber;
        _hasMorePages.value = paginatedMessages.hasMorePages;
        _isInitialMessagesLoaded = true;
        if (messages.isNotEmpty) {
          _scrollToBottom();
        }
      },
    );
  }

  void _subscribeToIncomingMessages() {
    _messageSubscription =
        _chatHubService.messagesStream.listen((ConversationMessage event) {
      if (conversationId <= 0) {
        _handleConversationResolved(event.conversationId);
      }
      if (event.conversationId != conversationId) {
        return;
      }
      final incomingMessage = event.message;
      if (_messageIds.add(incomingMessage.messageId)) {
        messages.add(incomingMessage);
        messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        if (messages.isNotEmpty &&
            messages.last.messageId == incomingMessage.messageId) {
          _scrollToBottom();
        }
      } else {
        final index = messages.indexWhere(
          (message) => message.messageId == incomingMessage.messageId,
        );
        if (index != -1) {
          messages[index] = incomingMessage;
        }
      }
    });
  }

  void _scrollToBottom() {
    if (!scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      return;
    }
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 40,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  int _parseConversationId(dynamic value) {
    if (value is int) {
      return value;
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  void _handleConversationResolved(int resolvedConversationId) {
    if (resolvedConversationId <= 0) {
      return;
    }
    if (resolvedConversationId != conversationId) {
      conversationId = resolvedConversationId;
      unawaited(_chatHubService.joinConversation(resolvedConversationId));
    }
    _syncOfferConversationId(resolvedConversationId);
  }

  void _syncOfferConversationId(int resolvedConversationId) {
    if (_offerId.isEmpty) {
      return;
    }
    if (!Get.isRegistered<ProjectController>()) {
      return;
    }
    final projectController = Get.find<ProjectController>();
    if (projectController.projectId != projectId) {
      return;
    }
    projectController.updateOfferConversationId(
      offerId: _offerId,
      conversationId: resolvedConversationId,
    );
  }

  bool _areImages(List<PlatformFile> files) {
    const imageExtensions = {
      'jpg',
      'jpeg',
      'png',
      'webp',
      'gif',
      'bmp',
      'tiff',
      'tif',
      'heic',
      'heif',
      'svg',
      'ico',
      'avif',
    };
    return files.every((file) {
      final extension = file.extension?.toLowerCase();
      if (extension == null) {
        return false;
      }
      return imageExtensions.contains(extension);
    });
  }

  void _handleScroll() {
    if (!_isInitialMessagesLoaded ||
        !_hasMorePages.value ||
        isLoadingMore.value) {
      return;
    }
    if (!scrollController.hasClients) {
      return;
    }
    final position = scrollController.position;
    if (position.pixels <= position.minScrollExtent + 60) {
      _loadOlderMessages();
    }
  }

  Future<void> _loadOlderMessages() async {
    if (!_hasMorePages.value || isLoadingMore.value) {
      return;
    }
    if (!scrollController.hasClients) {
      return;
    }

    final nextPage = _currentPage + 1;
    isLoadingMore.value = true;
    final previousMaxExtent = scrollController.position.maxScrollExtent;

    final result = await ConversationServices.getMessages(
      conversationId: conversationId.toString(),
      pageNumber: nextPage,
      pageSize: _messagesPageSize,
    );

    await result.fold(
      (failure) => handleError(failure, _loadOlderMessages),
      (paginatedMessages) async {
        final sortedMessages =
            _sortMessagesAscending(paginatedMessages.messages);
        final newMessages = <MessageModel>[];
        for (final message in sortedMessages) {
          if (_messageIds.add(message.messageId)) {
            newMessages.add(message);
          }
        }
        if (newMessages.isNotEmpty) {
          messages.insertAll(0, newMessages);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!scrollController.hasClients) {
              return;
            }
            final newMaxExtent = scrollController.position.maxScrollExtent;
            final offsetDelta = newMaxExtent - previousMaxExtent;
            final targetOffset = scrollController.position.pixels + offsetDelta;
            final minExtent = scrollController.position.minScrollExtent;
            final maxExtent = scrollController.position.maxScrollExtent;
            final clampedOffset = targetOffset.clamp(minExtent, maxExtent);
            scrollController.jumpTo(clampedOffset.toDouble());
          });
        }
        _currentPage = paginatedMessages.pageNumber;
        _hasMorePages.value = paginatedMessages.hasMorePages;
      },
    );

    isLoadingMore.value = false;
  }

  List<MessageModel> _sortMessagesAscending(List<MessageModel> input) {
    final sorted = List<MessageModel>.from(input);
    sorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return sorted;
  }

  Future<void> openAttachment(MessageAttachment attachment) async {
    final url = attachment.absoluteUrl;
    if (url.isEmpty) {
      Get.snackbar(
        AppStrings.genericRetryMessage.tr,
        AppStrings.defaultError.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    final uri = Uri.parse(url);
    await launchUrl(
      uri,
      mode: LaunchMode.inAppBrowserView,
    );
  }
}
