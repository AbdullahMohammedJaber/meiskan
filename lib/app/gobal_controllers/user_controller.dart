import 'dart:async';

import 'package:app/app/core/base/base_viewmodel.dart';
 import 'package:app/app/data/model/user.dart';
import 'package:app/app/data/network/responses/responses.dart';
import 'package:app/app/services/device_services.dart';
import 'package:app/app/services/user_services.dart';
import 'package:get/get.dart';

import '../config/routes/app_pages.dart';
import '../core/enums/enums.dart';
import '../data/locale/locale_provider.dart';
import '../data/locale/preferences_keys.dart';


class UserController extends BaseController {
  Rx<UserModel?> user = Rx(null);

  Future getUser() async {
    final uid = Get.find<AppPreferences>().read<String>(PreferencesKeys.uid);

    if (uid == null) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    (await UserServices.getUser(uid)).fold(
      (l) {
        handleError(l, () => getUser());
      },
      (r) {
        user.value = r;
      },
    );
  }

  void onLogin(AuthResponse response) {
    user(response.user);
    final preferences = Get.find<AppPreferences>();
    preferences.token = response.token;

    preferences.write(PreferencesKeys.token, response.token);
    preferences.write(PreferencesKeys.uid, response.user.id);
    preferences.write(PreferencesKeys.user, response.user.toJson());
    unawaited(DeviceServices.saveToken());
    if (user()!.type == AccountType.owner) {
      Get.offAllNamed(Routes.OWNER_DASHBOARD);
    } else {
      Get.offAllNamed(Routes.CONTRACTOR_HOME);
    }
  }

  void onLogout() {
    user.value=null;
    Get.find<AppPreferences>().dispose();
    Get.offAllNamed(Routes.HOME);
  }
}
