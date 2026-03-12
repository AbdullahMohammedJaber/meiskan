import 'package:get/get.dart';

import 'strings_manager.dart';

class Validator {
  static String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.invalidName.tr;
    }
    return null;
  }

  static String? durationValidator(String? value) {
    if (value == null || (int.tryParse(value) ?? 0) <= 0) {
      return AppStrings.invalidDuration.tr;
    }
    return null;
  }
  //fieldValidator
  static String? fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired.tr;
    }
    return null;
  }
  static String? numberValidator(String? value) {
    if (value == null || (int.tryParse(value) ?? 0) <= 0) {
      return AppStrings.invalidNumber.tr;
    }
    return null;
  }
 static String? optionalEmailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return emailValidator(value.trim());
  }
  static String? surfaceValidator(String? value) {
    if (value == null || (int.tryParse(value) ?? 0) <= 0) {
      return AppStrings.invalidSurface.tr;
    }
    return null;
  }

  static String? offerTypeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.pleaseEnterOfferType.tr;
    }
    return null;
  }

  static String? offerCategoryValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.pleaseEnterCategory.tr;
    }
    return null;
  }

  static String? propertyTypeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.pleaseEnterPropertyType.tr;
    }
    return null;
  }

  static String? wilayaValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.invalidWilaya.tr;
    }
    return null;
  }

  static String? communeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.invalidCommune.tr;
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.invalidEmail.tr;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return AppStrings.invalidEmailFormat.tr;
    }
    return null;
  }

 static String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return AppStrings.invalidPassword.tr;
  }

  if (value.length < 6) {
    return AppStrings.passwordLengthError.tr;
  }

  // يحتوي على حرف كبير
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return "يجب أن تحتوي كلمة المرور على حرف كبير";
  }

  // يحتوي على حرف صغير
  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return "يجب أن تحتوي كلمة المرور على حرف صغير";
  }

  // يحتوي على رقم
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return "يجب أن تحتوي كلمة المرور على رقم";
  }

  // يحتوي على رمز
  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
    return "يجب أن تحتوي كلمة المرور على رمز";
  }

  return null;
}

  static String? phoneValidator(String? value) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return AppStrings.invalidPhone.tr;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(normalized)) {
      return AppStrings.invalidPhoneFormat.tr;
    }
    if (normalized.length != 8) {
      return AppStrings.phoneLengthError.tr;
    }
    return null;
  }

  static String? smsCodeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.invalidOtpCode.tr;
    } else if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
      return AppStrings.invalidOtpCodeFormat.tr;
    }
    return null;
  }

  static String? confirmPasswordValidator(
      String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return AppStrings.confirmPasswordEmpty.tr;
    } else if (password != confirmPassword) {
      return AppStrings.passwordsDoNotMatch.tr;
    }
    return null;
  }

  static String? addressValidator(String? address) {
    if (address == null) {
      return AppStrings.invalidAddress.tr;
    }
    if (address.length < 3) {
      return AppStrings.addressShouldBeMoreThan3Chars.tr;
    }

    return null;
  }

  static String? priceValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.invalidPrice.tr;
    }

    final String normalizedValue = value.replaceAll(',', '.');
    final double? parsedValue = double.tryParse(normalizedValue);

    if (parsedValue == null || parsedValue <= 0) {
      return AppStrings.invalidPriceFormat.tr;
    }

    return null;
  }


}
