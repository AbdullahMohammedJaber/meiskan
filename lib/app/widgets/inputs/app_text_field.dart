// ignore_for_file: must_be_immutable

import 'package:app/app/core/utils/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../core/utils/strings_manager.dart';

class AppTextField extends StatefulWidget {
  String? hint, svgIcon;
  final int? maxLength;
  final String? label;
  final bool password;
  final bool isRequired;
  final Function(String?)? onSaved;
  final Function(String)? onChanged;
  final Color? fillColor;
  final String? prefixText;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final  Function(String?)? onFieldSubmitted;
  InputDecoration? inputDecoration;
  TextInputAction? textInputAction;
  final TextInputType? textInputType;

  AppTextField(
      {super.key,
      this.onSaved,
      this.onChanged,
        this.textInputAction=TextInputAction.next,
      this.maxLength,
      this.onFieldSubmitted,
      this.label,
      this.fillColor,
      this.hint,
      this.maxLines = 1,
      this.svgIcon,
      this.inputDecoration,
      this.prefixText,
      this.inputFormatters,
      this.isRequired = true,
      this.password = false,
      this.controller,
      this.validator,
      this.textInputType});

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool hasError = false;
  bool visiblePassword = false;

  @override
  Widget build(BuildContext context) {
    final baseDecoration = widget.inputDecoration ?? const InputDecoration();
    final Widget? prefixIcon = widget.prefixText != null
        ? Padding(
            padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
            child: Text(
              widget.prefixText!,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: hasError ? AppColors.errorColor : null,
              ),
            ),
          )
        : (widget.svgIcon == null
            ? baseDecoration.prefixIcon
            : SvgPicture.asset(
                widget.svgIcon!,
                height: 16.w,
                width: 16.w,
                fit: BoxFit.scaleDown,
                color: hasError ? AppColors.errorColor : null,
              ));
    final prefixIconConstraints = widget.prefixText != null
        ? const BoxConstraints(minWidth: 0, minHeight: 0)
        : baseDecoration.prefixIconConstraints;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    widget.label!,
                    style: Get.textTheme.bodyMedium!.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                if (!widget.isRequired)
                  Text(
                    ' (${AppStrings.optional.tr})',
                    style: Get.textTheme.bodySmall!.copyWith(
                      fontSize: 10.sp,
                    ),
                  )
              ],
            ),
          ),
        TextFormField(
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          textInputAction: widget.textInputAction,
          onSaved: widget.onSaved,
          onChanged: widget.onChanged,
          maxLines: widget.password ? 1 : widget.maxLines,
          keyboardType: widget.textInputType,
          validator: (v) {
            if (widget.validator == null) return null;
            final tmp = widget.validator!(v);

            hasError = tmp != null;

            setState(() {});
            return tmp;
          },
          controller: widget.controller,
          cursorColor: AppColors.primaryColor,
          obscureText: visiblePassword,
          style: Get.textTheme.bodyMedium,
          textAlignVertical: TextAlignVertical.center,
          onFieldSubmitted: widget.onFieldSubmitted,
          decoration: baseDecoration.copyWith(
            filled: true,
            fillColor: widget.fillColor,
            suffixIcon: !widget.password
                ? null
                : IconButton(
                    onPressed: () =>
                        setState(() => visiblePassword = !visiblePassword),
                    icon: Icon(
                      visiblePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.grey,
                    ),
                  ),
            hintText: widget.hint,
            prefixIcon: prefixIcon,
            prefixIconConstraints: prefixIconConstraints,
          ),
        ),
      ],
    );
  }
}
