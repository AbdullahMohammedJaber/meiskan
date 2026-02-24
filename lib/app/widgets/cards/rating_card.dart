import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../core/utils/app_icons.dart';
import '../../core/utils/colors_manager.dart';
import '../rating_row.dart';
import '../../data/model/rate.dart';

class RatingCard extends StatelessWidget {
  final RatingModel rating;

  const RatingCard({required this.rating});

  @override
  Widget build(BuildContext context) {
    String name = rating.ownerName;
    String text = rating.rateNote;
    double ratingStars = rating.rateStar;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppColors.inputBorderColor,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 50.w,
                width: 50.w,
                decoration: const BoxDecoration(
                  color: Color(0xffD8E7E4),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(13.w),
                child: SvgPicture.asset(AppIcons.user),
              ),
              5.horizontalSpace,
              Expanded(
                child: Text(
                  name,
                  style: Get.textTheme.bodyMedium!.copyWith(
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Text(
            text,
            maxLines: null,
            overflow: TextOverflow.visible,
            style: Get.textTheme.bodySmall!.copyWith(),
          ),
          10.verticalSpace,
          RatingRow(rating: ratingStars),
        ],
      ),
    );
  }
}
