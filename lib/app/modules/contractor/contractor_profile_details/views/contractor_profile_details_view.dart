import 'package:app/app/core/utils/colors_manager.dart';
import 'package:app/app/core/utils/scroll_behavior.dart';
import 'package:app/app/widgets/appbar/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../config/routes/app_pages.dart';
import '../../../../core/utils/app_icons.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../widgets/rating_row.dart';
import '../../../../widgets/states/app_error_state.dart';
import '../controllers/contractor_profile_details_controller.dart';
import '../widgets/contractor_contact_tab.dart';
import '../widgets/contractor_offers_tab.dart';
import '../widgets/contractor_portfolio_tab.dart';
import '../widgets/plan_card.dart';

class ContractorProfileDetailsView
    extends GetView<ContractorProfileDetailsController> {
  const ContractorProfileDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: Obx(
            () {
              if (controller.isLoading.value &&
                  controller.contractorDetailed.value == null) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.hasError.value ||
                  controller.contractorDetailed.value == null) {
                return Center(
                  child: AppErrorState(
                      onRetry: () => controller.fetchContractorDetails()),
                );
              }

              return ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 30.h,
                ),
                children: [
                  _profileHeader(),
                  20.verticalSpace,
                  ContractorPlanCard(
                      subscription:
                          controller.contractorDetailed()!.subscription),
                  20.verticalSpace,
                  _tabContent(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _profileHeader() => Container(
        padding: EdgeInsets.fromLTRB(
          30.w,
          25.h,
          30.w,
          0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10.w),
                  child: CircleAvatar(
                    radius: 60.r,
                    backgroundColor: AppColors.primaryColor,
                    child: CircleAvatar(
                      radius: 55.r,
                      backgroundColor: Colors.white,
                      backgroundImage: const NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnSA1zygA3rubv-VK0DrVcQ02Po79kJhXo_A&s',
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 30.w,
                    width: 30.w,
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      AppIcons.house1,
                      height: 16.h,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            10.verticalSpace,
            Text(
              controller.contractorDetailed()!.fullName,
              style: Get.textTheme.bodyMedium,
            ),
            5.verticalSpace,
            RatingRow(rating: controller.contractorDetailed()!.rateStars),
            20.verticalSpace,
            GestureDetector(
              onTap: () => Get.toNamed(Routes.CONTRACTOR_EDIT_PROFILE),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 33.w,
                    height: 33.w,
                    padding: EdgeInsets.all(7.w),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      AppIcons.edit,
                    ),
                  ),
                  13.horizontalSpace,
                  Text(
                    AppStrings.editProfile.tr,
                    style: Get.textTheme.bodyMedium!.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            17.verticalSpace,
            _profileTabs(),
          ],
        ),
      );

  Widget _profileTabs() => Obx(() => Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => controller.selectedTabIndex(0),
              child: _tabButton(
                label: AppStrings.contactInfo.tr,
                isSelected: controller.selectedTabIndex.value == 0,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.selectedTabIndex(1),
              child: _tabButton(
                label: AppStrings.workPortfolio.tr,
                isSelected: controller.selectedTabIndex.value == 1,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.selectedTabIndex(2),
              child: _tabButton(
                label: AppStrings.offers.tr,
                isSelected: controller.selectedTabIndex.value == 2,
              ),
            ),
          ),
        ],
      ));

  Widget _tabContent() => Obx(() {
        final tabIndex = controller.selectedTabIndex.value;

        Widget tab;
        switch (tabIndex) {
          case 0:
            tab = ContractorContactTab(
                contractor: controller.contractorDetailed()!);
            break;
          case 1:
            tab = ContractorPortfolioTab(
                jobs: controller.contractorDetailed()!.jobs);
            break;
          case 2:
            tab = ContractorOffersTab(
                offers: controller.contractorDetailed()!.offers);
            break;
          default:
            tab = const SizedBox.shrink();
        }
        return tab;
      });

  Widget _tabButton({
    required String label,
    required bool isSelected,
  }) =>
      Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: Get.textTheme.bodySmall!.copyWith(
                  fontSize: 13.sp,
                  color: isSelected ? AppColors.primaryColor : Colors.grey,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            12.verticalSpace,
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
                color: isSelected ? AppColors.primaryColor : Colors.transparent,
              ),
            )
          ],
        ),
      );
}
