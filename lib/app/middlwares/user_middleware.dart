import 'package:app/app/core/enums/enums.dart';
import 'package:app/app/gobal_controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../config/routes/app_pages.dart';
import '../data/locale/locale_provider.dart';
import '../data/locale/preferences_keys.dart';

class UserMiddleWare extends StatefulWidget {
  const UserMiddleWare({super.key});

  @override
  State<UserMiddleWare> createState() => _UserMiddleWareState();

  static Future<String> getRoute() async {
    final uid = await Get.find<AppPreferences>().read(PreferencesKeys.uid);

    if (uid.isEmpty) {
      return Routes.LOGIN;
    }

    await Get.find<UserController>().getUser();
    final user = Get.find<UserController>().user.value;

    if (user == null) {
      return Routes.HOME;
    } else if (user.type==AccountType.owner){
      return Routes.OWNER_DASHBOARD;
    }else {
      return Routes.CONTRACTOR_HOME;
    }
  }
}

class _UserMiddleWareState extends State<UserMiddleWare> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      init();
    });
  }

  Future init() async {
    Get.offAllNamed(await UserMiddleWare.getRoute());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
