import 'package:app/app/core/utils/app_images.dart';
import 'package:app/app/core/utils/strings_manager.dart';
import 'package:flutter/material.dart';

import 'status_screen.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return StatusScreen(
      imagePath: AppImages.error,
      message: AppStrings.verificationErrorMessage,
      actionLabel: AppStrings.verificationErrorAction,
      onAction: onRetry,
    );
  }
}
