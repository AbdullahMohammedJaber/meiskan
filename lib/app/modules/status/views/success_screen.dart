import 'package:app/app/core/utils/app_images.dart';
import 'package:app/app/core/utils/strings_manager.dart';
import 'package:flutter/material.dart';

import 'status_screen.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, this.onContinue});

  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return StatusScreen(
      imagePath: AppImages.success,
      message: AppStrings.verificationSuccessMessage,
      actionLabel: AppStrings.verificationSuccessAction,
      onAction: onContinue,
    );
  }
}
