import 'package:get/get.dart';

import '../controllers/add_offer_controller.dart';

class AddOfferBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddOfferController>(
      () => AddOfferController(),
    );
  }
}
