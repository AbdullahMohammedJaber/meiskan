import 'package:get/get.dart';

import '../controllers/contractor_dashboard_controller.dart';

class ContractorDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContractorDashboardController>(
      () => ContractorDashboardController(),
    );
  }
}
