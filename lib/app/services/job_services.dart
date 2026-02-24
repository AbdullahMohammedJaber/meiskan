import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../core/network/error_handler.dart';
import '../core/network/failure.dart';
import '../core/utils/image_to_form.dart';
import '../data/model/job.dart';
import '../data/network/end_points.dart';

class JobServices {
  static final _dio = Get.find<dio.Dio>();

  static Future<Either<Failure, JobModel>> getJobDetails({
    required String jobId,
  }) async {
    try {
      final response = await _dio.get(
        EndPoints.detailsJob,
        queryParameters: {
          'jobId': jobId,
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

      return Right(JobModel.fromJson(response.data));
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }

  // Create a new job
  static Future<Either<Failure, JobModel>> createJob({
    String? companyName,
    String? contractorId,
    String? descriptionAr,
    String? descriptionEn,
    String? location,
    XFile? image,
  }) async {
    try {
      final formData = dio.FormData.fromMap({
        'company_Name': companyName,
        'contractor_Id': contractorId,
        'description_Ar': descriptionAr,
        'description_En': descriptionEn,
        'location': location,
        if (image != null) 'upload': await imageToForm(image),
      });

      final response = await _dio.post(
        EndPoints.createJob,
        data: formData,
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

      return Right(JobModel.fromJson(response.data));
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }

  static Future<Either<Failure, JobModel>> updateJob({
    required String jobId,
    required String companyName,
    required String descriptionAr,
    required String descriptionEn,
    required String location,
    XFile? image,
  }) async {
    try {
      final formData = dio.FormData.fromMap({
        'job_Id': jobId,
        'company_Name': companyName,
        'description_Ar': descriptionAr,
        'description_En': descriptionEn,
        'location': location,
        if (image != null) 'upload': await imageToForm(image),
      });

      final response = await _dio.post(
        EndPoints.updateJob,
        data: formData,
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

      return Right(JobModel.fromJson(response.data));
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }

  // Delete a job
  static Future<Either<Failure, bool>> deleteJob({
    required String jobId,
  }) async {
    try {
      final response = await _dio.post(
        EndPoints.deleteJob,
        queryParameters: {
          'jobId': jobId,
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
}
