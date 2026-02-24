import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../core/utils/app_icons.dart';

class RatingRow extends StatelessWidget {
  const RatingRow({required this.rating, this.maxStars = 5});

  final double rating;
  final int maxStars;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (index) {
        final starValue = index + 1;
        final isFull = rating >= starValue;
        final isHalf = rating >= (starValue - 0.5) && rating < starValue;

        return Padding(
          padding: EdgeInsetsDirectional.only(end: 6.w),
          child: SvgPicture.asset(
            isFull
                ? AppIcons.star // full star
                : isHalf
                ? AppIcons.starHalf // 🔹 make sure you have a half-star asset
                : AppIcons.starOutlined, // empty star
            height: 20.h,
            width: 20.w,
            color: isFull || isHalf ? Colors.amber : Colors.grey.shade400,
          ),
        );
      }),
    );
  }
}
