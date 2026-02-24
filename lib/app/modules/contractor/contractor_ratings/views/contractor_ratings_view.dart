import 'package:app/app/widgets/appbar/appbar.dart';
import 'package:app/app/widgets/states/app_error_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/utils/strings_manager.dart';
import '../../../../widgets/cards/rating_card.dart';
import '../controllers/contractor_ratings_controller.dart';

class ContractorRatingsView extends GetView<ContractorRatingsController> {
  const ContractorRatingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value ||
            controller.contractorDetailed.value == null) {
          return Center(
            child: AppErrorState(
                onRetry: () => controller.fetchContractorDetailsById()),
          );
        }

        final contractor = controller.contractorDetailed.value!;
        final ratings = contractor.ratings;

        if (ratings.isEmpty) {
          return Center(
            child: Text(
              AppStrings.noRatingsYet.tr,
              style: Get.textTheme.bodyMedium!.copyWith(
                fontSize: 14.sp,
              ),
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          children: [
            Text(
              AppStrings.ratings.tr,
              style: Get.textTheme.bodyMedium!.copyWith(
                fontSize: 14.sp,
              ),
            ),
            10.verticalSpace,
            ...ratings.map((rating) => RatingCard(rating: rating)),
          ],
        );
      }),
    );
  }
}
