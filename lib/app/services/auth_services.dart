import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

 import '../core/network/error_handler.dart';
import '../core/network/failure.dart';
import '../data/network/end_points.dart';
import '../data/network/responses/responses.dart';

class AuthServices {
  static final _dio = Get.find<Dio>();

  static Future<Either<Failure, dynamic>> signin({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required bool type, // true=Contractor, false=Owner
  }) async {
    try {
      final response = await _dio.post(
        EndPoints.signin,
        data: {
          'email': email,
          'password': password,
          'full_Name': fullName,
          'phone_Number': phoneNumber,
          'type': type,
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

      return Right(response.data);
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }

  static Future<Either<Failure, bool>> verifyAccount({
    required String phoneNumber,
    required String codeNumber,
  }) async {
    try {
      final response = await _dio.post(
        EndPoints.verifyAccount,
        data: {
          'phone_Number': phoneNumber,
          'code_Number': codeNumber,
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

      return Right(true);
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }

  // Resend activation code
  static Future<Either<Failure, bool>> resendActivationCode({
    required String phone,
  }) async {
    try {
      final response = await _dio.post(
        EndPoints.resendActivationCode,
        data: {
          'phone': phone,
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

  // Login
  static Future<Either<Failure, AuthResponse>> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        EndPoints.login,
        data: {
          'phone_Number': phoneNumber,
          'password': password,
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

      return Right(
          AuthResponse.fromJson(response.data['data'] as Map<String, dynamic>));
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }

  static Future<Either<Failure, dynamic>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final response = await _dio.post(
        EndPoints.refreshToken,
        data: {
          'refreshtoken': refreshToken,
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

      return Right(response.data);
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }

  static Future<Either<Failure, bool>> forgotPassword({
    required String phone,
  }) async {
    try {
      final response = await _dio.post(EndPoints.forgotPassword, data: {
        'phone_Number': phone,
      });

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

  static Future<Either<Failure, bool>> verifyCodeResetPassword({
    required String phoneNumber,
    required String codeNumber,
  }) async {
    try {
      final response = await _dio.post(
        EndPoints.verifyCodeResetPassword,
        data: {
          'phone_Number': phoneNumber,
          'code_Number': codeNumber,
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

      return Right(response.data['isSucceeded'] ?? false);
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }

  static Future<Either<Failure, bool>> resetPassword({
    required String newPassword,
    required String phone,
  }) async {
    try {
      final response = await _dio.post(
        EndPoints.resetPassword,
        data: {
          'password': newPassword,
          'phone_Number': phone,
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

      return const Right(true);
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }

  static Future<Either<Failure, dynamic>> getRoles() async {
    try {
      final response = await _dio.get(EndPoints.getRoles);

      if (!response.data['isSucceeded']) {
        return Left(
          Failure(
            null,
            message: response.data['message'],
            messageEn: response.data['messageEn'],
          ),
        );
      }

      return Right(response.data);
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }
}
