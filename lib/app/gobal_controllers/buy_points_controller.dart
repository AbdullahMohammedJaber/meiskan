import 'package:app/app/core/base/base_viewmodel.dart';
import 'package:app/app/core/utils/app_images.dart';
import 'package:app/app/core/utils/app_snackbar.dart';
import 'package:app/app/core/utils/strings_manager.dart';
import 'package:app/app/services/balance_services.dart';
import 'package:app/app/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyPointsController extends BaseController {
  static const double pointPrice = 1.5;

  final points = 1.obs;
  final isSubmitting = false.obs;

  void openDialog() {
    if (Get.isDialogOpen ?? false) {
      return;
    }
    points.value = 1;
    Get.dialog(const BuyPointsDialog());
  }

  void incrementPoints() {
    points.value += 1;
  }

  void decrementPoints() {
    if (points.value > 1) {
      points.value -= 1;
    }
  }

  Future<void> submitPurchase() async {
    if (isSubmitting.value) {
      return;
    }
    final pointsToBuy = points.value;
    if (pointsToBuy < 1) {
      appSnackbar(AppStrings.invalidNumber.tr, type: SnackbarType.ERROR);
      return;
    }

    isSubmitting.value = true;
    try {
      final result = await BalanceServices.purchasePoints(points: pointsToBuy);
      await result.fold(
        (failure) {
          handleError(failure, submitPurchase);
          /*final isArabic = Get.locale?.languageCode == 'ar';
          final message = (isArabic ? failure.message : failure.messageEn) ??
              failure.message ??
              AppStrings.defaultError.tr;
          appSnackbar(message, type: SnackbarType.ERROR);*/
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
}

class BuyPointsDialog extends StatelessWidget {
  const BuyPointsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuyPointsController>();
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
              '${AppStrings.buyMorePointsSubtitle.tr} ${BuyPointsController.pointPrice.toStringAsFixed(1)} ${AppStrings.kwd.tr}',
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
            Obx(() {
              final totalPrice =
                  controller.points.value * BuyPointsController.pointPrice;
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppStrings.price.tr}: ${totalPrice.toStringAsFixed(1)} ${AppStrings.kwd.tr}',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12.sp,
                      ),
                    ),
                    Row(
                      children: [
                        _CountButton(
                          icon: Icons.remove,
                          enabled: controller.points.value > 1,
                          onTap: controller.decrementPoints,
                        ),
                        10.horizontalSpace,
                        Text(
                          controller.points.value.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        10.horizontalSpace,
                        _CountButton(
                          icon: Icons.add,
                          onTap: controller.incrementPoints,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            20.verticalSpace,
            Obx(
              () => AppButton(
                text: AppStrings.pay.tr,
                buttonColor: Colors.black87,
                loading: controller.isSubmitting.value,
                enabled: !controller.isSubmitting.value,
                onTap: controller.submitPurchase,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _CountButton({
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: enabled ? Colors.black87 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Icon(
          icon,
          size: 14.sp,
          color: enabled ? Colors.white : Colors.grey.shade600,
        ),
      ),
    );
  }
}
