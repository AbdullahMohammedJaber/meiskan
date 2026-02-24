import 'package:flutter/material.dart';
import 'package:get/get.dart';

void appSnackbar(String? message, {SnackbarType type = SnackbarType.SUCCESS}) {
  Color backgroundColor;
  Color textColor;

  switch (type) {
    case SnackbarType.SUCCESS:
      backgroundColor = Colors.green;
      textColor = Colors.white;
      break;
    case SnackbarType.ERROR:
      backgroundColor = Colors.red;
      textColor = Colors.white;
      break;
    case SnackbarType.WARNING:
      backgroundColor = Colors.amber;
      textColor = Colors.black;
      break;
    default:
      backgroundColor = Colors.grey;
      textColor = Colors.white;
  }

  Get.snackbar(
    type.toString().split('.').last.toLowerCase().tr, // Title (SnackbarType converted to string)
    message??'', // Message
    snackPosition: SnackPosition.BOTTOM, // Position
    backgroundColor: backgroundColor, // Background color
    colorText: textColor, // Text color
    borderRadius: 10, // Border radius
    margin: const EdgeInsets.all(10), // Margin around the snackbar
    duration: const Duration(seconds: 3), // Duration the snackbar should be displayed
    isDismissible: true, // Snackbar is dismissible on tap
    forwardAnimationCurve: Curves.easeOutBack, // Animation curve for showing
    reverseAnimationCurve: Curves.easeInBack, // Animation curve for hiding
    animationDuration: const Duration(milliseconds: 500), // Animation duration
    snackStyle: SnackStyle.FLOATING, // Snackbar style
  );
}

enum SnackbarType { SUCCESS, ERROR, WARNING, INFO }

