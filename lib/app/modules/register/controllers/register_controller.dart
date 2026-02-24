import 'dart:async';

import 'package:app/app/config/routes/app_pages.dart';
import 'package:app/app/core/base/base_viewmodel.dart';
import 'package:app/app/core/enums/enums.dart';
import 'package:app/app/core/utils/app_snackbar.dart';
import 'package:app/app/core/utils/phone_utils.dart';
import 'package:app/app/core/utils/strings_manager.dart';
import 'package:app/app/services/auth_services.dart';
import 'package:app/app/services/device_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/register_otp_view.dart';

class RegisterController extends BaseController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final Rx<AccountType?> selectedAccountType = Rx<AccountType?>(null);
  final RxBool loading = false.obs;
  final RxString otpCode = ''.obs;
  final RxBool verifyingOtp = false.obs;

  bool get canSubmitOtp => otpCode.value.length == 6 && !verifyingOtp.value;

  String get phoneObscured {
    String phone = phoneController.text.trim();
    if (phone.length < 4) return phone;
    String firstTwo = phone.substring(0, 2);
    String lastTwo = phone.substring(phone.length - 2);
    String obscured = '*' * (phone.length - 4);
    return '$firstTwo$obscured$lastTwo';
  }

  void selectAccountType(AccountType? type) {
    selectedAccountType.value = type;
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Map) {
      if (Get.arguments['user_type'] is AccountType) {
        selectedAccountType.value = Get.arguments['user_type'] as AccountType;
      }
    }
  }

  List<AccountType> get accountTypes => [
        AccountType.owner,
        AccountType.contractor,
      ];

  Future<void> register() async {
    /* if (kDebugMode) {
      if (selectedAccountType.value == AccountType.owner) {
        Get.offAllNamed(Routes.OWNER_DASHBOARD);
      } else {
        Get.offAllNamed(Routes.CONTRACTOR_HOME);
      }
      return;
    }*/
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (selectedAccountType.value == null) {
      appSnackbar(AppStrings.selectAccountType.tr, type: SnackbarType.ERROR);
      return;
    }

    loading(true);
    FocusManager.instance.primaryFocus?.unfocus();

    final email = emailController.text.trim();
    final phone = PhoneUtils.formatKuwaitPhone(phoneController.text);
    final fullName = fullNameController.text.trim();
    final password = passwordController.text.trim();
    final isContractor = selectedAccountType.value == AccountType.contractor;

    (await AuthServices.signin(
      email: email,
      password: password,
      fullName: fullName,
      phoneNumber: phone,
      type: isContractor,
    ))
        .fold(
      (l) {
        loading(false);
        handleError(l, () => register());
      },
      (r) {
        loading(false);
        appSnackbar(AppStrings.registrationSuccessful.tr,
            type: SnackbarType.SUCCESS);
        Get.to(() => const RegisterOtpView());
      },
    );
  }

  void onOtpChanged(String code) {
    otpCode.value = code.trim();
  }

  Future<void> validateOtp() async {
    if (!canSubmitOtp) return;

    if (!(otpFormKey.currentState?.validate() ?? true)) {
      return;
    }

    verifyingOtp(true);
    (await AuthServices.verifyAccount(
      phoneNumber: PhoneUtils.formatKuwaitPhone(phoneController.text),
      codeNumber: otpCode.value,
    ))
        .fold(
      (l) {
        verifyingOtp(false);
        handleError(l, () => validateOtp());
      },
      (r) {
        verifyingOtp(false);
        if (r) {
          appSnackbar(AppStrings.loginSuccessfully.tr, type: SnackbarType.SUCCESS);
          unawaited(DeviceServices.saveToken());
          Get.offAllNamed(Routes.LOGIN);
        } else {
          appSnackbar(AppStrings.invalidOtpCode.tr, type: SnackbarType.ERROR);
        }
      },
    );
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
