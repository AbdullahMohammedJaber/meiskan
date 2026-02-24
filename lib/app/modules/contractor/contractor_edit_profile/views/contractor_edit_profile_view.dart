import 'package:app/app/core/utils/strings_manager.dart';
import 'package:app/app/widgets/appbar/appbar.dart';
import 'package:app/app/widgets/default_button.dart';
import 'package:app/app/widgets/inputs/app_text_field.dart';
import 'package:app/app/widgets/states/app_error_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/contractor_edit_profile_controller.dart';

class ContractorEditProfileView
    extends GetView<ContractorEditProfileController> {
  const ContractorEditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Obx(
          () {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.hasError.value) {
              return AppErrorState(onRetry: controller.fetchContractorDetails);
            }

            return Form(
              key: controller.formKey,
              child: ListView(
                padding: EdgeInsets.all(30.w),
                children: [
                  Text(
                    AppStrings.editSocialMedia.tr,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  30.verticalSpace,
                  AppTextField(
                    controller: controller.facebookController,
                    label: AppStrings.facebookLink.tr,
                    hint: AppStrings.facebookLink.tr,
                    isRequired: false,
                    textInputType: TextInputType.url,
                  ),
                  20.verticalSpace,
                  AppTextField(
                    controller: controller.xController,
                    label: AppStrings.twitterLink.tr,
                    hint: AppStrings.twitterLink.tr,
                    isRequired: false,
                    textInputType: TextInputType.url,
                  ),
                  20.verticalSpace,
                  AppTextField(
                    controller: controller.linkedinController,
                    label: AppStrings.linkedinLink.tr,
                    hint: AppStrings.linkedinLink.tr,
                    isRequired: false,
                    textInputType: TextInputType.url,
                  ),
                  20.verticalSpace,
                  AppTextField(
                    controller: controller.instagramController,
                    label: AppStrings.instagramLink.tr,
                    hint: AppStrings.instagramLink.tr,
                    isRequired: false,
                    textInputType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                  ),
                  30.verticalSpace,
                  Obx(
                    () => AppButton(
                      text: AppStrings.saveEdits.tr,
                      loading: controller.saving(),
                      onTap: controller.saveProfile,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
