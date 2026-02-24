 
import 'package:get/get.dart';

import '../../core/base/base_viewmodel.dart';
 

class TopDrawerController extends BaseController {
  static TopDrawerController get to => Get.find();

  final isDrawerOpen = false.obs;

  void toggleDrawer() {
    isDrawerOpen.value = !isDrawerOpen.value;
  }

  void closeDrawer() {
    isDrawerOpen.value = false;
  }
}