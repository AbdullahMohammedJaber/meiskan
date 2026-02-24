import 'package:get/get.dart';

import '../controllers/contractor_profile_details_controller.dart';

class ContractorProfileDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContractorProfileDetailsController>(
      () => ContractorProfileDetailsController(),
    );
  }
}
