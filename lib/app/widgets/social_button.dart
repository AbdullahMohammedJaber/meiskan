

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    this.iconPath,
    this.icon,
    this.onTap,
  }) : assert(
          iconPath != null || icon != null,
          'Provide iconPath or icon.',
        );

  final String? iconPath;
  final Widget? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget effectiveIcon = icon ??
        SvgPicture.asset(
          iconPath!,
          color: Colors.white,
        );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34.h,
        width: 34.h,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          shape: BoxShape.circle,
        ),
        child: effectiveIcon,
      ),
    );
  }
}
