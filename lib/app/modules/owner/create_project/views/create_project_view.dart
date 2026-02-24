// ignore_for_file: must_be_immutable

import 'dart:io' show File;

import 'package:app/app/core/utils/app_icons.dart';
import 'package:app/app/core/utils/colors_manager.dart';
import 'package:app/app/core/utils/validator.dart';
import 'package:app/app/modules/owner/create_project/views/drob_down_ui.dart';
 import 'package:app/app/widgets/default_button.dart';
 import 'package:app/app/widgets/inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/utils/strings_manager.dart';
import '../../../../widgets/appbar/appbar.dart';
import '../controllers/create_project_controller.dart';

class CreateProjectView extends GetView<CreateProjectController> {
  const CreateProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Obx(
          () => AppButton(
            margin: EdgeInsets.only(
              left: 30.w,
              right: 30.w,
              top: 5.h,
            ),
            loading: controller.loading(),
            text: AppStrings.add.tr,
            onTap: controller.create,
            textColor: Colors.white,
          ),
        ),
      ),
      appBar: const CustomAppBar(),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SafeArea(
          child: Form(
            key: controller.formKey,
            child: ListView(
              padding: EdgeInsets.all(30.w),
              children: [
                AppTextField(
                  controller: controller.projectTitleController,
                  textInputType: TextInputType.text,
                  validator: Validator.fieldValidator,
                  label: AppStrings.projectTitle.tr,
                  hint: AppStrings.projectTitle.tr,
                ),
                20.verticalSpace,

                Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.projectCategory.tr,
                            style: Get.textTheme.bodyMedium
                                ?.copyWith(fontSize: 14.sp)),
                        5.verticalSpace,
                        GestureDetector(
                          onTap: () => _showCategoryDialog(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  controller
                                          .selectedProjectCategory.value.isEmpty
                                      ? AppStrings.projectCategory.tr
                                      : controller
                                          .selectedProjectCategory.value,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: controller.selectedProjectCategory
                                            .value.isEmpty
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down_rounded)
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                20.verticalSpace,

                AppTextField(
                  controller: controller.projectDescriptionController,
                  textInputType: TextInputType.multiline,
                  maxLines: 4,
                  validator: Validator.fieldValidator,
                  label: AppStrings.projectDescription.tr,
                  hint: AppStrings.projectDescription.tr,
                ),
                20.verticalSpace,

                AppTextField(
                  controller: controller.noteController,
                  textInputType: TextInputType.multiline,
                  maxLines: 3,
                  label: AppStrings.additionalNotes.tr,
                  hint: AppStrings.additionalNotes.tr,
                ),
                20.verticalSpace,

                AppTextField(
                  controller: controller.cityController,
                  textInputType: TextInputType.text,
                  validator: Validator.fieldValidator,
                  label: AppStrings.city.tr,
                  hint: AppStrings.city.tr,
                ),
                20.verticalSpace,

                GestureDetector(
                  onTap: () {
                    showAnimatedSelectionDialog(
                      context: context,
                      title: AppStrings.areaName.tr,
                      items: controller.governorates,
                      selectedValue: controller.selectedGovernorate.value,
                      onSelect: controller.onGovernorateChanged,
                    );
                  },
                  child: AbsorbPointer(
                    child: AppTextField(
                      controller: controller.addressController,
                      textInputType: TextInputType.text,
                      validator: Validator.fieldValidator,
                      label: AppStrings.areaName.tr,
                      hint: AppStrings.areaName.tr,
                    ),
                  ),
                ),
                20.verticalSpace,

                Obx(() {
                  if (controller.selectedGovernorate.value.isEmpty) {
                    return const SizedBox();
                  }

                  return GestureDetector(
                    onTap: () {
                      showAnimatedSelectionDialog(
                        context: context,
                        title: AppStrings.addressName.tr,
                        items: controller.areas,
                        selectedValue: controller.selectedArea.value,
                        onSelect: controller.onAreaChanged,
                      );
                    },
                    child: AbsorbPointer(
                      child: AppTextField(
                        controller: controller.areaController,
                        textInputType: TextInputType.text,
                        validator: Validator.fieldValidator,
                        label: AppStrings.addressName.tr,
                        hint: AppStrings.addressName.tr,
                      ),
                    ),
                  );
                }),
                20.verticalSpace,

                // Project Images Section

                _imagesSection(),
                20.verticalSpace,

                _filesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCategoryDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Categories",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return const SizedBox();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.projectCategory.tr,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),

                      /// LIST
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: Obx(() => ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.categories.length,
                              itemBuilder: (context, index) {
                                final category = controller.categories[index];

                                final isSelected =
                                    controller.selectedProjectCategory.value ==
                                        category.name;

                                return GestureDetector(
                                  onTap: () {
                                    controller.selectedProjectCategory.value =
                                        category.name;
                                    Get.back();
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.blue.withOpacity(0.1)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            category.name,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        if (isSelected)
                                          const Icon(Icons.check_circle,
                                              color: Colors.blue)
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _filesSection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.projectFiles.tr,
            style: Get.textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
          ),
          10.verticalSpace,
          Obx(() => controller.selectedFile.value != null
              ? Container(
                  height: 100.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: AppColors.inputBorderColor,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.all(10.w),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.pdf,
                        height: 50.h,
                        width: 50.w,
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.selectedFile.value!.split('/').last,
                              style: Get.textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'PDF File',
                              style: Get.textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.removeFile,
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 16.w,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: controller.pickFiles,
                  child: Container(
                    height: 210.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: AppColors.inputBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppIcons.fileUpload,
                          height: 71.h,
                          width: 71.h,
                        ),
                        10.verticalSpace,
                        Text(
                          'Tap to select a file',
                          style: Get.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                )),
          20.verticalSpace,
        ],
      );

  _imagesSection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.projectImages.tr,
            style: Get.textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
          ),
          10.verticalSpace,

          GestureDetector(
            onTap: controller.pickImages,
            child: Container(
              height: 210.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: AppColors.inputBorderColor,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                AppIcons.gallery,
                height: 71.h,
                width: 71.h,
              ),
            ),
          ),
          10.verticalSpace,

          // Image thumbnails row
          Obx(() => controller.selectedImages.isNotEmpty
              ? SizedBox(
                  height: 80.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.selectedImages.length,
                    separatorBuilder: (_, __) => 10.horizontalSpace,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  image: DecorationImage(
                                    image: FileImage(
                                        File(controller.selectedImages[index])),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: GestureDetector(
                                onTap: () => controller.removeImage(index),
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 12.w,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : const SizedBox.shrink()),
        ],
      );
}
