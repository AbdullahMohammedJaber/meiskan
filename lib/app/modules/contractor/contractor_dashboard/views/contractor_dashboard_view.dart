import 'package:app/app/widgets/inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_icons.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/scroll_behavior.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../widgets/cards/project_card.dart';
import '../../../../widgets/cards/statistic_card.dart';
import '../../../../widgets/states/app_error_state.dart';
import '../../contractor_home/controllers/contractor_home_controller.dart';
import '../controllers/contractor_dashboard_controller.dart';

class ContractorDashboardView extends GetView<ContractorDashboardController> {
  const ContractorDashboardView({super.key});

  @override
  ContractorDashboardController get controller =>
      Get.put(ContractorDashboardController());

  void _openFilterDrawer() {
    Get.find<ContractorHomeController>().scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: Obx(() {
            // Show loading only when both are loading and projects list is empty
            if (controller.projectsIsLoading.value &&
                controller.statisticsIsLoading.value &&
                controller.projects.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo is ScrollUpdateNotification &&
                    scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 80) {
                  controller.loadMoreProjects();
                }
                return false;
              },
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 30.h,
                ),
                children: [
                  _statisticsRow(),
                  15.verticalSpace,
                  _searchInput(),
                  15.verticalSpace,
                  // Projects list
                  Obx(() {
                    if (controller.projectsHasError.value &&
                        controller.projects.isEmpty) {
                      return AppErrorState(
                        onRetry: () => controller.fetchProjects(refresh: true),
                      );
                    }

                    return Column(
                      children: [
                        ...controller.projects.map(
                          (project) => ProjectCard(
                            project: project,
                          ),
                        ),
                        if (controller.projectsIsLoading.value &&
                            !controller.projectsHasError.value)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        if (controller.projectsHasError.value &&
                            controller.projects.isNotEmpty)
                          AppErrorState(onRetry: controller.loadMoreProjects),
                        if (!controller.projectsHasMoreData.value &&
                            !controller.projectsIsLoading.value)
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Text(
                              controller.projects.isEmpty
                                  ? AppStrings.noItems.tr
                                  : AppStrings.noMoreProjectsToLoad.tr,
                              style: const TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    );
                  }),
                  8.verticalSpace,
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _searchInput() => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.05),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: AppTextField(
  textInputAction: TextInputAction.search,
                  inputDecoration: InputDecoration(
                    suffixIcon: Obx(
                      () => Visibility(
                        visible: controller.searchText.isNotEmpty,
                        child: IconButton(
                          onPressed: controller.clearSearch,
                          icon: Icon(
                            Icons.close,
                            color: AppColors.primaryColor,
                            size: 24.w,
                          ),
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                    ),
                  ),
                  onFieldSubmitted:(_)=>controller.fetchProjects(refresh: true),
                  svgIcon: AppIcons.search,
                  hint: AppStrings.searchHint.tr,
                  onChanged: (v) => controller.searchText.value = v,
                  controller: controller.searchTextController,
                ),
              ),
            ),
            10.horizontalSpace,
            GestureDetector(
              onTap: _openFilterDrawer,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(13.w),
                  child: SvgPicture.asset(
                    AppIcons.filter,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _statisticsRow() => Obx(() {
        if (controller.statisticsIsLoading.value && !controller.projectsIsLoading.value) {
          // Show loading indicator only for statistics when projects are not loading
          return Container(
            padding: EdgeInsets.all(16.w),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (controller.statisticsHasError.value) {
          return Container(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'Error loading statistics',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: StatisticCard(
                    value: controller.statistics.value.projects.toString(),
                    label: AppStrings.projects.tr,
                    // Using the projects string from AppStrings
                    iconAsset: AppIcons.house,
                    iconBackground: const Color(0xffD8E7E4),
                  ),
                ),
                15.horizontalSpace,
                Expanded(
                  child: StatisticCard(
                    value: controller.statistics.value.offers.toString(),
                    label: AppStrings.offers.tr,
                    // Using the offers string from AppStrings
                    iconAsset: AppIcons.offer,
                    iconBackground: const Color(0xffD4D3D4),
                  ),
                ),
              ],
            ),
            15.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: StatisticCard(
                    value:
                        controller.statistics.value.remainingOffers.toString(),
                    label: AppStrings.remainingOffers.tr,
                    iconAsset: AppIcons.house,
                    iconBackground: const Color(0xffD6E0EE),
                    iconColor: const Color(0xff3066AA),
                  ),
                ),
                15.horizontalSpace,
                Expanded(
                  child: StatisticCard(
                      value:
                          controller.statistics.value.rating.toStringAsFixed(1),
                      label: AppStrings.rating.tr,
                      iconAsset: AppIcons.star,
                      iconBackground: const Color(0xffF7F0DC),
                      iconColor: const Color(0xffD7B551)),
                ),
              ],
            ),
          ],
        );
      });
}
