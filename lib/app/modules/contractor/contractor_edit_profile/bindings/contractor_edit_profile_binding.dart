import 'package:get/get.dart';

import '../controllers/contractor_edit_profile_controller.dart';

class ContractorEditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContractorEditProfileController>(
      () => ContractorEditProfileController(),
    );
  }
}
