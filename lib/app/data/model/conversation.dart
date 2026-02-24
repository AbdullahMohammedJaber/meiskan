import 'dart:convert';

import '../../core/constants.dart';

class ConversationModel {
  final int conversationId;
  final String projectId;
  final String projectTitle;
  final String contractorId;
  final String userName;
  final String lastMessage;
  final DateTime lastMessageAt;
  final bool isRead;

  ConversationModel({
    required this.conversationId,
    required this.projectId,
    required this.projectTitle,
    required this.contractorId,
    required this.userName,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.isRead,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      conversationId: json["converstion_Id"] as int? ?? 0,
      projectId: json["project_Id"] as String? ?? "",
      projectTitle: json["project_Title"] as String? ?? "",
      contractorId: json["contractor_Id"] as String? ?? "",
      userName: json["user_Name"] as String? ?? "",
      lastMessage: json["last_Message"] as String? ?? "",
      lastMessageAt:
          DateTime.tryParse(json["last_message_At"] as String? ?? "") ??
              DateTime.now(),
      isRead: json["hasUnreadMessages"] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "converstion_Id": conversationId,
      "project_Id": projectId,
      "project_Title": projectTitle,
      "contractor_Id": contractorId,
      "user_Name": userName,
      "last_Message": lastMessage,
      "last_message_At": lastMessageAt.toIso8601String(),
      "is_Read": isRead,
    };
  }

  @override
  String toString() {
    return '''
ConversationModel(
  conversationId: $conversationId,
  projectId: "$projectId",
  projectTitle: "$projectTitle",
  contractorId: "$contractorId",
  userName: "$userName",
  lastMessage: "$lastMessage",
  lastMessageAt: $lastMessageAt,
  isRead: $isRead
)''';
  }
}

class PaginatedConversations {
  PaginatedConversations({
    required this.conversations,
    required this.pageNumber,
    required this.totalPages,
    required this.totalCount,
  });

  final List<ConversationModel> conversations;
  final int pageNumber;
  final int totalPages;
  final int totalCount;
}

class MessageAttachment {
  static const Set<String> _imageExtensions = {
    'jpg',
    'jpeg',
    'png',
    'webp',
    'gif',
    'bmp',
    'tiff',
    'tif',
    'heic',
    'heif',
    'svg',
    'ico',
    'avif',
  };

  MessageAttachment({
    required this.id,
    required this.fileName,
    required this.url,
    required this.contentType,
    required this.size,
  });

  final int id;
  final String fileName;
  final String url;
  final String contentType;
  final int size;

  bool get isImage {
    final lowerType = contentType.toLowerCase();
    if (lowerType.startsWith('image/')) {
      return true;
    }

    final extension = _attachmentExtension;
    if (extension != null && _imageExtensions.contains(extension)) {
      return true;
    }
    final lowerUrl = url.toLowerCase();
    return lowerUrl.contains('/attachimg/');
  }

  String get absoluteUrl {
    final trimmed = url.trim();
    if (trimmed.isEmpty) {
      return '';
    }
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    final normalized = trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;

    final basePath = isImage ? 'attachImg' : 'attachFile';

    String  path;
    if (!normalized.contains('attachImg') &&
       ! normalized.contains('attachFile')) {
       path = normalized.isEmpty ? basePath : '$basePath/$normalized';
    }else{
      path = normalized;
    }

    print('${Constants.baseUrl}$path');
    return '${Constants.baseUrl}$path';
  }

  Map<String, dynamic> toJson() => {
        'attachment_Id': id,
        'file_Name': fileName,
        'url': url,
        'contnt_Type': contentType,
        'attachment_size': size,
      };

  static MessageAttachment? fromDynamic(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is MessageAttachment) {
      return value;
    }

    Map<String, dynamic>? mapped;
    if (value is Map) {
      mapped = value.map((key, val) => MapEntry(key.toString(), val));
    } else if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) {
        return null;
      }
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is Map<String, dynamic>) {
          mapped = decoded;
        }
      } catch (_) {
        // not a json string; treat as direct url
      }
      mapped ??= {
        'url': trimmed,
        'file_Name': trimmed.split('/').last,
      };
    }

    if (mapped == null) {
      return null;
    }

    final url = (mapped['url'] ??
            mapped['file_Url'] ??
            mapped['fileUrl'] ??
            mapped['path'] ??
            mapped['file_Name'] ??
            '')
        .toString();
    final fileName = (mapped['file_Name'] ??
            mapped['fileName'] ??
            (url.isNotEmpty ? url.split('/').last : ''))
        .toString();
    final contentType =
        (mapped['contnt_Type'] ?? mapped['contentType'] ?? '').toString();

    final size = _tryParseInt(
          mapped['attachment_size'] ?? mapped['file_Size'] ?? mapped['size'],
        ) ??
        0;

    final id = _tryParseInt(mapped['attachment_Id'] ?? mapped['id']) ??
        DateTime.now().millisecondsSinceEpoch;

    return MessageAttachment(
      id: id,
      fileName: fileName,
      url: url,
      contentType: contentType,
      size: size,
    );
  }

  String? get _attachmentExtension {
    final source = (fileName.isNotEmpty ? fileName : url).trim();
    if (source.isEmpty) {
      return null;
    }
    final sanitized = source.split('?').first.split('#').first;
    final dotIndex = sanitized.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == sanitized.length - 1) {
      return null;
    }
    return sanitized.substring(dotIndex + 1).toLowerCase();
  }
}

class PaginatedMessages {
  final List<MessageModel> messages;
  final int pageNumber;
  final int totalPages;
  final int totalCount;

  const PaginatedMessages({
    required this.messages,
    required this.pageNumber,
    required this.totalPages,
    required this.totalCount,
  });

  bool get hasMorePages => pageNumber < totalPages;

  PaginatedMessages copyWith({
    List<MessageModel>? messages,
    int? pageNumber,
    int? totalPages,
    int? totalCount,
  }) {
    return PaginatedMessages(
      messages: messages ?? this.messages,
      pageNumber: pageNumber ?? this.pageNumber,
      totalPages: totalPages ?? this.totalPages,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

class MessageModel {
  final int messageId;
  final String text;
  final DateTime createdAt;
  final bool isRead;
  final int conversationId;
  final String senderId;
  final String? senderName;
  final List<MessageAttachment> attachments;

  MessageModel({
    required this.messageId,
    required this.text,
    required this.createdAt,
    required this.isRead,
    required this.conversationId,
    required this.senderId,
    this.senderName,
    required this.attachments,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final attachments = <MessageAttachment>[];
    final rawAttachments = json['attachments'] ?? json['files'];
    if (rawAttachments is List) {
      for (final value in rawAttachments) {
        final attachment = MessageAttachment.fromDynamic(value);
        if (attachment != null) {
          attachments.add(attachment);
        }
      }
    }

    return MessageModel(
      messageId: _tryParseInt(
            json['message_Id'] ?? json['messageId'] ?? json['id'],
          ) ??
          0,
      text: (json['text'] ?? json['content'] ?? '').toString(),
      createdAt: DateTime.tryParse(
            (json['created_At'] ??
                        json['createdAt'] ??
                        json['created_at'] ??
                        json['timestamp'])
                    ?.toString() ??
                '',
          ) ??
          DateTime.now(),
      isRead: _tryParseBool(json['is_Read'] ?? json['isRead']) ?? false,
      conversationId: _tryParseInt(
            json['converstion_Id'] ?? json['conversationId'],
          ) ??
          0,
      senderId:
          (json['sender_Id'] ?? json['senderId'] ?? json['sender_id'] ?? '')
              .toString(),
      senderName: (json['sender_Name'] ?? json['senderName'])?.toString(),
      attachments: attachments,
    );
  }

  Map<String, dynamic> toJson() => {
        "message_Id": messageId,
        "text": text,
        "created_At": createdAt.toIso8601String(),
        "is_Read": isRead,
        "converstion_Id": conversationId,
        "sender_Id": senderId,
        "sender_Name": senderName,
        "attachments":
            attachments.map((attachment) => attachment.toJson()).toList(),
      };

  bool get hasText => text.trim().isNotEmpty;

  @override
  String toString() {
    return '''
MessageModel(
  messageId: $messageId,
  text: "$text",
  createdAt: $createdAt,
  isRead: $isRead,
  conversationId: $conversationId,
  senderId: "$senderId",
  senderName: ${senderName != null ? '"$senderName"' : "null"},
  attachments: $attachments
)''';
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

bool? _tryParseBool(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  }
  if (value is String) {
    final normalized = value.toLowerCase();
    if (normalized == 'true' || normalized == '1') {
      return true;
    }
    if (normalized == 'false' || normalized == '0') {
      return false;
    }
  }
  return null;
}
