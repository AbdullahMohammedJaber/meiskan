import 'package:app/app/data/locale/locale_provider.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../firebase_options.dart';
import '../config/translations/app_translations.dart';
import '../gobal_controllers/buy_points_controller.dart';
import '../gobal_controllers/user_controller.dart';
import 'fcm/fcm.dart';
import 'network/dio_factory.dart';
import 'network/network_info.dart';

Future initApp() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();

  await NotificationService().init();

  FirebaseMessaging.onBackgroundMessage(NotificationService.firebaseMessagingBackgroundHandler);
   Get.put<AppPreferences>(AppPreferencesImpl(), permanent: true);
  Get.put<UserController>(UserController(), permanent: true);
  Get.put<BuyPointsController>(BuyPointsController(), permanent: true);
  Get.put<AppTranslation>(AppTranslation(), permanent: true);

  Get.lazyPut(() => NetworkInfoImpl(InternetConnectionChecker()));

  await Get.find<AppPreferences>().init();

  Get.lazyPut(() => DioFactory());

  Dio dio = Get.find<DioFactory>().getDio();
  Get.put<Dio>(dio);
}
