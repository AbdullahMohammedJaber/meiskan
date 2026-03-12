import 'package:app/app/core/base/base_viewmodel.dart';
import 'package:app/app/data/model/notification.dart';
import 'package:app/app/services/notification_services.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

class NotificationsController extends BaseController {
  final notifications = <NotificationModel>[].obs;
  final hasError = false.obs;
  final isLoading = false.obs;
  final currentPage = 0.obs;
  final hasMoreData = true.obs;
  final itemsPerPage = 10; // Define items per page

  @override
  onInit() {
    fetch(refresh: true);
    super.onInit();
  }

  Future<void> fetch({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      notifications.clear();
    } else if (!refresh && currentPage.value == 0) {
      currentPage.value = 1;
    }

    if (!refresh && !hasMoreData.value) {
      return;
    }
    isLoading.value = true;
    hasError.value = false;

    Either failureOrSuccess = await NotificationServices.getUserNotifications(
      page: currentPage.value,
      pageSize: itemsPerPage,
    );

    isLoading.value = false;
    failureOrSuccess.fold(
      (failure) {
        hasError.value = true;
        handleError(failure, () => fetch(refresh: refresh));
      },
      (fetchedNotifications) {
        if (fetchedNotifications.isEmpty) {
          hasMoreData.value = false;
        } else {
          notifications.addAll(fetchedNotifications);
          currentPage.value++;
          if (fetchedNotifications.length < itemsPerPage) {
            hasMoreData.value = false;
          }
        }
        NotificationServices
            .markAsRead(); // Mark all notifications as read when fetched
      },
    );
  }

/*  Future<void> loadMore() async {
    if (hasMoreData.value && !isLoading.value) {
      await fetch(refresh: false);
    }
  }*/
}
