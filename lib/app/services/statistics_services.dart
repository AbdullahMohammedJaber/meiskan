import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../core/network/error_handler.dart';
import '../core/network/failure.dart';
import '../data/model/statistics_data.dart';
import '../data/network/end_points.dart';

class StatisticsServices {
  static final _dio = Get.find<Dio>();

  static Future<Either<Failure, StatisticsData>> getStatistics() async {
    try {
      final response = await _dio.get(EndPoints.getStatistics);

      if (!response.data['isSucceeded']) {
        return Left(
          Failure(
            null,
            message: response.data['message'],
            messageEn: response.data['messageEn'],
          ),
        );
      }

      final data = response.data['data'] as Map<String, dynamic>;
      return Right(StatisticsData.fromJson(data));
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }
}
