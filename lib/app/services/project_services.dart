import 'package:app/app/core/enums/enums.dart';
import 'package:app/app/data/model/detailed_project.dart';
import 'package:app/app/modules/contractor/contractor_home/controllers/counter_controller.dart';
import 'package:app/app/modules/owner/owner_dashboard/controllers/counter_controller.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

import '../core/network/error_handler.dart';
import '../core/network/failure.dart';
import '../data/model/project.dart';
import '../data/network/end_points.dart';
import '../gobal_controllers/user_controller.dart';

class ProjectServices {
  static final _dio = Get.find<dio.Dio>();

  static Future<Either<Failure, List<ProjectModel>>> getProjects({
    required int pageNumber,
    required int pageSize,
    String? categoryId,
    String? cityName,
    String? areaName,
    String? searchValue,
    String? ownerId,
  }) async {
    try {
      final response = await _dio.get(
        EndPoints.getProjects,
        queryParameters: {
          'PageNumber': pageNumber,
          'PageSize': pageSize,
          if (categoryId != null) 'category_Id': categoryId,
          if (cityName != null) 'city_Name': cityName,
          if (areaName != null) 'area_Name': areaName,
          if (searchValue != null) 'search_Value': searchValue,
          if (ownerId != null) 'owner_Id': ownerId,
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

      final data = response.data['data']?['projects'] as List? ?? [];

      await Get.find<UserController>().getUser();
      final user = Get.find<UserController>().user.value;
      if (user!.type == AccountType.owner) {
        final countersController = Get.find<CountersController>();
        countersController.setCounters(
            notifications:
                response.data['data']['unread_Notifications_Count'] ?? 0,
            messages: response.data['data']['unread_Messages_Count'] ?? 0,
            allow_project: response.data['data']['project_Available'] ?? 0,
            total_project: response.data['data']['count'] ?? 0);
      } else {
        final countersControllerContractor =
            Get.find<CountersControllerContractor>();
        countersControllerContractor.setCounters(
          notifications:
              response.data['data']['unread_Notifications_Count'] ?? 0,
          messages: response.data['data']['unread_Messages_Count'] ?? 0,
        );
      }

      final List<ProjectModel> projects =
          data.map((json) => ProjectModel.fromJson(json)).toList();
      return Right(projects);
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }

  static Future<Either<Failure, DetailedProjectModel>> getProjectDetails({
    required String projectId,
  }) async {
    try {
      final user = Get.find<UserController>().user()!;
      final response = await _dio.get(
        EndPoints.detailsProject,
        queryParameters: {
          'projectid': projectId,
          'iscontractor': user.type == AccountType.contractor,
          'contractorid': user.id,
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

      return Right(DetailedProjectModel.fromJson(response.data['data']));
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }

  static Future<Either<Failure, String>> createProject({
    required String projectTitle,
    required String projectDescription,
    required String ownerId,
    required String cityName,
    required String areaName,
    required String address,
    required String categoryId,
    required String note,
    List<dio.MultipartFile>? images,
    dio.MultipartFile? pdfFile,
  }) async {
    try {
      final formData = dio.FormData.fromMap({
        'project_Title': projectTitle,
        'project_Description': projectDescription,
        'city_Name': cityName,
        'area_Name': areaName,
        'owner_Id': ownerId,
        'address': address,
        'category_Id': categoryId,
        'note': note,
        'images': images,
        if (pdfFile != null) 'file_Pdf': pdfFile,
      });

      final response = await _dio.post(
        EndPoints.createProject,
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

      return Right(response.data['data'].toString());
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }

  static Future<Either<Failure, bool>> deleteProject({
    required String projectId,
  }) async {
    try {
      final response = await _dio.post(
        EndPoints.deleteProject,
        queryParameters: {
          'id': projectId,
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
