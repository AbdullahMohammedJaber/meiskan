import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../core/network/error_handler.dart';
import '../core/network/failure.dart';
import '../data/model/offer.dart';
import '../data/network/end_points.dart';

class OfferServices {
  static final _dio = Get.find<Dio>();

  // Create a new offer
 static Future<Either<Failure, ProjectOffer>> createOffer({
    required String projectId,
    required String offerDescription,
    required int offerDuration,
    required double offerPrice,
  }) async {
    try {

      final response = await _dio.post(
        EndPoints.createOffer,
        data: {
          'project_Id': projectId,
          'offer_Description': offerDescription,
          'offer_Duration': offerDuration,
          'offer_Price': offerPrice,

        },
      );

      if(!response.data['isSucceeded']){
        return Left(  Failure(
            null,
            message: response.data['message'],
            messageEn: response.data['messageEn'],
          ),);
      }

      return Right(ProjectOffer.fromJson(response.data));
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }

  // Delete an offer
  static Future<Either<Failure, bool>> deleteOffer({
    required String offerId,
  }) async {
    try {
      final response = await _dio.post(
        EndPoints.deleteOffer,
        queryParameters: {
          'offerid': offerId,
        },
      );

      if(!response.data['isSucceeded']){
        return Left(  Failure(
            null,
            message: response.data['message'],
            messageEn: response.data['messageEn'],
          ),);
      }

      return Right(response.data['success'] ?? false);
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }
}