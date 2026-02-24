// ignore_for_file: body_might_complete_normally_catch_error

import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../data/locale/locale_provider.dart';
import '../data/model/conversation.dart';

class ConversationMessage {
  ConversationMessage({
    required this.conversationId,
    required this.message,
  });

  final int conversationId;
  final MessageModel message;
@override
  String toString() {
return ''''
conversationId => $conversationId,
message => ${message.toString()},
''';
}

}

class ChatHubService extends GetxService {
  HubConnection? _connection;
  String? _connectedUserId;
  int? _activeConversationId;
  Future<void>? _connectingFuture;
  MethodInvocationFunc? _messageHandler;
  final List<Completer<int>> _pendingConversationResolvers =
      <Completer<int>>[];

  final _messageStreamController =
      StreamController<ConversationMessage>.broadcast();

  Stream<ConversationMessage> get messagesStream =>
      _messageStreamController.stream;

  HubConnection? get connection => _connection;

  int? get activeConversationId => _activeConversationId;

  bool get isConnected =>
      _connection?.state == HubConnectionState.Connected &&
      _connectedUserId != null;

  Future<void> connectIfNeeded({required String userId}) async {
    if (_connection != null) {
      if (_connectedUserId != userId) {
        await _disposeConnection();
      } else {
        final state = _connection!.state;
        if (state == HubConnectionState.Connected ||
            state == HubConnectionState.Connecting ||
            state == HubConnectionState.Reconnecting) {
          if (_connectingFuture != null) {
            await _connectingFuture;
          }
          return;
        }
      }
    }

    _connectingFuture ??= _startConnection(userId);
    try {
      await _connectingFuture;
    } finally {
      _connectingFuture = null;
    }
  }

  Future<void> joinConversation(int conversationId) async {
    if (conversationId <= 0) {
      return;
    }

    final hubConnection = _connection;
    if (hubConnection == null) {
      throw StateError(
        'SignalR connection is not initialised. Call connectIfNeeded first.',
      );
    }

    await _ensureConnectionReady(hubConnection);

    await hubConnection.invoke(
      'JoinConversation',
      args: [conversationId],
    );

    _activeConversationId = conversationId;
  }

  Future<int> sendMessage({
    required int conversationId,
    required dynamic contractorId,
    required String projectId,
    required String text,
    bool allowConversationCreation = false,
    List<String>? files,
  }) async {
    final hubConnection = _connection;
    if (hubConnection == null) {
      throw StateError(
        'SignalR connection is not initialised. Call connectIfNeeded first.',
      );
    }

    await _ensureConnectionReady(hubConnection);

    final normalizedContractor = contractorId is int
        ? contractorId
        : int.tryParse('$contractorId') ?? contractorId;

    var targetConversationId = conversationId;
    if (targetConversationId <= 0 && allowConversationCreation) {
      targetConversationId = await _createConversationViaSend(
        contractorId: normalizedContractor,
        projectId: projectId,
      );
    }

    if (targetConversationId <= 0) {
      throw StateError(
        'Conversation id is required to send message. Provide a valid id or enable creation.',
      );
    }

    final sendPayload = _buildMessagePayload(
      contractorId: normalizedContractor,
      projectId: projectId,
      conversationId: targetConversationId,
      text: text,
      files: files,
    );

    final responseConversationId = await _invokeSendMessage(sendPayload);

    return responseConversationId ?? targetConversationId;
  }

  Future<void> _startConnection(String userId) async {
    final preferences = Get.find<AppPreferences>();
    final token = preferences.token;

    final headers = MessageHeaders();
    if (token.isNotEmpty) {
      headers.setHeaderValue(
        MessageHeaders.AuthorizationHeaderName,
        'Bearer $token',
      );
    }

    final options = HttpConnectionOptions(
      transport: HttpTransportType.WebSockets,
      headers: headers.isEmpty ? null : headers,
      skipNegotiation: true,
      requestTimeout: 20000,
      accessTokenFactory: token.isNotEmpty ? () async => token : null,
    );

    final connection = HubConnectionBuilder()
        .withUrl(
          'https://api.meiskan.com/chathubmieskan?userId=$userId',
          options: options,
        )
        .withAutomaticReconnect()
        .build();

    _registerLifecycleCallbacks(connection);
    _registerMessageHandler(connection);

    await connection.start();

    _connection = connection;
    _connectedUserId = userId;
  }

  void _registerLifecycleCallbacks(HubConnection connection) {
    connection.onclose(({Exception? error}) {
      _activeConversationId = null;
    });

    connection.onreconnected(({String? connectionId}) {
      if (_activeConversationId != null) {
        connection.invoke(
          'JoinConversation',
          args: [_activeConversationId!],
        ).catchError((_) {
          // ignored on reconnect failure; the join will retry on next reconnection
        });
      }
    });
  }

  void _registerMessageHandler(HubConnection connection) {
    connection.off('message:received');

    _messageHandler ??= (arguments) {
      final mapped = _mapIncomingMessage(arguments);
      if (mapped != null) {
        _messageStreamController.add(mapped);
      }
    };

    connection.on('message:received', _messageHandler!);
  }

  ConversationMessage? _mapIncomingMessage(List<Object?>? arguments) {
    print('argumentsarguments => $arguments');
    if (arguments == null || arguments.isEmpty) {
      return null;
    }

    final payload = arguments.first;
    Map<String, dynamic>? data;

    if (payload is Map) {
      data = payload.map(
        (key, value) => MapEntry(key.toString(), value),
      );
    } else if (payload is String) {
      try {
        final decoded = jsonDecode(payload);
        if (decoded is Map<String, dynamic>) {
          data = decoded;
        }
      } catch (_) {
        return null;
      }
    }

    if (data == null) {
      return null;
    }

    final conversationId = _tryParseInt(
          data['conversationId'] ?? data['converstion_Id'],
        ) ??
        _activeConversationId;

    if (conversationId == null) {
      return null;
    }

    if (conversationId > 0) {
      _notifyConversationId(conversationId);
    }

    final messageMap = _normalizeMessageMap(data);
    if (messageMap == null) {
      return null;
    }

    try {
      final message = MessageModel.fromJson(messageMap);

      return ConversationMessage(
        conversationId: conversationId,
        message: message,
      );
    } catch (_) {
      return null;
    }
  }

  int? _extractConversationId(Object? result) {
    print('_extractConversationId_extractConversationId_extractConversationId');
    print('result => $result');
    if (result == null) {
      return null;
    }

    if (result is int) {
      return result;
    }

    if (result is num) {
      return result.toInt();
    }

    if (result is String) {
      final parsed = int.tryParse(result);
      if (parsed != null) {
        return parsed;
      }
      try {
        final decoded = jsonDecode(result);
        return _extractConversationId(decoded);
      } catch (_) {
        return null;
      }
    }

    if (result is Map) {
      final normalized = result.map(
        (key, value) => MapEntry(key.toString(), value),
      );
      return _tryParseInt(
        normalized['conversationId'] ??
            normalized['converstion_Id'] ??
            normalized['id'],
      );
    }

    if (result is List && result.isNotEmpty) {
      return _extractConversationId(result.first);
    }

    return null;
  }

  void _notifyConversationId(int conversationId) {
    if (conversationId <= 0) {
      return;
    }
    _activeConversationId = conversationId;
    if (_pendingConversationResolvers.isEmpty) {
      return;
    }
    final pending = List<Completer<int>>.from(_pendingConversationResolvers);
    _pendingConversationResolvers.clear();
    for (final completer in pending) {
      if (!completer.isCompleted) {
        completer.complete(conversationId);
      }
    }
  }

  Future<int?> _awaitConversationId({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final completer = Completer<int>();
    _pendingConversationResolvers.add(completer);
    try {
      return await completer.future.timeout(timeout);
    } on TimeoutException {
      return null;
    } finally {
      _pendingConversationResolvers.remove(completer);
    }
  }

  Map<String, dynamic>? _normalizeMessageMap(Map<String, dynamic> data) {
    final textSource = data['text'] ;
    final attachments = _normalizeAttachments(data);

    if ((textSource == null || textSource.toString().isEmpty) &&
        (attachments == null || attachments.isEmpty)) {
      return null;
    }

    final createdAtSource = data['created_At'] ??
        data['createdAt'] ??
        data['created_at'] ??
        data['timestamp'];

    final normalized = <String, dynamic>{
      'message_Id': _tryParseInt(
            data['message_Id'] ?? data['messageId'] ?? data['id'],
          ) ??
          DateTime.now().millisecondsSinceEpoch,
      'text': (textSource ?? '').toString(),
      'created_At': _normalizeDate(createdAtSource),
      'is_Read': _normalizeBool(data['is_Read'] ?? data['isRead']),
      'converstion_Id': _tryParseInt(
            data['converstion_Id'] ?? data['conversationId'],
          ) ??
          (_activeConversationId ?? 0),
      'sender_Id':
          (data['sender_Id'] ?? data['senderId'] ?? data['sender_id'] ?? '')
              .toString(),
      'sender_Name':
          (data['sender_Name'] ?? data['senderName'] ?? '').toString(),
    };

    if (attachments != null && attachments.isNotEmpty) {
      normalized['attachments'] = attachments;
    }

    return normalized;
  }

  Future<void> _ensureConnectionReady(HubConnection connection) async {
    final state = connection.state;

    if (state == HubConnectionState.Connected) {
      return;
    }

    if (state == HubConnectionState.Connecting ||
        state == HubConnectionState.Reconnecting) {
      await connection.stateStream
          .firstWhere((status) => status == HubConnectionState.Connected);
      return;
    }

    await connection.start();
  }

  Future<void> _disposeConnection() async {
    final hub = _connection;
    _connection = null;
    _connectedUserId = null;
    _activeConversationId = null;

    if (hub != null) {
      try {
        await hub.stop();
      } catch (_) {
        // ignored
      }
    }
  }

  int? _tryParseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  bool _normalizeBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final normalized = value.toLowerCase();
      return normalized == 'true' || normalized == '1';
    }
    return true;
  }

  String _normalizeDate(dynamic value) {
    if (value == null) {
      return DateTime.now().toIso8601String();
    }
    if (value is DateTime) {
      return value.toIso8601String();
    }
    final parsed = DateTime.tryParse(value.toString());
    return (parsed ?? DateTime.now()).toIso8601String();
  }

  @override
  void onClose() {
    if (!_messageStreamController.isClosed) {
      _messageStreamController.close();
    }
    super.onClose();
  }

  List<Map<String, dynamic>>? _normalizeAttachments(
      Map<String, dynamic> data) {
    final raw = data['attachments'] ?? data['files'];
    if (raw == null || raw is! List) {
      return null;
    }

    final normalized = <Map<String, dynamic>>[];
    for (final entry in raw) {
      final attachment = _normalizeAttachmentEntry(entry);
      if (attachment != null) {
        normalized.add(attachment);
      }
    }
    return normalized.isEmpty ? null : normalized;
  }

  Map<String, dynamic>? _normalizeAttachmentEntry(dynamic entry) {
    if (entry == null) {
      return null;
    }

    Map<String, dynamic>? mapped;
    if (entry is Map) {
      mapped = entry.map((key, value) => MapEntry(key.toString(), value));
    } else if (entry is String) {
      final trimmed = entry.trim();
      if (trimmed.isEmpty) {
        return null;
      }
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is Map<String, dynamic>) {
          mapped = decoded;
        }
      } catch (_) {
        mapped = {'url': trimmed, 'file_Name': trimmed.split('/').last};
      }
    }

    if (mapped == null) {
      return null;
    }

    final id = _tryParseInt(mapped['attachment_Id'] ?? mapped['id']) ??
        DateTime.now().millisecondsSinceEpoch;
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

    return {
      'attachment_Id': id,
      'file_Name': fileName,
      'contnt_Type': contentType,
      'attachment_size': size,
      'url': url,
    };
  }

  Map<String, dynamic> _buildMessagePayload({
    required dynamic contractorId,
    required String projectId,
    required int conversationId,
    required String text,
    List<String>? files,
  }) {
    final payload = <String, dynamic>{
      'converstion_Id': conversationId,
      'contractor_Id': contractorId,
      'project_Id': projectId,
      'text': text,
    };
    if (files != null && files.isNotEmpty) {
      payload['files'] = files.toString();
    }
    return payload;
  }

  Future<int> _createConversationViaSend({
    required dynamic contractorId,
    required String projectId,
  }) async {
    final creationPayload = _buildMessagePayload(
      contractorId: contractorId,
      projectId: projectId,
      conversationId: 0,
      text: '',
      files: const [],
    );

    final waitForConversation = _awaitConversationId();
    final createdId = await _invokeSendMessage(creationPayload);
    print('createdId ${createdId}');
    print('_activeConversationId ${_activeConversationId}');
    if (createdId != null && createdId > 0) {
      return createdId;
    }

    final activeId = _activeConversationId;
    if (activeId != null && activeId > 0) {
      return activeId;
    }

    final awaitedId = await waitForConversation;
    if (awaitedId != null && awaitedId > 0) {
      return awaitedId;
    }

    throw StateError('Failed to create conversation via SendMessage.');
  }

  Future<int?> _invokeSendMessage(Map<String, dynamic> payload) async {
    final hubConnection = _connection;
    if (hubConnection == null) {
      throw StateError(
        'SignalR connection is not initialised. Call connectIfNeeded first.',
      );
    }

    final result = await hubConnection.invoke(
      'SendMessage',
      args: [payload],
    );
    print('resultresult $result');
    final conversationId = _extractConversationId(result);
    if (conversationId != null && conversationId > 0) {
      _notifyConversationId(conversationId);
    }
    return conversationId;
  }
}
