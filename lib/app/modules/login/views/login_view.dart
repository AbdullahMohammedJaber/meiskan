 import 'package:app/app/core/utils/validator.dart';
import 'package:app/app/widgets/default_button.dart';
import 'package:app/app/widgets/inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../config/routes/app_pages.dart';
import '../../../core/utils/strings_manager.dart';
import '../../../widgets/appbar/appbar.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: ListView(
            padding: EdgeInsets.all(30.w),
            children: [
              AppTextField(
                controller: controller.phoneController,
                textInputType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
                validator: Validator.phoneValidator,
                label: AppStrings.phoneNumber.tr,
                hint: AppStrings.phoneNumber.tr,
                prefixText: '+965',
              ),
              20.verticalSpace,
              AppTextField(
                controller: controller.passwordController,
                password: true,
                validator: Validator.passwordValidator,
                label: AppStrings.password.tr,
                hint: AppStrings.password.tr,
              ),
              5.verticalSpace,
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: GestureDetector(
                  onTap: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                  child: Text(
                    AppStrings.forgotPassword.tr,
                    style: context.textTheme.bodySmall,
                  ),
                ),
              ),
              20.verticalSpace,
              Obx(
                () => AppButton(
                  loading: controller.loading(),
                  text: AppStrings.login.tr,
                  onTap: controller.login,
                  textColor: Colors.white,
                ),
              ),
              20.verticalSpace,
              GestureDetector(
                onTap: () {
                  if (Get.currentRoute == Routes.REGISTER) return;
                   Get.offAllNamed(Routes.REGISTER);
                  return;
                  
                },
                child: Text(
                  AppStrings.dontHaveAccountCreateOne.tr,
                  style: context.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
