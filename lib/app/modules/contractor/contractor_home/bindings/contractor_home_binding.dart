import 'package:app/app/modules/contractor/contractor_home/controllers/counter_controller.dart';
 import 'package:get/get.dart';

import '../controllers/contractor_home_controller.dart';

class ContractorHomeBinding extends Bindings {
  @override
  void dependencies() {
       Get.lazyPut<CountersControllerContractor>(
      fenix: true,
      () => CountersControllerContractor(),
    );
    
    Get.lazyPut<ContractorHomeController>(
      () => ContractorHomeController(),
    );
  
  }
}
