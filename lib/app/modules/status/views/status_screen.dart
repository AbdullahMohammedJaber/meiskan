import 'package:app/app/core/utils/colors_manager.dart';
import 'package:app/app/widgets/appbar/appbar.dart';
import 'package:app/app/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({
    super.key,
    required this.imagePath,
    required this.message,
    required this.actionLabel,
    this.onAction,
  });

  final String imagePath;
  final String message;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Column(
            children: [
              const Spacer(),
              SvgPicture.asset(
                imagePath,
                width: 160.w,
                height: 160.w,
              ),
              24.verticalSpace,
              Text(
                message,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: actionLabel,
                  onTap: onAction ?? Get.back,
                  textColor: Colors.white,
                  buttonColor: AppColors.primaryColor,
                ),
              ),
              24.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
