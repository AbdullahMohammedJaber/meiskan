import 'package:get/get.dart';

class CountersController extends GetxController {

  /// Reactive variables
  RxInt  unreadNotifications = 0.obs;
  RxInt  unreadMessages = 0.obs;
  RxInt  totalProject = 0.obs;
  RxInt  allowProject = 0.obs;


  /// Set initial values from API
  void setCounters({
    required int notifications,
    required int messages,
    required int total_project,
    required int allow_project,

  }) {
    unreadNotifications.value = notifications;
    unreadMessages.value = messages;
    allowProject.value = allow_project;
    totalProject.value = total_project;
  }

  /// Increment / Decrement
  void incrementNotifications() => unreadNotifications++;
  void decrementNotifications() {
    if (unreadNotifications > 0) unreadNotifications--;
  }

  void incrementMessages() => unreadMessages++;
  void decrementMessages() {
    if (unreadMessages > 0) unreadMessages--;
  }

  /// Reset
  void resetNotifications() => unreadNotifications.value = 0;
  void resetMessages() => unreadMessages.value = 0;
}