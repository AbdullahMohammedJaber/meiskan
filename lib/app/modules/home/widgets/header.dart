import 'package:app/app/config/routes/app_pages.dart';
import 'package:app/app/core/enums/enums.dart';
import 'package:app/app/core/utils/app_images.dart';
import 'package:app/app/core/utils/colors_manager.dart';
import 'package:app/app/core/utils/strings_manager.dart';
 import 'package:app/app/gobal_controllers/user_controller.dart';
import 'package:app/app/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 import 'package:get/get.dart';

 
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: Get.height - 65.h - Get.mediaQuery.padding.top,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.homeBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            100.verticalSpace,
             Image.asset(
              AppImages.logo,
              height: 124.h,
            ),
            10.verticalSpace,
            Text(
              AppStrings.homeTitle.tr,
              maxLines: null,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              style: Get.textTheme.titleLarge!.copyWith(
                fontSize: 25.sp,
                color: Colors.white,
              ),
            ),
            Text(
              AppStrings.homeSubTitle.tr,
              textAlign: TextAlign.center,
              maxLines: null,
              overflow: TextOverflow.visible,
              style: Get.textTheme.bodyMedium!.copyWith(
                color: Colors.white,
              ),
            ),
            20.verticalSpace,
            Obx(
              () => Visibility(
                visible: Get.find<UserController>().user() == null,
                child: SizedBox(
                  width: 250.w,
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: AppStrings.joinAsOwner.tr,
                          buttonColor: Colors.white,
                          textColor: AppColors.textColor,
                          onTap: () => Get.toNamed(Routes.REGISTER, arguments: {
                            'user_type': AccountType.owner,
                          }),
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: AppButton(
                          text: AppStrings.joinAsContractor.tr,
                          bordered: true,
                          borderColor: Colors.white,
                          onTap: () => Get.toNamed(Routes.REGISTER, arguments: {
                            'user_type': AccountType.contractor,
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
