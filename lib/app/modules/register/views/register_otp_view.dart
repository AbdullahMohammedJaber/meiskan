 import 'package:app/app/widgets/default_button.dart';
import 'package:app/app/widgets/otp_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sprintf/sprintf.dart';

import '../../..//core/utils/strings_manager.dart';
import '../../../widgets/appbar/appbar.dart';
import '../controllers/register_controller.dart';

class RegisterOtpView extends GetView<RegisterController> {
  const RegisterOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(30.w),
          children: [
            Text(
              AppStrings.otpTitle.tr,
              maxLines: null,
              overflow: TextOverflow.visible,
              style: Get.textTheme.titleMedium!.copyWith(
                fontSize: 20.sp,
              ),
            ),
            5.verticalSpace,
            Text(
              sprintf(
                AppStrings.otpSubTitle.tr,
                [controller.phoneObscured],
              ),
              maxLines: null,
              overflow: TextOverflow.visible,
              style: Get.textTheme.bodyMedium!.copyWith(
                fontSize: 14.sp,
              ),
            ),
            20.verticalSpace,
            Form(
                key: controller.otpFormKey,
                child: OtpInput(
                  onDone: (_)=> controller.validateOtp(),
                  onChanged: controller.onOtpChanged,
                )),
            29.verticalSpace,
            Obx(
              () => AppButton(
                onTap: controller.canSubmitOtp ? controller.validateOtp : null,
                text: AppStrings.verify.tr,
                loading: controller.verifyingOtp.value,
                enabled: controller.canSubmitOtp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
