import 'dart:async';

import 'package:app/app/config/routes/app_pages.dart';
import 'package:app/app/core/base/base_viewmodel.dart';
import 'package:app/app/core/utils/app_snackbar.dart';
import 'package:app/app/core/utils/phone_utils.dart';
import 'package:app/app/core/utils/strings_manager.dart';
import 'package:app/app/gobal_controllers/user_controller.dart';
import 'package:app/app/services/auth_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends BaseController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxBool loading = false.obs;
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

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    passwordController.dispose();
  }

  Future login() async {
    if (!formKey.currentState!.validate()) return;
    loading(true);
    final phone = PhoneUtils.formatKuwaitPhone(phoneController.text);
    (await AuthServices.login(
      phoneNumber: phone,
      password: passwordController.text.trim(),
    ))
        .fold(
      (l) {
        loading(false);
        handleError(l, () => login());
      },
      (r) {
       

        loading(true);
        Get.find<UserController>().onLogin(r);
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
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      final isValid = otpCode.value == '123456';

      if (isValid) {
        appSnackbar(AppStrings.success.tr, type: SnackbarType.SUCCESS);
        Get.offAllNamed(Routes.HOME);
      } else {
        appSnackbar(AppStrings.invalidOtpCode.tr, type: SnackbarType.ERROR);
      }
    } finally {
      verifyingOtp(false);
    }
  }
}
