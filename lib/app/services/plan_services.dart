// ignore_for_file: unused_local_variable

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../core/network/error_handler.dart';
import '../core/network/failure.dart';
import '../data/model/plan.dart';
import '../data/network/end_points.dart';

class PlanServices {
  static final _dio = Get.find<Dio>();

  static Future<Either<Failure, List<PointOfferModel>>> getAllPlans() async {
    try {
      final response = await _dio.get(EndPoints.pointOffers);

      if (!response.data['isSucceeded']) {
        return Left(  Failure(
            null,
            message: response.data['message'],
            messageEn: response.data['messageEn'],
          ),);
      }


        final data = response.data['data'] as List? ?? [];
          final List<PointOfferModel> plans =
              data.map((json) => PointOfferModel.fromJson(json)).toList();
          return Right(plans);

    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }

  static Future<Either<Failure, void>> cancelPlanById(planId) async {
    try {
      final response = await _dio.post('${EndPoints.cancelPlan}/$planId');

     /* if (!response.data['isSucceeded']) {
        return Left(  Failure(
            null,
            message: response.data['message'],
            messageEn: response.data['messageEn'],
          ),);
      }*/

      return const Right(null);
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }

  static Future<Either<Failure, String>> purchaseOfferPoint({
    required int offerId,
  }) async {
    try {
      final response = await _dio.post(
        EndPoints.purchaseOfferPoint,
        queryParameters: {
          'offerId': offerId,
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
