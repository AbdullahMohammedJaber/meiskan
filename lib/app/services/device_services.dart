import 'dart:io';

 import 'package:app/app/core/fcm/fcm.dart';
 import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../data/network/end_points.dart';

class DeviceServices {
  static final _dio = Get.find<Dio>();

  static Future<void> saveToken() async {
    
    if (token!.isEmpty) {
      return;
    }

    final platform = Platform.isAndroid
        ? 'android'
        : Platform.isIOS
            ? 'ios'
            : Platform.operatingSystem;

    try {
      await _dio.post(
        EndPoints.saveDeviceToken,
        data: {
          'deviceToken': token,
          'platform': platform,
        },
      );
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('Failed to save device token: $error\n$stackTrace');
      }
    }
  }
}
