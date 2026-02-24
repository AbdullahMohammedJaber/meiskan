import 'dart:ui';

import 'package:app/app/core/extensions/enums_ex.dart';
import 'package:app/app/data/locale/preferences_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart' show GetStorage;

import '../../core/enums/enums.dart';

abstract class AppPreferences {
  Future init();

  void dispose();

  Future<LANGUAGE> getLanguage();

  void changeLanguage(LANGUAGE language, {bool changeIsNewUser = true});

  T? read<T>(String key);

  void write(String key, dynamic val);

  LANGUAGE defaultLanguage = LANGUAGE.arabic;

  bool isNewUser = false;
  String token = "";
 
}

class AppPreferencesImpl extends AppPreferences {
  late GetStorage storage;

  AppPreferencesImpl() {
    storage = GetStorage();
  }

  @override
  Future<LANGUAGE> getLanguage() async {
    if (kDebugMode) {
      defaultLanguage = LANGUAGE.arabic;
      return defaultLanguage;
    }
    Locale deviceLocale = PlatformDispatcher.instance.locale;

    if (deviceLocale.languageCode == "ar") {
      defaultLanguage = LANGUAGE.arabic;
    } else if (deviceLocale.languageCode == "en") {
      defaultLanguage = LANGUAGE.english;
    }

    return defaultLanguage;
  }

  @override
  void changeLanguage(LANGUAGE language, {bool changeIsNewUser = true}) {
    defaultLanguage = language;
    write(PreferencesKeys.language, language.getLocal.languageCode);
    if (changeIsNewUser) {
      isNewUser = false;
    }
  }

  @override
  Future init() async {
    isNewUser = (read(PreferencesKeys.isNewUser) ?? '').isEmpty;
    if (isNewUser) {
      await storage.erase();
      write(PreferencesKeys.isNewUser, "false");
    }
    token = read(PreferencesKeys.token) ?? '';
   

    getLanguage();
  }

  @override
  void dispose() async {
    storage.erase();
    write(PreferencesKeys.isNewUser, "false");
  }

  @override
  T? read<T>(String key) {
    return storage.read<T>(key);
  }

  @override
  write(String key, dynamic val) {
    storage.write(key, val);
  }
}
setFcmToken(String fcmToken) {
  GetStorage().write("fcm_token", fcmToken);
}

String? getFcmToken() {
  return GetStorage().read("fcm_token") ?? "";
}