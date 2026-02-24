import 'package:get/get.dart';

import '../../../config/routes/app_pages.dart';
import '../../../core/base/base_viewmodel.dart';
import '../../../data/locale/locale_provider.dart';
import '../../../middlwares/user_middleware.dart';

class SplashController extends BaseController {
  @override
  onInit() {
    super.onInit();
    _redirectIfRestartingApp();
  }

  Future<String> redirect() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final appPreferences = Get.find<AppPreferences>();

    bool isNewUser = appPreferences.isNewUser;
    final String route;
    if (isNewUser || appPreferences.token.isEmpty) {
      route = Routes.HOME;
    } else {
      route = await UserMiddleWare.getRoute();
    }

    return route;
  }

  void _redirectIfRestartingApp() async {
    Get.offAllNamed(await redirect());
  }
}
