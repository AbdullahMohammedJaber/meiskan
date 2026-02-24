import 'dart:convert';

import 'package:app/app/data/model/contractor_detailed_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

import '../core/network/error_handler.dart';
import '../core/network/failure.dart';
import '../data/locale/locale_provider.dart';
import '../data/locale/preferences_keys.dart';
import '../data/model/user.dart';
import '../data/network/end_points.dart';

class UserServices {
  static final _dio = Get.find<Dio>();
  static final _preferences = Get.find<AppPreferences>();

  static Future<Either<Failure, UserModel?>> getUser(String uid) async {
    try {
      final cachedUser = _preferences.read<dynamic>(PreferencesKeys.user);

      if (cachedUser == null) {
        return const Right(null);
      }

      Map<String, dynamic>? serialized;

      if (cachedUser is Map) {
        serialized = Map<String, dynamic>.from(cachedUser);
      } else if (cachedUser is String) {
        final decoded = jsonDecode(cachedUser);
        if (decoded is Map) {
          serialized = Map<String, dynamic>.from(decoded);
        }
      }

      if (serialized == null) {
        return const Right(null);
      }

      return Right(UserModel.fromJson(serialized));
    } catch (error) {
      return const Right(null);
    }
  }

  static Future<Either<Failure, void>> updateProfile({
    required String contractorId,
    required String fullName,
    required String emailContact,
    required String experiancDes,
    required String facebookLink,
    required String whatsappLink,
    required String snapchatLink,
    required String tiktokLink,
    required String instagramLink,
    required String linkedinLink,
    required String xLink,
    required String email,
  }) async {
    try {
      final response = await _dio.post(
        EndPoints.editContractor,
        data: {
          'full_Name': fullName,
          'email_Contact': emailContact,
          'experianc_Des': experiancDes,
          'facebook_Link': facebookLink,
          'whatsapp_Link': whatsappLink,
          'snapchat_Link': snapchatLink,
          'tiktok_Link': tiktokLink,
          'instagram_Link': instagramLink,
          'linkedin_Link': linkedinLink,
          'x_Link': xLink,
          'email': email,
          'contractor_Id': contractorId,
        },
      );
      if (!response.data['isSucceeded']) {
        return Left(  Failure(
            null,
            message: response.data['message'],
            messageEn: response.data['messageEn'],
          ),);
      }

      return Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace).failure);
    }
  }

  static Future<Either<Failure, ContractorDetailedModel>> getContractorDetails(
      userId) async {
    try {
      final response = await _dio.get(
        EndPoints.detailsContractor,
        queryParameters: {
          'userid': userId,
        },
      );
      if (!response.data['isSucceeded']) {
        return Left(  Failure(
            null,
            message: response.data['message'],
            messageEn: response.data['messageEn'],
          ),);
      }

      final updatedUser =
          ContractorDetailedModel.fromJson(response.data['data']);
      return Right(updatedUser);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace).failure);
    }
  }
}
