import 'package:app/app/core/utils/colors_manager.dart';
import 'package:app/app/data/model/contractor_detailed_model.dart';
import 'package:app/app/modules/contractor/contractor_profile_details/controllers/contractor_profile_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/strings_manager.dart';

class ContractorPlanCard extends StatelessWidget {
  final Subscription? subscription;

  const ContractorPlanCard({
    super.key,
    required this.subscription,
  });

  @override
  Widget build(BuildContext context) {
    if (subscription == null) return const SizedBox.shrink();
    final daysRemaining =
        subscription!.nextBillingDate.difference(DateTime.now()).inDays;
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 25.h,
        horizontal: 20.w,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subscription!.planName,
                style: Get.textTheme.bodySmall,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.r),
                  color: (daysRemaining >= 0
                          ? AppColors.successColor
                          : AppColors.errorColor)
                      .withOpacity(0.2),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 6.h,
                ),
                child: Text(
                  daysRemaining >= 0
                      ? AppStrings.active.tr
                      : AppStrings.expired.tr,
                  style: Get.textTheme.bodySmall!.copyWith(
                    fontSize: 10.sp,
                    color: daysRemaining >= 0
                        ? AppColors.successColor
                        : AppColors.errorColor,
                  ),
                ),
              )
            ],
          ),
          18.verticalSpace,
          GridView.count(
            crossAxisCount: 3,
            // 3 items per row
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            // so it doesn't scroll inside parent
            childAspectRatio: 2.3,
            // adjust for width/height ratio
            children: [
              // Subscription Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.subscriptionDate.tr,
                    style: Get.textTheme.bodySmall!.copyWith(
                      fontSize: 10.sp,
                      color: AppColors.grey,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    DateFormat('dd/MM/yyyy').format(subscription!.startDate),
                    style: Get.textTheme.bodySmall!.copyWith(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // Expiry Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.expiryDate.tr,
                    style: Get.textTheme.bodySmall!.copyWith(
                      fontSize: 10.sp,
                      color: AppColors.grey,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    DateFormat('dd/MM/yyyy')
                        .format(subscription!.nextBillingDate),
                    style: Get.textTheme.bodySmall!.copyWith(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // Remaining Days
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.remainingFromIt.tr,
                    style: Get.textTheme.bodySmall!.copyWith(
                      fontSize: 10.sp,
                      color: AppColors.grey,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    '${daysRemaining >= 0 ? daysRemaining : 0} ${AppStrings.day.tr}',
                    style: Get.textTheme.bodySmall!.copyWith(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // Remaining Offers
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.remainingOffers.tr,
                    style: Get.textTheme.bodySmall!.copyWith(
                      fontSize: 10.sp,
                      color: AppColors.grey,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    subscription!.remainingOffers.toString(),
                    style: Get.textTheme.bodySmall!.copyWith(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Obx(
            () {
              final controller = Get.find<ContractorProfileDetailsController>();
              final isCancelingPlan = controller.isCancelingPlan.value;
              return GestureDetector(
                onTap: controller.cancelPlan,
                child: Container(
                  width: Get.width * 0.4,
                  height: 40.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    color: AppColors.errorColor,
                  ),
                  alignment: Alignment.center,
                  child: isCancelingPlan
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20.w,
                              width: 20.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          AppStrings.cancelPlan.tr,
                          style: Get.textTheme.titleSmall!.copyWith(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
