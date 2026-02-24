import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../core/network/error_handler.dart';
import '../core/network/failure.dart';
import '../data/model/category.dart';
import '../data/network/end_points.dart';

class CategoryServices {
  static final _dio = Get.find<Dio>();

  // Get all categories
  static Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final response = await _dio.get(EndPoints.getCategories);

      if (!response.data['isSucceeded']) {
        return Left(
          Failure(
            null,
            message: response.data['message'],
            messageEn: response.data['messageEn'],
          ),
        );
      }

      final data = response.data['data'] as List? ?? [];
        final List<CategoryModel> categories =
            data.map((json) => CategoryModel.fromJson(json)).toList();
        return Right(categories);
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }
}
