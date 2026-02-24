import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../core/network/error_handler.dart';
import '../core/network/failure.dart';
import '../data/model/notification.dart';
import '../data/network/end_points.dart';

class NotificationServices {
  static final _dio = Get.find<Dio>();

  // Get user notifications with pagination
  static Future<Either<Failure, List<NotificationModel>>> getUserNotifications({
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await _dio.get(
        EndPoints.getUserNotifications,
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
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

      // Handle case where response is wrapped in an object
      final data = response.data['data'] as List? ?? [];
      final List<NotificationModel> notifications =
          data.map((json) => NotificationModel.fromJson(json)).toList();
      return Right(notifications);
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }

  // Mark notification as read
  static Future<Either<Failure, bool>> markAsRead() async {
    try {
      final response = await _dio.post(
        EndPoints.markAllAsRead,
        
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

      return Right(response.data['success'] ?? false);
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }

  // Read notification (from Users endpoint)
  static Future<Either<Failure, bool>> readNotification({
    required String notificationId,
  }) async {
    try {
      final response = await _dio.post(
        EndPoints.readNotification,
        queryParameters: {
          'id': notificationId,
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

      return Right(response.data['success'] ?? false);
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }

  // Delete old notifications
  static Future<Either<Failure, bool>> deleteOldNotifications() async {
    try {
      final response = await _dio.post(EndPoints.deleteOldNotifications);

      if (!response.data['isSucceeded']) {
        return Left(
          Failure(
            null,
            message: response.data['message'],
            messageEn: response.data['messageEn'],
          ),
        );
      }

      return Right(response.data['success'] ?? false);
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }
}
