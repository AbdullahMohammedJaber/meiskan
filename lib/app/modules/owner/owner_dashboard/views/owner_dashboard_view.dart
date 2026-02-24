 
import 'package:app/app/core/utils/scroll_behavior.dart';
import 'package:app/app/widgets/appbar/appbar.dart';
import 'package:app/app/widgets/cards/project_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 import 'package:get/get.dart';

import '../../../../core/utils/app_icons.dart';
 
import '../../../../core/utils/strings_manager.dart';
 
import '../../../../widgets/cards/statistic_card.dart';
import '../../../../widgets/states/app_error_state.dart';
import '../controllers/owner_dashboard_controller.dart';

class OwnerDashboardView extends GetView<OwnerDashboardController> {
  const OwnerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: const CustomAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.onRefresh,
          child: ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: Obx(() {
              // Show loading indicator if projects are loading and list is empty
              if (controller.projectsIsLoading.value &&
                  controller.projects.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 30.h,
                ),
                children: [
                  _statisticsRow(),
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

                        // Loading indicator for pagination
                        if (controller.projectsIsLoading.value &&
                            !controller.projectsHasError.value)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),

                        // Error message for pagination failure
                        if (controller.projectsHasError.value &&
                            controller.projects.isNotEmpty)
                          AppErrorState(onRetry: controller.loadMoreProjects),

                        // End of list message when no more data
                        if (!controller.projectsHasMoreData.value &&
                            !controller.projectsIsLoading.value)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
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
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _statisticsRow() => Obx(() {
        if (controller.statisticsIsLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.statisticsHasError.value) {
          return Container(
            padding: EdgeInsets.all(16.w),
            child: Text(
              AppStrings.errorOccurred.tr,
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        return Row(
          children: [
            Expanded(
              child: StatisticCard(
                value: controller.statistics.value.projects.toString(),
                label: AppStrings.projectsCount.tr,
                iconAsset: AppIcons.house,
                iconBackground: const Color(0xffD8E7E4),
              ),
            ),
            15.horizontalSpace,
            Expanded(
              child: StatisticCard(
                value: controller.statistics.value.offers.toString(),
                label: AppStrings.offersCount.tr,
                iconAsset: AppIcons.offer,
                iconBackground: const Color(0xffD4D3D4),
              ),
            ),
          ],
        );
      });




}
