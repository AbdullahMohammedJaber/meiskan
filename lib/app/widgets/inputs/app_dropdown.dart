// ignore_for_file: must_be_immutable

import 'package:app/app/core/utils/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AppDropDown<T> extends StatefulWidget {
  final String? hint;
  final String? svgIcon;
  final String? label;
  final Function(T?)? onChanged;
  final Color? fillColor;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String? Function(T?)? validator;
  InputDecoration? inputDecoration;

  AppDropDown({
    super.key,
    this.hint,
    this.svgIcon,
    this.label,
    this.onChanged,
    this.fillColor,
    this.value,
    required this.items,
    this.validator,
    this.inputDecoration,
  });

  @override
  State<AppDropDown<T>> createState() => _AppDropDownState<T>();
}

class _AppDropDownState<T> extends State<AppDropDown<T>> {
  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Text(
              widget.label!,
              style: Get.textTheme.bodyMedium!.copyWith(
                fontSize: 14.sp,
              ),
            ),
          ),
        DropdownButtonFormField<T>(
          value: widget.value,
          items: widget.items,
          onChanged: widget.onChanged,
          validator: (v) {
            if (widget.validator == null) return null;
            final tmp = widget.validator!(v);

            hasError = tmp != null;

            setState(() {});
            return tmp;
          },
          style: Get.textTheme.bodyMedium,
          dropdownColor: AppColors.scaffoldBackgroundColor,
          iconEnabledColor: AppColors.grey,
          iconDisabledColor: AppColors.grey,
          decoration:
              (widget.inputDecoration ?? const InputDecoration()).copyWith(
            filled: true,
            fillColor: widget.fillColor,
            hintText: widget.hint,
            prefixIcon: widget.svgIcon == null
                ? null
                : SvgPicture.asset(
                    widget.svgIcon!,
                    height: 16.w,
                    width: 16.w,
                    fit: BoxFit.scaleDown,
                    color: hasError ? AppColors.errorColor : null,
                  ),
          ),
        ),
      ],
    );
  }
}
