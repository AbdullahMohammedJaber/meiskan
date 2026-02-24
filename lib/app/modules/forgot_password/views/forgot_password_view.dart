import 'package:app/app/core/utils/validator.dart';
import 'package:app/app/widgets/default_button.dart';
import 'package:app/app/widgets/inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/utils/strings_manager.dart';
import '../../../widgets/appbar/appbar.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

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
              Text(
                AppStrings.forgotPasswordPageTitle.tr,
                style: Get.textTheme.bodyLarge!.copyWith(fontSize: 20.sp),
              ),
              20.verticalSpace,
              AppTextField(
                controller: controller.phoneController,
                textInputType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
                validator: Validator.phoneValidator,
                label: AppStrings.phoneNumber.tr,
                hint: AppStrings.phoneHint.tr,
                prefixText: '+965',
              ),
              20.verticalSpace,
              Obx(
                () => AppButton(
                  loading: controller.loading(),
                  text: AppStrings.submit.tr,
                  onTap: controller.sendResetCode,
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
