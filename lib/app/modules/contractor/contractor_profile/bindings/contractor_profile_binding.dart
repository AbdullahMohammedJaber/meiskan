import 'package:get/get.dart';

import '../controllers/contractor_profile_controller.dart';

class ContractorProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContractorProfileController>(
      () => ContractorProfileController(),
    );
  }
}
