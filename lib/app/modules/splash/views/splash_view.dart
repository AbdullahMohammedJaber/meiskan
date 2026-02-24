// ignore_for_file: must_be_immutable

import 'package:app/app/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  SplashView({super.key});

  @override
  SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          alignment:  Alignment.center,
          color: const Color(0xffE4DFD6),
          child: Image.asset(
            AppImages.logoNamed,
          ),
        ),
      );
}
