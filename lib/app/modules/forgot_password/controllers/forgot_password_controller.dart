import 'package:app/app/config/routes/app_pages.dart';
import 'package:app/app/core/base/base_viewmodel.dart';
import 'package:app/app/core/utils/app_snackbar.dart';
import 'package:app/app/core/utils/phone_utils.dart';
import 'package:app/app/core/utils/strings_manager.dart';
import 'package:app/app/services/auth_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends BaseController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> newPasswordFormKey = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  RxBool loading = false.obs;
  RxBool verifyingOtp = false.obs;
  RxBool resettingPassword = false.obs;
  final RxString otpCode = ''.obs;

  bool get canSubmitOtp => otpCode.value.length == 6 && !verifyingOtp.value;

  bool get passwordsMatch =>
      newPasswordController.text == confirmPasswordController.text;

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
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  Future<void> sendResetCode() async {
    if (!formKey.currentState!.validate()) return;

    final phone = PhoneUtils.formatKuwaitPhone(phoneController.text);
    loading(true);
    (await AuthServices.forgotPassword(
      phone: phone,
    ))
        .fold(
      (l) {
        loading(false);
        handleError(l, () => sendResetCode());
      },
      (r) {
        loading(false);
        appSnackbar(AppStrings.otpTitle.tr, type: SnackbarType.SUCCESS);
        Get.toNamed(Routes.FORGOT_PASSWORD_OTP);
      },
    );
  }

  void onOtpChanged(String code) {
    otpCode.value = code.trim();
  }

  Future<void> verifyResetCode() async {
    if (!canSubmitOtp) return;

    if (!(otpFormKey.currentState?.validate() ?? true)) {
      return;
    }

    final phone = PhoneUtils.formatKuwaitPhone(phoneController.text);
    verifyingOtp(true);
    (await AuthServices.verifyCodeResetPassword(
      phoneNumber: phone,
      codeNumber: otpCode.value,
    ))
        .fold(
      (l) {
        verifyingOtp(false);
        handleError(l, () => verifyResetCode());
      },
      (r) {
        verifyingOtp(false);
        if (r) {
          Get.toNamed(Routes.RESET_PASSWORD);
        } else {
          appSnackbar(AppStrings.invalidOtpCode.tr, type: SnackbarType.ERROR);
        }
      },
    );
  }

  Future<void> resetPassword() async {
    if (!newPasswordFormKey.currentState!.validate()) return;
    if (!passwordsMatch) {
      appSnackbar(AppStrings.passwordsDoNotMatch.tr, type: SnackbarType.ERROR);
      return;
    }

    final phone = PhoneUtils.formatKuwaitPhone(phoneController.text);
    resettingPassword(true);
    (await AuthServices.resetPassword(
      newPassword: newPasswordController.text.trim(),
      phone: phone,
    ))
        .fold(
      (l) {
        resettingPassword(false);
        handleError(l, () => resetPassword());
      },
      (r) {
        resettingPassword(false);
        if (r) {
          appSnackbar(AppStrings.passwordUpdatedSuccessfully.tr,
              type: SnackbarType.SUCCESS);
          Get.offAllNamed(Routes.LOGIN);
        } else {
          appSnackbar(AppStrings.failedToSignIn.tr, type: SnackbarType.ERROR);
        }
      },
    );
  }
}
