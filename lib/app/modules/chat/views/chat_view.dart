import 'package:app/app/core/utils/app_icons.dart';
import 'package:app/app/core/utils/colors_manager.dart';
import 'package:app/app/data/model/conversation.dart';
import 'package:app/app/widgets/appbar/appbar.dart';
import 'package:app/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/utils/strings_manager.dart';
import '../controllers/chat_controller.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final String _controllerTag;
  late final ChatController _controller;

  @override
  void initState() {
    super.initState();
    
    final rawArgs = Get.arguments;
    final args = (rawArgs is Map) ? rawArgs : <dynamic, dynamic>{};
    inChat = true;
    idChat = Get.arguments['projectId'];
    _controllerTag = _resolveControllerTag(args);
    _controller = Get.put(ChatController(), tag: _controllerTag);
  }

  @override
  void dispose() {
    if (Get.isRegistered<ChatController>(tag: _controllerTag)) {
      Get.delete<ChatController>(tag: _controllerTag);
    }
    inChat = false;
    idChat = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: const CustomAppBar(),
        body: Column(
          children: [
          Expanded(
  child: LayoutBuilder(
    builder: (context, constraints) {
      // Scroll to last message after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_controller.scrollController.hasClients &&
            _controller.messages.isNotEmpty) {
          _controller.scrollController.animateTo(
            _controller.scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        }
      });

      return Obx(() {
        if (_controller.isLoading.value &&
            _controller.messages.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.messages.isEmpty) {
          return Center(
            child: Text(
              AppStrings.noConversationsDescription.tr,
              style: Get.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          );
        }

        final showLoaderPlaceholder = _controller.hasMoreMessages ||
            _controller.isLoadingMore.value;
        final itemCount = _controller.messages.length +
            (showLoaderPlaceholder ? 1 : 0);

        return ListView.builder(
          controller: _controller.scrollController,
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
          physics: const BouncingScrollPhysics(),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (showLoaderPlaceholder && index == 0) {
              if (_controller.isLoadingMore.value) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: const _ListLoader(),
                );
              }
              return SizedBox(height: 16.h);
            }

            final messageIndex =
                showLoaderPlaceholder ? index - 1 : index;
            final message = _controller.messages[messageIndex];
            return _MessageBubble(
              controller: _controller,
              message: message,
              isSender: _controller.isSender(message),
            );
          },
        );
      });
    },
  ),
),
            _MessageInput(controller: _controller),
          ],
        ));
  }

  String _resolveControllerTag(Map<dynamic, dynamic> args) {
    final providedTag = args['chatTag']?.toString();
    if (providedTag != null && providedTag.isNotEmpty) {
      return providedTag;
    }
    final conversationId = args['conversationId']?.toString() ?? 'new';
    final contractorId = args['contractorId']?.toString() ?? 'unknown';
    final projectId = args['projectId']?.toString() ?? 'unknown';
    return 'chat_${conversationId}_${contractorId}_${projectId}_${DateTime.now().microsecondsSinceEpoch}';
  }
}

enum _AttachmentOption {
  image,
  file,
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.controller,
    required this.isSender,
  });

  final ChatController controller;
  final MessageModel message;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    final bubble = Flexible(
      child: Container(
        padding: EdgeInsetsDirectional.only(
          end: isSender ? 0 : 5.w,
          start: isSender ? 5.w : 0,
        ),
        decoration: BoxDecoration(
          color: isSender ? AppColors.primaryColor : const Color(0xffADADAD),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message.hasText)
                Text(
                  message.text,
                  maxLines: null,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.right,
                  style: Get.textTheme.bodySmall!.copyWith(
                    fontSize: 12.5.sp,
                    height: 1.6,
                    color: const Color(0xff2f2f2f),
                  ),
                ),
              if (message.hasText && message.attachments.isNotEmpty)
                12.verticalSpace,
              if (message.attachments.isNotEmpty)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < message.attachments.length; i++) ...[
                      _AttachmentPreview(
                        controller: controller,
                        attachment: message.attachments[i],
                      ),
                      if (i != message.attachments.length - 1) 12.verticalSpace,
                    ],
                  ],
                ),
            ],
          ),
        ),
      ),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          bottom: 18.h,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              isSender ? MainAxisAlignment.start : MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: isSender
              ? [
                  const _AvatarBadge(),
                  5.horizontalSpace,
                  bubble,
                ]
              : [
                  bubble,
                  5.horizontalSpace,
                  const _AvatarBadge(),
                ],
        ),
      ),
    );
  }
}

class _ListLoader extends StatelessWidget {
  const _ListLoader();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

class _AvatarBadge extends StatelessWidget {
  const _AvatarBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.w,
      height: 50.w,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryColor,
        ),
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        AppIcons.user,
        width: 24.w,
        color: AppColors.primaryColor,
      ),
    );
  }
}

class _AttachmentPreview extends StatelessWidget {
  const _AttachmentPreview(
      {required this.attachment, required this.controller});

  final MessageAttachment attachment;
  final ChatController controller;

  Future<void> _openAttachment() async {
    final url = attachment.absoluteUrl;
    if (url.isEmpty) {
      Get.snackbar(
        AppStrings.genericRetryMessage.tr,
        AppStrings.defaultError.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (attachment.isImage) {
      Get.to(
        () => _FullScreenImageViewer(
          attachment: attachment,
        ),
        transition: Transition.fadeIn,
      );
      return;
    }

    controller.openAttachment(attachment);
  }

  @override
  Widget build(BuildContext context) {
    final imageDimension = 160.w;
    final child = attachment.isImage
        ? ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Hero(
              tag: 'chat_attachment_image_${attachment.id}',
              child: Image.network(
                attachment.absoluteUrl,
                width: imageDimension,
                height: imageDimension,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: imageDimension,
                  height: imageDimension,
                  alignment: Alignment.center,
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.broken_image,
                    size: 28.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: imageDimension,
                    height: imageDimension,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: SizedBox(
                      width: 22.w,
                      height: 22.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        : Container(
            width: 180.w,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.insert_drive_file,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
                8.horizontalSpace,
                Expanded(
                  child: Text(
                    attachment.fileName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Get.textTheme.bodySmall!.copyWith(
                      fontSize: 11.5.sp,
                      color: const Color(0xff2f2f2f),
                    ),
                  ),
                ),
              ],
            ),
          );

    return GestureDetector(
      onTap: () => _openAttachment(),
      child: child,
    );
  }
}

class _MessageInput extends StatelessWidget {
  const _MessageInput({required this.controller});

  final ChatController controller;

  Future<void> _onAttachmentPressed(BuildContext context) async {
    if (controller.isUploadingAttachment.value) {
      return;
    }

    Get.focusScope?.unfocus();

    final selection = await showModalBottomSheet<_AttachmentOption>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(18.r),
        ),
      ),
      builder: (sheetContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 12.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    leading: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image_outlined,
                        color: AppColors.primaryColor,
                        size: 22.sp,
                      ),
                    ),
                    horizontalTitleGap: 12.w,
                    title: Text(
                      AppStrings.attachImage.tr,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        color: const Color(0xff2f2f2f),
                      ),
                    ),
                    onTap: () =>
                        Navigator.of(sheetContext).pop(_AttachmentOption.image),
                  ),
                  ListTile(
                    leading: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.insert_drive_file_outlined,
                        color: AppColors.primaryColor,
                        size: 22.sp,
                      ),
                    ),
                    horizontalTitleGap: 12.w,
                    title: Text(
                      AppStrings.attachFile.tr,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        color: const Color(0xff2f2f2f),
                      ),
                    ),
                    onTap: () =>
                        Navigator.of(sheetContext).pop(_AttachmentOption.file),
                  ),
                  4.verticalSpace,
                ],
              ),
            ),
          ),
        );
      },
    );

    if (selection == null) {
      return;
    }

    final fileType =
        selection == _AttachmentOption.image ? FileType.image : FileType.any;

    await controller.pickAndUploadFiles(fileType: fileType);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: controller.messageController,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                    ),
                    filled: false,
                    suffixIcon: Obx(() {
                      final isUploading =
                          controller.isUploadingAttachment.value;
                      return IconButton(
                        onPressed: isUploading
                            ? null
                            : () => _onAttachmentPressed(context),
                        icon: isUploading
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primaryColor,
                                ),
                              )
                            : SvgPicture.asset(
                                AppIcons.attachment,
                                width: 20.w,
                                color: AppColors.primaryColor,
                              ),
                      );
                    }),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(
                          color: AppColors.primaryColor, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(
                          color: AppColors.primaryColor, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(
                          color: AppColors.primaryColor, width: 1.5),
                    ),
                    hintText: AppStrings.messageHint.tr,
                  ),
                  style: Get.textTheme.bodySmall!.copyWith(
                    fontSize: 14.sp,
                  ),
                  minLines: 1,
                  maxLines: 4,
                ),
              ),
              10.horizontalSpace,
              GestureDetector(
                onTap: () => controller.sendMessage(),
                child: Container(
                  width: 50.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(13.w),
                  child: SvgPicture.asset(
                    AppIcons.send,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FullScreenImageViewer extends StatelessWidget {
  const _FullScreenImageViewer({required this.attachment});

  final MessageAttachment attachment;

  @override
  Widget build(BuildContext context) {
    final imageUrl = attachment.absoluteUrl;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          attachment.fileName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Get.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontSize: 14.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: imageUrl.isEmpty
              ? Text(
                  AppStrings.genericRetryMessage.tr,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                )
              : Hero(
                  tag: 'chat_attachment_image_${attachment.id}',
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 4,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.black,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.broken_image,
                          size: 48.sp,
                          color: Colors.white70,
                        ),
                      ),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          alignment: Alignment.center,
                          color: Colors.black,
                          child: SizedBox(
                            width: 36.w,
                            height: 36.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
