import 'package:app/app/core/utils/app_icons.dart';
import 'package:app/app/core/utils/app_images.dart';
import 'package:app/app/core/utils/scroll_behavior.dart';
import 'package:app/app/core/utils/strings_manager.dart';
import 'package:app/app/modules/home/widgets/plans.dart';
import 'package:app/app/widgets/appbar/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/enums/enums.dart';
import '../../../core/utils/colors_manager.dart';
import '../../../gobal_controllers/buy_points_controller.dart';
import '../../../gobal_controllers/user_controller.dart';
import '../../contractor/contractor_dashboard/controllers/contractor_dashboard_controller.dart';
import '../controllers/home_controller.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  HomeController get controller => Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
     appBar: const CustomAppBar(),
      body: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
               const HomeHeader(),
                50.verticalSpace,
              _howWeWork(),
                50.verticalSpace,
                _whyChooseSection(),
                HomePlans(),
                _statistics(),
                HomeFooter(),
              ],
            ),
            Positioned(
              bottom: 50.h,
              left: 20,
              right: 20,
              child: _buyPointsWidget(),
            ),
          ],
        ),
      ),
    );
  }

  _buyPointsWidget() => Obx(() {
        final user = Get.find<UserController>().user();
        if (user?.type != AccountType.contractor) {
          return const SizedBox.shrink();
        }
        if (!Get.isRegistered<ContractorDashboardController>()) {
          return const SizedBox.shrink();
        }
        final remainingOffers = Get.find<ContractorDashboardController>()
            .statistics()
            .remainingOffers;

        if (remainingOffers != 0) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () {
            Get.find<BuyPointsController>().openDialog();
          },
          child: Row(
            children: [
              Image.asset(
                AppImages.offers,
                width: 50.h,
                height: 50.h,
              ),
              10.horizontalSpace,
              Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    AppImages.arrowForward,
                    width: 300.w,
                    height: 50.h,
                    fit: BoxFit.fill,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40.w, right: 40.w),
                    child: Text(
                      'اشتري المزيد من العروض',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });

  Widget _statistics() => Obx(() {
        return Container(
          color: AppColors.primaryColor,
          padding: EdgeInsets.symmetric(
            horizontal: 13.w,
            vertical: 50.h,
          ),
          child: Column(
            children: [
              Text(
                AppStrings.ourSpecialNumbers.tr,
                style: Get.textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              20.verticalSpace,
              if (controller.statisticsIsLoading.value)
                const Center(child: CircularProgressIndicator())
              else if (controller.statisticsHasError.value)
                Text(
                  AppStrings.errorOccurred.tr,
                  style: TextStyle(color: Colors.white),
                )
              else ...[
                _statisticCard(
                  title: AppStrings.projectsCount.tr,
                  value: '+${controller.statistics.value.projects}',
                  svgIcon: AppIcons.build,
                ),
                30.verticalSpace,
                /* _statisticCard(
                  title: AppStrings.contractorsCount.tr,
                  value: '+250',
                  svgIcon: AppIcons.workers,
                ),
                30.verticalSpace,*/
                _statisticCard(
                  title: AppStrings.ownersCount.tr,
                  value: '+${controller.statistics.value.users}',
                  svgIcon: AppIcons.keys,
                ),
              ],
            ],
          ),
        );
      });

  _statisticCard({
    required String title,
    required String value,
    required String svgIcon,
  }) =>
      Column(
        children: [
          SvgPicture.asset(
            svgIcon,
            height: 96.w,
            width: 96.w,
            fit: BoxFit.scaleDown,
          ),
          10.verticalSpace,
          Text(
            title,
            style: Get.textTheme.titleLarge!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
            ),
          ),
          3.verticalSpace,
          Text(
            value,
            style: Get.textTheme.titleLarge!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 29.sp,
            ),
          ),
        ],
      );

  Widget _howWeWork() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.asset(
                        AppImages.homeImg1,
                        height: 273.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.asset(
                            AppImages.homeImg2,
                            height: 120.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      9.verticalSpace,
                      Container(
                        height: 120.h,
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: AppColors.primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              AppIcons.verification,
                              width: 30.w,
                              height: 30.w,
                              fit: BoxFit.scaleDown,
                            ),
                            4.verticalSpace,
                            Text(
                              AppStrings.homeHowWeWork.tr,
                              maxLines: null,
                              overflow: TextOverflow.visible,
                              style: Get.textTheme.bodySmall!.copyWith(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),*/
            Center(
              child: Image.asset(
                AppImages.homeImage,
                height: 250.h,
              ),
            ),
            30.verticalSpace,
            Center(
              child: Text(
                AppStrings.howWeWork.tr,
                style: Get.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: null,
                overflow: TextOverflow.visible,
              ),
            ),
            20.verticalSpace,
            _buildStep(AppStrings.howWeWorkStep1Title.tr,
                AppStrings.howWeWorkStep1Desc.tr),
            16.verticalSpace,
            _buildStep(AppStrings.howWeWorkStep2Title.tr,
                AppStrings.howWeWorkStep2Desc.tr),
            16.verticalSpace,
            _buildStep(AppStrings.howWeWorkStep3Title.tr,
                AppStrings.howWeWorkStep3Desc.tr),
            16.verticalSpace,
            _buildStep(AppStrings.howWeWorkStep4Title.tr,
                AppStrings.howWeWorkStep4Desc.tr),
          ],
        ),
      );

  Widget _buildStep(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: null,
          overflow: TextOverflow.visible,
          style: Get.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        6.verticalSpace,
        Text(
          desc,
          maxLines: null,
          overflow: TextOverflow.visible,
          style: Get.textTheme.bodyMedium!.copyWith(
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _whyChooseSection() => Container(
        height: 311.h,
        color: const Color(0xffE6E6E6),
        padding: EdgeInsets.symmetric(vertical: 70.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text(
                AppStrings.whyYouShouldChooseMeiskan.tr,
                style: Get.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 13.w),
                itemCount: _getWhyChooseItems().length,
                itemBuilder: (context, index) {
                  final item = _getWhyChooseItems()[index];
                  return Container(
                    margin: EdgeInsets.only(right: 16.w),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          item['icon'],
                          width: 50.w,
                          height: 50.w,
                        ),
                        8.verticalSpace,
                        Text(
                          item['title'],
                          style: Get.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 19.sp,
                          ),
                          maxLines: 1,
                        ),
                        8.verticalSpace,
                        Text(
                          item['description'],
                          style: Get.textTheme.bodySmall!.copyWith(
                            color: AppColors.grey,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );

  List<Map<String, dynamic>> _getWhyChooseItems() => [
        {
          'icon': AppIcons.settings,
          'title': AppStrings.bestContractors.tr,
          'description': AppStrings.bestContractorsDesc.tr,
        },
        {
          'icon': AppIcons.bag,
          'title': AppStrings.executeProjectEasily.tr,
          'description': AppStrings.executeProjectEasilyDesc.tr,
        },
      ];
}
