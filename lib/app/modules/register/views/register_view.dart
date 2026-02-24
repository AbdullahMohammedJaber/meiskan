import 'package:app/app/config/routes/app_pages.dart';
import 'package:app/app/core/enums/enums.dart';
import 'package:app/app/core/extensions/enums_ex.dart';
import 'package:app/app/core/utils/colors_manager.dart';
import 'package:app/app/core/utils/strings_manager.dart';
import 'package:app/app/core/utils/validator.dart';
import 'package:app/app/widgets/appbar/appbar.dart';
import 'package:app/app/widgets/default_button.dart';
import 'package:app/app/widgets/inputs/app_dropdown.dart';
import 'package:app/app/widgets/inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SafeArea(
          child: Form(
            key: controller.formKey,
            child: ListView(
              padding: EdgeInsets.all(30.w),
              children: [
                Obx(
                  () => AppDropDown<AccountType>(
                    label: AppStrings.selectAccountType.tr,
                    hint: AppStrings.accountType.tr,
                    value: controller.selectedAccountType.value,
                    validator: (value) =>
                        value == null ? AppStrings.selectAccountType.tr : null,
                    items: controller.accountTypes
                        .map(
                          (type) => DropdownMenuItem<AccountType>(
                            value: type,
                            child: Text(type.getName),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v is AccountType) {
                        controller.selectAccountType(v);
                      }
                    },
                  ),
                ),
                10.verticalSpace,
                AppTextField(
                  controller: controller.fullNameController,
                  textInputType: TextInputType.name,
                  validator: Validator.nameValidator,
                  label: AppStrings.fullName.tr,
                  hint: AppStrings.fullName.tr,
                ),
                10.verticalSpace,
                AppTextField(
                  controller: controller.emailController,
                  textInputType: TextInputType.emailAddress,
                  validator: Validator.optionalEmailValidator,
                  label: AppStrings.emailAddress.tr,
                  hint: AppStrings.emailAddress.tr,
                  isRequired: false,
                ),
                10.verticalSpace,
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
                10.verticalSpace,
                AppTextField(
                  controller: controller.passwordController,
                  password: true,
                  validator: Validator.passwordValidator,
                  label: AppStrings.password.tr,
                  hint: AppStrings.password.tr,
                ),
                10.verticalSpace,
                AppTextField(
                  controller: controller.confirmPasswordController,
                  password: true,
                  validator: (value) => Validator.confirmPasswordValidator(
                    controller.passwordController.text,
                    value,
                  ),
                  label: AppStrings.confirmPassword.tr,
                  hint: AppStrings.confirmPassword.tr,
                ),
                20.verticalSpace,
                Obx(
                  () => AppButton(
                    loading: controller.loading(),
                    text: AppStrings.signUp.tr,
                    onTap: controller.register,
                    textColor: Colors.white,
                  ),
                ),
                20.verticalSpace,
                GestureDetector(
                  onTap: () {
                    if (Get.currentRoute == Routes.LOGIN) return;
                    Get.offAllNamed(Routes.LOGIN);
                    return;
                  
                  },
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: AppStrings.haveAccountQuestion.tr,
                        style: context.textTheme.bodySmall,
                        children: [
                          TextSpan(
                            text: ' ${AppStrings.loginHere.tr}',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
