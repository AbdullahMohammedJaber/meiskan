import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 import 'package:pin_code_fields/pin_code_fields.dart';

import '../core/utils/colors_manager.dart';
import '../core/utils/validator.dart';

class OtpInput extends StatelessWidget {
  final Function(String code) onDone;
  final ValueChanged<String>? onChanged;

  const OtpInput({super.key, required this.onDone, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: PinCodeTextField(
        errorTextSpace: 25.sp,
        validator: Validator.smsCodeValidator,
        autovalidateMode: AutovalidateMode.disabled,
        length: 6,
        autoFocus:true,
        obscureText: false,
        animationType: AnimationType.fade,
        cursorWidth: 2,
        enablePinAutofill: true,

        enableActiveFill: true,
        backgroundColor: Colors.transparent,
        cursorColor: AppColors.primaryColor,
        textStyle: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),

        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(7.r),
          fieldHeight: 55.h,
          fieldWidth: 44.w,
          borderWidth: 1,

          selectedColor: AppColors.primaryColor,
          selectedFillColor: const Color(0xff3A8577).withOpacity(0.1),

          // Active state (has focus)
          activeColor: Colors.grey.shade300,
          activeFillColor: Colors.white,

          // Inactive state (empty fields)
          inactiveColor: Colors.grey.shade300,
          inactiveFillColor: Colors.white,

          // Disabled state
          disabledColor: Colors.grey.shade200,
        ),
        animationDuration: const Duration(milliseconds: 300),
        onCompleted: (code) {
          onChanged?.call(code);
          onDone(code);
        },
        onChanged: onChanged,
        beforeTextPaste: (text) {
          return true;
        },
        appContext: context,
        keyboardType: TextInputType.number,
      ),
    );
  }
}
