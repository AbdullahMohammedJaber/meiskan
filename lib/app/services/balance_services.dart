import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../core/network/error_handler.dart';
import '../core/network/failure.dart';
import '../data/network/end_points.dart';

class BalanceServices {
  static final _dio = Get.find<Dio>();

  static Future<Either<Failure, String>> purchasePoints({
    required int points,
  }) async {
    try {
      final response = await _dio.post(
        EndPoints.purchasePoint,
        queryParameters: {
          'points': points,
        },
      );

      if (!response.data['isSucceeded']) {
        return Left(
          Failure(
            null,
            message: response.data['message'],
            messageEn: response.data['messageEn'],
          ),
        );
      }

      final paymentUrl =
          response.data['data']?['paymentUrl']?.toString() ?? '';
      return Right(paymentUrl);
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }
}
