// ignore_for_file: unused_element

import 'dart:io';

import 'package:app/app/core/base/base_viewmodel.dart';
import 'package:app/app/core/utils/app_snackbar.dart';
import 'package:app/app/core/utils/strings_manager.dart';
import 'package:app/app/data/model/detailed_project.dart';
import 'package:app/app/data/model/offer.dart';
import 'package:app/app/data/network/end_points.dart';
import 'package:app/app/services/project_services.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectController extends BaseController {
  RxInt selectedTabIndex = 0.obs;

  final Rx<DetailedProjectModel?> projectDetails = Rx(null);
  late final String projectId;

  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final Rx<DownloadStatus> downloadStatus = DownloadStatus.idle.obs;
  final RxDouble downloadProgress = 0.0.obs;
  final PageController imagePageController = PageController();
  final RxInt currentImageIndex = 0.obs;

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    // Get project ID from parameters
    projectId = Get.parameters['id'] ?? '';
    if (projectId.isNotEmpty) {
      getProjectDetails();
    }
    // Initialize with project details tab
    selectedTabIndex.value = 0;
  }

  // Fetch project details
  Future<void> getProjectDetails() async {
    if (projectId.isEmpty) return;

    isLoading.value = true;

    final result =
        await ProjectServices.getProjectDetails(projectId: projectId);

    result.fold(
      (failure) {
        hasError.value = true;
        handleError(failure, getProjectDetails);
      },
      (project) {
        projectDetails.value = project;
        currentImageIndex.value = 0;
        if (imagePageController.hasClients) {
          imagePageController.jumpToPage(0);
        }
      },
    );

    isLoading.value = false;
  }

  void onImagePageChanged(int index) {
    currentImageIndex.value = index;
  }

  void retry() {
    getProjectDetails();
  }

  void updateOfferConversationId({
    required String offerId,
    required int conversationId,
  }) {
    if (offerId.isEmpty || conversationId <= 0) {
      return;
    }

    final details = projectDetails.value;
    if (details == null) {
      return;
    }

    final offers = List<ProjectOffer>.from(details.offers);
    final index = offers.indexWhere((offer) => offer.offerId == offerId);
    if (index == -1) {
      return;
    }

    final currentOffer = offers[index];
    if (currentOffer.conversationId == conversationId) {
      return;
    }

    offers[index] = currentOffer.copyWith(conversationId: conversationId);
    projectDetails.value = details.copyWith(offers: offers);
  }

  Future<void> downloadPdf() async {
    final details = projectDetails.value;

    if (downloadStatus.value == DownloadStatus.loading) {
      return;
    }

    downloadStatus.value = DownloadStatus.loading;
    downloadProgress.value = 0.0;

    try {
      launchUrl(
        Uri.parse(details!.fileUrl!),
        mode: LaunchMode.inAppBrowserView,
      );
      return;
      /*final hasPermission = await _ensureStoragePermission();
      if (!hasPermission) {
        downloadStatus.value = DownloadStatus.error;
        appSnackbar(AppStrings.storagePermissionRequired.tr,
            type: SnackbarType.ERROR);
        return;
      }

      final targetDirectory = await _resolveDownloadDirectory();
      if (targetDirectory == null) {
        downloadStatus.value = DownloadStatus.error;
        appSnackbar(AppStrings.downloadFailed.tr, type: SnackbarType.ERROR);
        return;
      }

      final savedPath = await _downloadFile(
        fileDescriptor: details!.fileUrl!,
        directory: targetDirectory,
      );

      if (savedPath == null) {
        downloadStatus.value = DownloadStatus.error;
        appSnackbar(AppStrings.downloadFailed.tr, type: SnackbarType.ERROR);
        return;
      }

      downloadStatus.value = DownloadStatus.success;
      await OpenFile.open(savedPath);*/
    } on dio.DioException catch (_) {
      downloadStatus.value = DownloadStatus.error;
      appSnackbar(AppStrings.downloadFailed.tr, type: SnackbarType.ERROR);
    } catch (_) {
      downloadStatus.value = DownloadStatus.error;
      appSnackbar(AppStrings.downloadFailed.tr, type: SnackbarType.ERROR);
    } finally {
      if (downloadStatus.value == DownloadStatus.loading) {
        downloadStatus.value = DownloadStatus.idle;
      }

      Future.delayed(const Duration(seconds: 2), () {
        if (downloadStatus.value != DownloadStatus.loading) {
          downloadStatus.value = DownloadStatus.idle;
          downloadProgress.value = 0.0;
        }
      });
    }
  }

  Future<bool> _ensureStoragePermission() async {
    if (!Platform.isAndroid) {
      return true;
    }

    final status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    }

    final result = await Permission.storage.request();
    return result.isGranted;
  }

  Future<Directory?> _resolveDownloadDirectory() async {
    try {
      if (Platform.isAndroid) {
        final downloads = await getExternalStorageDirectories(
          type: StorageDirectory.documents,
        );

        if (downloads != null && downloads.isNotEmpty) {
          final directory = downloads.first;
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          return directory;
        }

        final fallback = await getExternalStorageDirectory();
        if (fallback != null && !await fallback.exists()) {
          await fallback.create(recursive: true);
        }
        return fallback;
      }

      final documents = await getApplicationDocumentsDirectory();
      if (!await documents.exists()) {
        await documents.create(recursive: true);
      }
      return documents;
    } catch (_) {
      return null;
    }
  }

  Future<String?> _downloadFile({
    required String fileDescriptor,
    required Directory directory,
  }) async {
    final dioClient = Get.find<dio.Dio>();
    final fileName = _deriveFileName(fileDescriptor);
    final destinationPath = '${directory.path}/$fileName';

    final candidates = _buildCandidateUrls(fileDescriptor);

    for (final url in candidates) {
      try {
        await dioClient.download(
          url,
          destinationPath,
          onReceiveProgress: (received, total) {
            if (total > 0) {
              downloadProgress.value = received / total;
            }
          },
        );
        return destinationPath;
      } on dio.DioException {
        if (identical(url, candidates.last)) {
          rethrow;
        }
      }
    }

    return null;
  }

  List<String> _buildCandidateUrls(String fileDescriptor) {
    final uri = Uri.tryParse(fileDescriptor);
    if (uri != null && uri.hasScheme) {
      return [uri.toString()];
    }

    final sanitized = fileDescriptor.startsWith('/')
        ? fileDescriptor.substring(1)
        : fileDescriptor;

    final baseApi = Uri.parse(EndPoints.baseApiUrl);
    final rootBase = baseApi.replace(pathSegments: []);

    return {
      baseApi.resolve(sanitized).toString(),
      rootBase.resolve(sanitized).toString(),
    }.toList();
  }

  String _deriveFileName(String descriptor) {
    final uri = Uri.tryParse(descriptor);
    String candidate;

    if (uri != null) {
      candidate = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
    } else {
      final parts = descriptor.split('/');
      candidate = parts.isNotEmpty ? parts.last : '';
    }

    if (candidate.isEmpty) {
      candidate = 'project_$projectId.pdf';
    }

    if (!candidate.contains('.')) {
      candidate = '$candidate.pdf';
    }

    return '${projectId}_$candidate';
  }

  @override
  void onClose() {
    imagePageController.dispose();
    super.onClose();
  }
}

enum DownloadStatus { idle, loading, success, error }
