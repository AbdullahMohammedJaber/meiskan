import 'package:get/get.dart';

import '../controllers/conversations_controller.dart';

class ConversationsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConversationsController>(
      () => ConversationsController(),
    );
  }
}
