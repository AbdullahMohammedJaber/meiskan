// ignore_for_file: unused_catch_stack, constant_identifier_names

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../core/utils/strings_manager.dart';
import 'failure.dart';

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error, StackTrace? stackTrace) {
    try {
      if (error is DioException) {
        failure = _handleDioError(error);
      } else {
        // FirebaseCrashlytics.instance.recordError(error, stackTrace);
        failure = DataSource.DEFAULT.getFailure();
      }
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
      failure = DataSource.DEFAULT.getFailure();
    }
  }
}

Failure _handleDioError(DioException error) {
  if (error.response?.data != null) {
    return Failure(
      error.response?.statusCode,
      message: error.response?.data?["message"]?.toString() ?? "",
      messageEn: error.response?.data?["messageEn"]?.toString() ?? "",
    );
  }

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return DataSource.CONNECT_TIMEOUT.getFailure();
    case DioExceptionType.sendTimeout:
      return DataSource.SEND_TIMEOUT.getFailure();
    case DioExceptionType.receiveTimeout:
      return DataSource.RECIEVE_TIMEOUT.getFailure();
    case DioExceptionType.cancel:
      return DataSource.CANCEL.getFailure();
    case DioExceptionType.connectionError:
      return DataSource.CONNECT_TIMEOUT.getFailure();
    default:
      return DataSource.DEFAULT.getFailure();
  }
}

enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  DEFAULT
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.SUCCESS:
        return Failure(
          ResponseCode.SUCCESS,
          message: ResponseMessage.SUCCESS.tr,
        );
      case DataSource.NO_CONTENT:
        return Failure(
          ResponseCode.NO_CONTENT,
          message: ResponseMessage.NO_CONTENT.tr,
        );
      case DataSource.BAD_REQUEST:
        return Failure(
          ResponseCode.BAD_REQUEST,
          message: ResponseMessage.BAD_REQUEST.tr,
        );
      case DataSource.FORBIDDEN:
        return Failure(
          ResponseCode.FORBIDDEN,
          message: ResponseMessage.FORBIDDEN.tr,
        );
      case DataSource.UNAUTORISED:
        return Failure(ResponseCode.UNAUTORISED,
            message: ResponseMessage.UNAUTORISED.tr);
      case DataSource.NOT_FOUND:
        return Failure(ResponseCode.NOT_FOUND,
            message: ResponseMessage.NOT_FOUND.tr);
      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(ResponseCode.INTERNAL_SERVER_ERROR,
            message: ResponseMessage.INTERNAL_SERVER_ERROR.tr);
      case DataSource.CONNECT_TIMEOUT:
        return Failure(ResponseCode.CONNECT_TIMEOUT,
            message: ResponseMessage.CONNECT_TIMEOUT.tr);
      case DataSource.CANCEL:
        return Failure(ResponseCode.CANCEL, message: ResponseMessage.CANCEL.tr);
      case DataSource.RECIEVE_TIMEOUT:
        return Failure(ResponseCode.RECIEVE_TIMEOUT,
            message: ResponseMessage.RECIEVE_TIMEOUT.tr);
      case DataSource.SEND_TIMEOUT:
        return Failure(ResponseCode.SEND_TIMEOUT,
            message: ResponseMessage.SEND_TIMEOUT.tr);
      case DataSource.CACHE_ERROR:
        return Failure(ResponseCode.CACHE_ERROR,
            message: ResponseMessage.CACHE_ERROR.tr);
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(ResponseCode.NO_INTERNET_CONNECTION,
            message: ResponseMessage.NO_INTERNET_CONNECTION.tr);
      case DataSource.DEFAULT:
        return Failure(ResponseCode.DEFAULT,
            message: ResponseMessage.DEFAULT.tr);
    }
  }
}

class ResponseCode {
  static const int SUCCESS = 200;
  static const int NO_CONTENT = 201;
  static const int BAD_REQUEST = 400;
  static const int UNAUTORISED = 401;
  static const int FORBIDDEN = 403;
  static const int INTERNAL_SERVER_ERROR = 500;
  static const int NOT_FOUND = 404;

  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECIEVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;
}

class ResponseMessage {
  static const String SUCCESS = AppStrings.success;
  static const String NO_CONTENT = AppStrings.success;
  static const String BAD_REQUEST = AppStrings.badRequestError;
  static const String UNAUTORISED = AppStrings.unauthorizedError;
  static const String FORBIDDEN = AppStrings.forbiddenError;
  static const String INTERNAL_SERVER_ERROR = AppStrings.internalServerError;
  static const String NOT_FOUND = AppStrings.notFoundError;

  static const String CONNECT_TIMEOUT = AppStrings.noInternetError;
  static const String CANCEL = AppStrings.defaultError;
  static const String RECIEVE_TIMEOUT = AppStrings.noInternetError;
  static const String SEND_TIMEOUT = AppStrings.noInternetError;
  static const String CACHE_ERROR = AppStrings.cacheError;
  static const String NO_INTERNET_CONNECTION = AppStrings.noInternetError;
  static const String DEFAULT = AppStrings.defaultError;
}

class ApiInternalStatus {
  static const int SUCCESS = 0;
  static const int FAILURE = 1;
}
