import 'package:get/get.dart';

import '../../../services/chat_hub_service.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ChatHubService>()) {
      Get.put(ChatHubService(), permanent: true);
    }
  }
}
