import 'package:app/app/config/routes/app_pages.dart';
import 'package:app/app/data/model/offer.dart';
import 'package:app/app/gobal_controllers/user_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../core/utils/app_icons.dart';
import '../../core/utils/app_snackbar.dart';
import '../../core/utils/colors_manager.dart';
import '../../core/utils/strings_manager.dart';
import '../../data/model/detailed_project.dart';
import '../../services/chat_hub_service.dart';

class OfferCard extends StatelessWidget {
  final bool showShowProjectButton;
  final DetailedProjectModel? project;
  final ProjectOffer offer;

  const OfferCard({
    super.key,
    required this.offer,
    this.project,
    this.showShowProjectButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('${Routes.PROFILE_CONTRACTOR_ID}/${offer.contractorId}');
 
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(
          left: 25.w,
          right: 25.w,
          top: 25.h,
          bottom: 20.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25.r,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                  child: SvgPicture.asset(
                    AppIcons.user,
                    height: 20.h,
                    color: AppColors.primaryColor,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.fullName,
                        style: Get.textTheme.bodyMedium!.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      5.verticalSpace,
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppIcons.budget,
                            height: 20.h,
                          ),
                          4.horizontalSpace,
                          Text(
                            '${offer.offerPrice} ${AppStrings.kwd.tr}',
                            style: Get.textTheme.bodySmall!.copyWith(
                              fontSize: 11.sp,
                            ),
                          ),
                          5.horizontalSpace,
                          SvgPicture.asset(
                            AppIcons.clock,
                            height: 20.h,
                          ),
                          4.horizontalSpace,
                          Text(
                            '${offer.offerDuration} ${AppStrings.month.tr}',
                            style: Get.textTheme.bodySmall!.copyWith(
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            10.verticalSpace,
            Text(
              offer.offerDescription,
              maxLines: null,
              overflow: TextOverflow.visible,
              style: Get.textTheme.bodyMedium!.copyWith(
                fontSize: 12.sp,
              ),
            ),
            _actionsButtons(),
          ],
        ),
      ),
    );
  }

  Widget _actionsButtons() {
    if (showShowProjectButton) {
      return GestureDetector(
        onTap: () => Get.toNamed('${Routes.PROJECT}/${offer.projectId}'),
        child: Container(
          margin: EdgeInsets.only(top: 10.h),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            AppStrings.showProject.tr,
            textAlign: TextAlign.center,
            style: Get.textTheme.bodyMedium!.copyWith(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
        ),
      );
    }

    final user = Get.find<UserController>().user();
    if (user == null) return SizedBox.shrink();
    if (user.id == project?.ownerId) {
      return GestureDetector(
        onTap: _contactContractor,
        child: Container(
          margin: EdgeInsets.only(top: 10.h),
          height: 47.w,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: AppColors.primaryColor,
              width: 1,
            ),
          ),
          child: Text(
            AppStrings.contactContractor.tr,
            textAlign: TextAlign.center,
            style: Get.textTheme.bodyMedium!.copyWith(
              fontSize: 12.sp,
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Future<void> _contactContractor() async {
    final userController = Get.find<UserController>();
    final user = userController.user();
    if (user == null) {
      appSnackbar(AppStrings.defaultError.tr, type: SnackbarType.ERROR);
      return;
    }

    final chatHubService = Get.isRegistered<ChatHubService>()
        ? Get.find<ChatHubService>()
        : Get.put(ChatHubService(), permanent: true);

    final projectId = project?.projectId ?? offer.projectId;
    final contractorId = offer.contractorId;
    final existingConversationId = offer.conversationId;
    final shouldAllowCreation = existingConversationId <= 0;
    final chatTag =
        'chat_${existingConversationId}_${contractorId}_${DateTime.now().microsecondsSinceEpoch}';

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      await chatHubService.connectIfNeeded(userId: user.id);

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.toNamed(
        Routes.CHAT,
        arguments: {
          'conversationId': existingConversationId,
          'contractorId': contractorId,
          'projectId': projectId,
          'offerId': offer.offerId,
          'isProjectOwner': shouldAllowCreation,
          'chatTag': chatTag,
        },
      );
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('Failed to contact contractor: $error\n$stackTrace');
      }
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      appSnackbar(AppStrings.genericRetryMessage.tr, type: SnackbarType.ERROR);
    }
  }
}
