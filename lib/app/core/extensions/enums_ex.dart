import 'package:app/app/core/utils/app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../enums/enums.dart';
 import '../utils/strings_manager.dart';

extension LanguageEx on LANGUAGE {
  String get getText {
    switch (this) {
      case LANGUAGE.arabic:
        return AppStrings.arabic;
      case LANGUAGE.english:
        return AppStrings.english;
    }
  }

  String get getIcon {
    switch (this) {
      case LANGUAGE.arabic:
        return AppIcons.kw;
      case LANGUAGE.english:
        return AppIcons.uk;
    }
  }


  Locale get getLocal {
    switch (this) {
      case LANGUAGE.arabic:
        return const Locale('ar', "SA");
      case LANGUAGE.english:
        return const Locale('en', "US");
    }
  }
}

extension AccountTypeEx on AccountType {
  String get getName {
    switch (this) {
      case AccountType.owner:
        return AppStrings.owner.tr;
      case AccountType.contractor:
        return AppStrings.contractor.tr;
    }
  }
}

extension EnumStringsEx on String {
  UserStatus get toUserStatus {
    switch (this) {
      case 'active':
        return UserStatus.active;
      case 'blocked':
        return UserStatus.blocked;
      default:
        return UserStatus.blocked;
    }
  }


}



extension UserStatusEx on UserStatus {
  String get getKey {
    switch (this) {
      case UserStatus.active:
        return 'active';
      case UserStatus.blocked:
        return 'blocked';
    }
  }
}



