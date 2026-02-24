import 'package:get/get.dart';

class CountersController extends GetxController {

  /// Reactive variables
  RxInt  unreadNotifications = 0.obs;
  RxInt  unreadMessages = 0.obs;

  /// Set initial values from API
  void setCounters({
    required int notifications,
    required int messages,
  }) {
    unreadNotifications.value = notifications;
    unreadMessages.value = messages;
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