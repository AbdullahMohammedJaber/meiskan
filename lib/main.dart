import 'dart:async';

import 'package:app/app/core/enums/enums.dart';
import 'package:app/app/core/extensions/enums_ex.dart';
import 'package:app/app/data/locale/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app/config/routes/app_pages.dart';
import 'app/config/themes/light_theme.dart';
import 'app/config/translations/app_translations.dart';
import 'app/core/constants.dart';
import 'app/core/init_app.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await initApp();

    runApp(
      Phoenix(
        child: ScreenUtilInit(
          useInheritedMediaQuery: true,
          designSize: const Size(430, 932),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => child!,
          child: const MyApp(),
        ),
      ),
    );
  }, (error, stack) {
    debugPrint('errorerror => $error');
    debugPrint('stackstack => $stack');
   // FirebaseCrashlytics.instance.recordError(error, stack);
    throw error;
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: LANGUAGE.values.map((e) => e.getLocal),
      locale: Get.find<AppPreferences>().defaultLanguage.getLocal,
      fallbackLocale: LANGUAGE.arabic.getLocal,
      translations: Get.find<AppTranslation>(),
      translationsKeys: Get.find<AppTranslation>().keys,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: getLightThemeData(),
      defaultTransition: Transition.cupertino,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
bool inChat = false;
dynamic idChat = 0;
/*
Contractor => 98038286

Owner => 51675316 | 60905064

P@ssw0rd
 */

