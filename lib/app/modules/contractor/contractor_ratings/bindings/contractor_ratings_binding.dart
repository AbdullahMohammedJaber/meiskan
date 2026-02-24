import 'package:get/get.dart';

import '../controllers/contractor_ratings_controller.dart';

class ContractorRatingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContractorRatingsController>(
      () => ContractorRatingsController(),
    );
  }
}
