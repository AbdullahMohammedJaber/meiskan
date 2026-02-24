 import 'package:app/app/modules/owner/owner_dashboard/controllers/counter_controller.dart';
import 'package:get/get.dart';

import '../controllers/owner_dashboard_controller.dart';

class OwnerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OwnerDashboardController>(
      () => OwnerDashboardController(),
    );
     Get.lazyPut<CountersController>(
      fenix: true,
      () => CountersController(),
    );
  }
}


