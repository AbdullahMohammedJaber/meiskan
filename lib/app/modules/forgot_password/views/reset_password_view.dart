import 'package:app/app/core/utils/validator.dart';
import 'package:app/app/widgets/default_button.dart';
import 'package:app/app/widgets/inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/utils/strings_manager.dart';
import '../../../widgets/appbar/appbar.dart';
import '../controllers/forgot_password_controller.dart';

class ResetPasswordView extends GetView<ForgotPasswordController> {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Form(
          key: controller.newPasswordFormKey,
          child: ListView(
            padding: EdgeInsets.all(30.w),
            children: [
              Text(
                AppStrings.changePassword.tr,
                style: Get.textTheme.bodyLarge!.copyWith(fontSize: 20.sp),
              ),
              10.verticalSpace,
              AppTextField(
                controller: controller.newPasswordController,
                password: true,
                validator: Validator.passwordValidator,
                label: AppStrings.newPassword.tr,
                hint: AppStrings.newPassword.tr,
              ),
              15.verticalSpace,
              AppTextField(
                controller: controller.confirmPasswordController,
                password: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.confirmPasswordEmpty.tr;
                  }
                  if (value != controller.newPasswordController.text) {
                    return AppStrings.passwordsDoNotMatch.tr;
                  }
                  return null;
                },
                label: AppStrings.confirmNewPassword.tr,
                hint: AppStrings.confirmNewPassword.tr,
              ),
              20.verticalSpace,
              Obx(
                () => AppButton(
                  loading: controller.resettingPassword(),
                  text: AppStrings.savePassword.tr,
                  onTap: controller.resetPassword,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
