import 'package:app/app/config/routes/app_pages.dart';
import 'package:app/app/core/enums/enums.dart';
import 'package:app/app/core/utils/scroll_behavior.dart';
import 'package:app/app/gobal_controllers/user_controller.dart';
import 'package:app/app/widgets/appbar/appbar.dart';
import 'package:app/app/widgets/cards/offer_card.dart';
import 'package:app/app/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_icons.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/colors_manager.dart';
import '../../../core/utils/strings_manager.dart';
import '../../../widgets/states/app_error_state.dart';
import '../controllers/project_controller.dart';

class ProjectView extends GetView<ProjectController> {
  const ProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      bottomNavigationBar: _addOfferButton(),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: Obx(() {
            if (controller.isLoading()) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.hasError()) {
              return AppErrorState(onRetry: controller.retry);
            }

            if (controller.projectDetails() == null) {
              return const Center(child: Text('No project details found'));
            }

            return ListView(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 30.h,
              ),
              children: [
                _projectImage(),
                15.verticalSpace,
                _projectTabs(),
                20.verticalSpace,
                Obx(() => controller.selectedTabIndex.value == 0
                    ? _projectContent()
                    : _offersContent()),
                30.verticalSpace,
                Obx(() => controller.selectedTabIndex.value == 0 &&
                        controller.projectDetails()!.fileUrl != null
                    ? _downloadButton()
                    : const SizedBox()),
                5.verticalSpace,
                if (controller.projectDetails()!.ownerId ==
                    Get.find<UserController>().user()!.id)
                  Obx(() => controller.isLoadingDelete.value == false
                      ? GestureDetector(
                          onTap: () {
                            controller.deleteProject();
                          },
                          child: Container(
                            height: 60.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Text(
                                "حذف المشروع",
                                style: Get.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const Center(child: CircularProgressIndicator())),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _addOfferButton() => Visibility(
        visible:
            Get.find<UserController>().user()!.type == AccountType.contractor,
        child: SafeArea(
          child: AppButton(
            onTap: () async {
              final result = await Get.toNamed(
                Routes.ADD_OFFER,
                arguments: controller.projectDetails(),
              );
              if (result == true) {
                await controller.getProjectDetails();
              }
            },
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            text: AppStrings.addOffer.tr,
          ),
        ),
      );

  Widget _projectImage() => Container(
        height: 235.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7.r),
          child: Builder(
            builder: (context) {
              final images = controller.projectDetails()!.images;

              if (images.isEmpty) {
                return Image.asset(
                  AppImages.homeBg,
                  fit: BoxFit.cover,
                );
              }

              return Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: controller.imagePageController,
                    onPageChanged: controller.onImagePageChanged,
                    itemCount: images.length,
                    itemBuilder: (_, index) => Image.network(
                      images[index].url,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image_outlined),
                      ),
                    ),
                  ),
                  if (images.length > 1)
                    Positioned(
                      bottom: 12.h,
                      left: 0,
                      right: 0,
                      child: Obx(
                        () {
                          final currentIndex =
                              controller.currentImageIndex.value;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(images.length, (index) {
                              final isActive = index == currentIndex;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: EdgeInsets.symmetric(horizontal: 3.w),
                                width: isActive ? 16.w : 8.w,
                                height: 6.h,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? AppColors.primaryColor
                                      : Colors.white.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      );

  Widget _projectContent() => Container(
        padding: EdgeInsets.symmetric(vertical: 25.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: AppColors.inputBorderColor,
            width: 1,
          ),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _projectDetails(),
            const Divider(),
            _projectDescription(),
            const Divider(),
            _projectAdditionalNotes()
          ],
        ),
      );

  Widget _projectTabs() => Container(
        height: 50.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: const Border(
            bottom: BorderSide(
              color: AppColors.inputBorderColor,
              width: 1,
            ),
          ),
          color: Colors.white,
        ),
        child: Obx(() => Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.changeTab(0),
                    child: _tabButton(
                      label: AppStrings.projectDetails.tr,
                      isSelected: controller.selectedTabIndex.value == 0,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.changeTab(1),
                    child: _tabButton(
                      label: AppStrings.submittedOffers.tr,
                      isSelected: controller.selectedTabIndex.value == 1,
                    ),
                  ),
                ),
              ],
            )),
      );

  Widget _tabButton({
    required String label,
    required bool isSelected,
  }) =>
      Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.bodySmall!.copyWith(
                    fontSize: 13.sp,
                    color: isSelected ? AppColors.primaryColor : Colors.grey,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              height: 3,
              width: Get.width * 0.2,
              padding: EdgeInsets.symmetric(vertical: isSelected ? 12.h : 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(2.r),
                ),
                color: isSelected
                    ? AppColors.primaryColor
                    : Colors.transparent, // Transparent when not selected
              ),
            )
          ],
        ),
      );

  Widget _projectDetails() => Column(
        children: [
          _detailRow(
            icon: AppIcons.house1,
            label: AppStrings.projectTitle.tr,
            value: controller.projectDetails()!.projectDescription,
          ),
          const Divider(),
          _detailRow(
            icon: AppIcons.layers,
            label: AppStrings.projectCategory.tr,
            value: controller.projectDetails()!.categoryNameAr,
          ),
          const Divider(),
          _detailRow(
            icon: AppIcons.map,
            label: AppStrings.province.tr,
            value: controller.projectDetails()!.cityName,
          ),
          const Divider(),
          _detailRow(
            icon: AppIcons.directions,
            label: AppStrings.region.tr,
            value: controller.projectDetails()!.areaName,
          ),
        ],
      );

  Widget _detailRow({
    required String icon,
    required String label,
    required String value,
  }) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Row(
          children: [
            SizedBox(
              height: 30.w,
              width: 30.w,
              child: SvgPicture.asset(
                icon,
                color: AppColors.primaryColor,
              ),
            ),
            8.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Get.textTheme.bodySmall!.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  2.verticalSpace,
                  Text(
                    value,
                    maxLines: null,
                    overflow: TextOverflow.visible,
                    style: Get.textTheme.bodyMedium!.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _projectDescription() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.projectDescription.tr,
              style: Get.textTheme.bodySmall!.copyWith(color: AppColors.grey),
            ),
            2.verticalSpace,
            Text(
              controller.projectDetails()!.projectDescription,
              maxLines: null,
              overflow: TextOverflow.visible,
              style: Get.textTheme.bodyMedium!.copyWith(fontSize: 14.sp),
            ),
          ],
        ),
      );

  Widget _projectAdditionalNotes() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.additionalNotes.tr,
              style: Get.textTheme.bodySmall!.copyWith(color: AppColors.grey),
            ),
            2.verticalSpace,
            Text(
              controller.projectDetails()!.note,
              maxLines: null,
              overflow: TextOverflow.visible,
              style: Get.textTheme.bodyMedium!.copyWith(fontSize: 14.sp),
            ),
          ],
        ),
      );

  Widget _downloadButton() => GestureDetector(
        onTap: controller.downloadPdf,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 40.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: AppColors.inputBorderColor,
              width: 1,
            ),
          ),
          child: Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  AppIcons.pdf,
                  height: 75.h,
                ),
                6.verticalSpace,
                Text(
                  AppStrings.downloadPdfFile.tr,
                  style: Get.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          /*Obx(() {
            if (controller.downloadStatus.value == DownloadStatus.loading) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppIcons.pdf,
                    height: 75.h,
                  ),
                  6.verticalSpace,
                  Text(
                    AppStrings.downloadPdfFile.tr,
                    style: Get.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  10.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: LinearProgressIndicator(
                      value: controller.downloadProgress.value,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primaryColor),
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    AppStrings.downloadInProgress.tr,
                    style: Get.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              );
              */ /*
          } else if (controller.downloadStatus.value == DownloadStatus.success) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60.h,
                ),
                6.verticalSpace,
                Text(
                  AppStrings.downloadCompleted.tr,
                  style: Get.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ],
            );*/ /*
            } else if (controller.downloadStatus.value == DownloadStatus.error) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 60.h,
                  ),
                  6.verticalSpace,
                  Text(
                    AppStrings.downloadFailed.tr,
                    style: Get.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ],
              );
            } else {
              return Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppIcons.pdf,
                      height: 75.h,
                    ),
                    6.verticalSpace,
                    Text(
                      AppStrings.downloadPdfFile.tr,
                      style: Get.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }
          }),*/
        ),
      );

  Widget _offersContent() => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: AppColors.inputBorderColor,
            width: 1,
          ),
          color: Colors.white,
        ),
        child: Obx(
          () => Column(
            children: [
              if (controller.projectDetails()!.offers.isNotEmpty)
                ...controller.projectDetails()!.offers.map(
                      (offer) => OfferCard(
                        offer: offer,
                        project: controller.projectDetails()!,
                      ),
                    ),
              if (controller.projectDetails()!.offers.isEmpty)
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Text(
                    AppStrings.emptyOffers.tr,
                    style: Get.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      );
}
