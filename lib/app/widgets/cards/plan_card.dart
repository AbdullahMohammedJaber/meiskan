import 'package:app/app/core/utils/app_icons.dart';
import 'package:app/app/core/utils/app_images.dart';
import 'package:app/app/core/utils/app_snackbar.dart';
import 'package:app/app/core/utils/colors_manager.dart';
import 'package:app/app/core/utils/strings_manager.dart';
import 'package:app/app/data/model/plan.dart';
import 'package:app/app/services/plan_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../default_button.dart';

class PlanCard extends StatelessWidget {
  final PointOfferModel? plan;
  final bool isDarkTheme;

  const PlanCard({
    Key? key,
    this.plan,
    this.isDarkTheme = false,
  }) : super(key: key);

  Future<void> _subscribeToPlan() async {
    final selectedPlan = plan;
    final offerId = selectedPlan?.pointOfferId ?? 0;
    if (offerId <= 0 || selectedPlan == null) {
      appSnackbar(AppStrings.defaultError.tr, type: SnackbarType.ERROR);
      return;
    }

    if (Get.isDialogOpen ?? false) {
      return;
    }

    final isSubmitting = false.obs;
    Get.dialog(
      PlanSubscribeDialog(
        plan: selectedPlan,
        isSubmitting: isSubmitting,
        onPay: () => _submitPlanPurchase(
          offerId: offerId,
          isSubmitting: isSubmitting,
        ),
      ),
    );
  }

  Future<void> _submitPlanPurchase({
    required int offerId,
    required RxBool isSubmitting,
  }) async {
    if (isSubmitting.value) {
      return;
    }
    isSubmitting.value = true;
    try {
      final result = await PlanServices.purchaseOfferPoint(offerId: offerId);
      await result.fold(
        (failure) async {
          final isArabic = Get.locale?.languageCode == 'ar';
          final message = (isArabic ? failure.message : failure.messageEn) ??
              failure.message ??
              AppStrings.defaultError.tr;
          appSnackbar(message, type: SnackbarType.ERROR);
        },
        (paymentUrl) async {
          if (paymentUrl.isEmpty) {
            appSnackbar(AppStrings.defaultError.tr, type: SnackbarType.ERROR);
            return;
          }

          final uri = Uri.tryParse(paymentUrl);
          if (uri == null) {
            appSnackbar(AppStrings.defaultError.tr, type: SnackbarType.ERROR);
            return;
          }

          if (Get.isDialogOpen ?? false) {
            Get.back();
          }

          launchUrl(
            uri,
            mode: LaunchMode.inAppBrowserView,
          );
        },
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isDarkTheme ? const Color(0xff262527) : Colors.white;
    final textColor = isDarkTheme ? Colors.white : Colors.black;
    final subtitleColor =
        isDarkTheme ? AppColors.blueGrey : AppColors.textColor;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (isDarkTheme)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: SvgPicture.asset(
                  AppImages.bgVector,
                  alignment: AlignmentDirectional.topStart,
                ),
              ),
            ),

          // Main Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (plan != null && plan!.basicPrice > plan!.afterDiscountPrice)
                Container(
                  margin: EdgeInsets.only(top: 20.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      bottomLeft: Radius.circular(20.r),
                    ),
                  ),
                  child: Text(
                    '-${(((plan!.basicPrice - plan!.afterDiscountPrice) / plan!.basicPrice) * 100).toStringAsFixed(0)}%',
                    style: Get.textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20.h,
                  horizontal: 40.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Plan Title
                    Text(
                      plan != null ? plan!.name : '-',
                      maxLines: null,
                      overflow: TextOverflow.visible,
                      style: Get.textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 31.sp,
                        color: textColor,
                      ),
                    ),
                    8.verticalSpace,

                    // Subtitle
                    Text(
                      'سعرها',
                      style: Get.textTheme.bodyMedium!.copyWith(
                        color: subtitleColor,
                      ),
                    ),
                    20.verticalSpace,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Current Price
                        Text(
                          plan != null
                              ? plan!.afterDiscountPrice
                                  .toStringAsFixed(0)
                                  .replaceAllMapped(
                                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                    (Match m) => '${m[1]},',
                                  )
                              : '1,950',
                          style: Get.textTheme.headlineLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 48.sp,
                            color: textColor,
                          ),
                        ),
                        6.horizontalSpace,
                        Text(
                          AppStrings.kwd.tr,
                          style: Get.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: textColor,
                          ),
                        ),

                        if (plan != null &&
                            plan!.basicPrice > plan!.afterDiscountPrice)
                          12.horizontalSpace,
                        // Price with strikethrough if there's a discount
                        if (plan != null &&
                            plan!.basicPrice > plan!.afterDiscountPrice)
                          Text(
                            '${plan!.basicPrice.toStringAsFixed(0)} ${AppStrings.kwd.tr}',
                            style: Get.textTheme.bodyLarge!.copyWith(
                              decoration: TextDecoration.lineThrough,
                              decorationColor: subtitleColor.withOpacity(0.6),
                              color: subtitleColor.withOpacity(0.6),
                              fontSize: 20.sp,
                            ),
                          ),
                      ],
                    ),
                    30.verticalSpace,

                    // Subscribe Button
                    AppButton(
                      text: 'اشترك',
                      buttonColor: isDarkTheme ? Colors.white : Colors.black,
                      textColor: isDarkTheme ? Colors.black : Colors.white,
                      onTap: _subscribeToPlan,
                      enabled: plan != null && plan!.pointOfferId > 0,
                    ),
                    30.verticalSpace,

                    // Offer Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          AppIcons.offers,
                          width: 25.w,
                          height: 25.w,
                          fit: BoxFit.scaleDown,
                          color: textColor,
                        ),
                        8.horizontalSpace,
                        Flexible(
                          child: Text(
                            'عدد العروض المسموح تقديمها : ${plan?.offerNum ?? -1}',
                            maxLines: null,
                            overflow: TextOverflow.visible,
                            style: Get.textTheme.bodyMedium!.copyWith(
                              fontSize: 15.sp,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    10.verticalSpace,
                    // Offer Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          AppIcons.offers,
                          width: 25.w,
                          height: 25.w,
                          fit: BoxFit.scaleDown,
                          color: textColor,
                        ),
                        8.horizontalSpace,
                        Flexible(
                          child: Text(
                            'عدد النقاط : ${plan?.offerNum ?? -1}',
                            maxLines: null,
                            overflow: TextOverflow.visible,
                            style: Get.textTheme.bodyMedium!.copyWith(
                              fontSize: 15.sp,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PlanSubscribeDialog extends StatelessWidget {
  final PointOfferModel plan;
  final RxBool isSubmitting;
  final VoidCallback onPay;

  const PlanSubscribeDialog({
    super.key,
    required this.plan,
    required this.isSubmitting,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    final pointPrice = plan.offerNum > 0
        ? plan.afterDiscountPrice / plan.offerNum
        : plan.afterDiscountPrice;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 12.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppImages.balance,
              height: 120.h,
            ),
            12.verticalSpace,
            Text(
              AppStrings.buyMorePointsTitle.tr,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            10.verticalSpace,
            Text(
              '${AppStrings.buyMorePointsSubtitle.tr} ${_formatPlanPrice(pointPrice)} ${AppStrings.kwd.tr}',
              maxLines: null,
              overflow: TextOverflow.visible,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12.sp,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            16.verticalSpace,
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                AppStrings.requiredOffersCount.tr,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            8.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppStrings.price.tr}: ${_formatPlanPrice(plan.afterDiscountPrice)} ${AppStrings.kwd.tr}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12.sp,
                    ),
                  ),
                  Text(
                    plan.offerNum.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            Obx(
              () => AppButton(
                text: AppStrings.pay.tr,
                buttonColor: Colors.black87,
                loading: isSubmitting.value,
                enabled: !isSubmitting.value,
                onTap: onPay,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatPlanPrice(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(1);
}
