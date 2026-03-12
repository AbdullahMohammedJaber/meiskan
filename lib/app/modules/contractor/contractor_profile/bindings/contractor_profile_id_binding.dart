import 'package:app/app/modules/contractor/contractor_profile/controllers/contractor_profile_id_controller.dart';
import 'package:get/get.dart';

class ContractorProfileIdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContractorProfileIdController>(
      () => ContractorProfileIdController(),
    );
  }
}
