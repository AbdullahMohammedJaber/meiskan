import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

import '../core/network/error_handler.dart';
import '../core/network/failure.dart';
import '../data/model/conversation.dart';
import '../data/network/end_points.dart';

class ConversationServices {
  static final _dio = Get.find<Dio>();

   static Future<Either<Failure, PaginatedConversations>> getConversations({
    String? projectId,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _dio.get(
        EndPoints.getConversations,
        queryParameters: {
          if (projectId != null) 'project_Id': projectId,
          'PageNumber': pageNumber,
          'PageSize': pageSize,
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

      final dynamic dataWrapper = response.data['data'];
      final conversationsRaw =
          dataWrapper['converstions'] as List<dynamic>? ?? const [];
      final conversations = conversationsRaw
          .map((json) => ConversationModel.fromJson(
              Map<String, dynamic>.from(json as Map)))
          .toList();

      final pageNum = _tryParseInt(dataWrapper['page_Num']) ?? pageNumber;
      final pageCount = _tryParseInt(dataWrapper['page_Count']) ?? pageNum;
      final totalCount =
          _tryParseInt(dataWrapper['count']) ?? conversations.length;

      return Right(
        PaginatedConversations(
          conversations: conversations,
          pageNumber: pageNum,
          totalPages: pageCount,
          totalCount: totalCount,
        ),
      );
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }

  static Future<Either<Failure, ConversationModel>> getConversationDetails({
    required String conversationId,
  }) async {
    try {
      final response = await _dio.get(
        EndPoints.getConversationDetails,
        queryParameters: {
          'conversationId': conversationId,
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

      return Right(ConversationModel.fromJson(response.data));
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }

  static Future<Either<Failure, bool>> sendMessage({
    required String conversationId,
    required String message,
  }) async {
    try {
      final response = await _dio.post(
        EndPoints.sendMessage,
        data: {
          'conversationId': conversationId,
          'message': message,
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


  static Future<Either<Failure, ConversationModel>> createConversation({
    required String recipientId,
    String? initialMessage,
  }) async {
    try {
      final data = {
        'recipientId': recipientId,
      };

      if (initialMessage != null) {
        data['initialMessage'] = initialMessage;
      }

      final response = await _dio.post(
        EndPoints.createConversation,
        data: data,
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

      return Right(ConversationModel.fromJson(response.data));
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }


  static Future<Either<Failure, PaginatedMessages>> getMessages({
    required String conversationId,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _dio.get(
        EndPoints.getMessages,
        queryParameters: {
          'converstion_Id': conversationId,
          'PageNumber': pageNumber,
          'PageSize': pageSize,
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

      final data = response.data['data']['messages'] as List? ?? [];
      final List<MessageModel> messages =
          data.map((json) => MessageModel.fromJson(json)).toList();
      final dynamic rawPage = response.data['data']['page_Num'];
      final dynamic rawPageCount = response.data['data']['page_Count'];
      final dynamic rawCount = response.data['data']['count'];

      final resolvedPage = _tryParseInt(rawPage) ?? pageNumber;
      final resolvedPageCount = _tryParseInt(rawPageCount) ?? resolvedPage;
      final resolvedCount = _tryParseInt(rawCount) ?? messages.length;

      return Right(
        PaginatedMessages(
          messages: messages,
          pageNumber: resolvedPage,
          totalPages: resolvedPageCount,
          totalCount: resolvedCount,
        ),
      );
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }

  static Future<Either<Failure, List<Map<String, dynamic>>>>
      uploadConversationFiles({
    required List<PlatformFile> files,
    required bool isImage,
  }) async {
    try {
      final formData = FormData();
      for (final file in files) {
        if (file.path != null && file.path!.isNotEmpty) {
          formData.files.add(
            MapEntry(
              'files',
              await MultipartFile.fromFile(
                file.path!,
                filename: file.name,
              ),
            ),
          );
        } else if (file.bytes != null) {
          formData.files.add(
            MapEntry(
              'files',
              MultipartFile.fromBytes(
                file.bytes!,
                filename: file.name,
              ),
            ),
          );
        }
      }
      formData.fields.add(MapEntry('is_Image', isImage.toString()));

      final response = await _dio.post(
        EndPoints.uploadConversationFiles,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.data is Map && response.data['isSucceeded'] == true) {
        final rawData = response.data['data'] as List?;
        final normalized = rawData
                ?.whereType<Map>()
                .map((entry) => entry.map(
                      (key, value) => MapEntry(key.toString(), value),
                    ))
                .cast<Map<String, dynamic>>()
                .toList() ??
            <Map<String, dynamic>>[];
        return Right(normalized);
      }

      return Left(Failure(
        response.statusCode,
        message: response.data['message'],
        messageEn: response.data['messageEn'],
      ));
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace).failure);
    }
  }
}

int? _tryParseInt(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}
