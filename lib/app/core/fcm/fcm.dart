// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app/app/modules/conversations/controllers/conversations_controller.dart';
import 'package:app/app/widgets/appbar/appbar.dart';
import 'package:app/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

String? token;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final String _channelId = "fcm_fallback";

  Future<void> init() async {
    await _initLocalNotifications();

    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      return;
    }

    if (Platform.isIOS) {
      await Future.delayed(const Duration(milliseconds: 500));
      token = await FirebaseMessaging.instance.getAPNSToken();
    } else {
      token = await FirebaseMessaging.instance.getToken();

      await FirebaseMessaging.instance.subscribeToTopic("fcm_fallback");
    }

    _listenFCM();
  }

  Future<void> _initLocalNotifications() async {
    var androidSettings = const AndroidInitializationSettings(
      '@drawable/logo_named',
    );
    var iosSettings = const DarwinInitializationSettings();
    var initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationSelected,
    );

    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  int parseMessageId(String? id) {
    if (id == null || id.isEmpty) {
      return DateTime.now().millisecondsSinceEpoch ~/ 1000;
    }

    final numeric = id.replaceAll(RegExp(r'[^0-9]'), '');
    if (numeric.isEmpty) {
      return DateTime.now().millisecondsSinceEpoch ~/ 1000;
    }

    String lastDigits =
        numeric.length > 6 ? numeric.substring(numeric.length - 6) : numeric;

    return int.parse(lastDigits);
  }

  void _listenFCM() {
    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
     

      if (message.notification != null &&
          !inChat &&
          idChat.toString() != message.data['projectId'].toString()) {
        _showNotification(
          messageId: parseMessageId(message.messageId),
          title: message.notification!.title,
          body: message.notification!.body,
          payload: jsonEncode(message.data),
        );
      }
      if (message.data.isNotEmpty) {
        _handleSilent(message.data);
      }
    });

    // Background / app opened via notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
       if (message.notification != null) {
        _showNotification(
          messageId: parseMessageId(message.messageId),
          title: message.notification!.title,
          body: message.notification!.body,
          payload: jsonEncode(message.data),
        );
      }
      _onNotificationSelected(
        NotificationResponse(
          notificationResponseType:
              NotificationResponseType.selectedNotification,
          payload: jsonEncode(message.data),
        ),
      );
    });
  }

  Future<void> _showNotification({
    required int messageId,
    String? title,
    String? body,
    required String payload,
  }) async {
    var androidDetails = AndroidNotificationDetails(
      _channelId,
      "Meiskan Channel",
      channelDescription: "Default channel for notifications",
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@drawable/logo_named',
    );

    var iosDetails = const DarwinNotificationDetails(presentSound: true);

    var details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.show(
      messageId,
      title,
      body,
      details,
      payload: payload,
    );
  }

  void _onNotificationSelected(NotificationResponse response) {
    if (response.payload == null) return;

    Map<String, dynamic> data = jsonDecode(response.payload!);

    // Example: handle routing by notification type
    String type = data['notification_type_id'].toString();
    log("Notification Type: $type");

    switch (type) {
      case "1":
        // Navigate to Auction Win Page

        break;
      case "30":
        // Silent / custom handling
        break;
      default:
        // Default action
        break;
    }
  }

  void _handleSilent(Map<String, dynamic> data) {
    String type = data['type'].toString();
    

    if (type == "Offer") {
      counters?.incrementNotifications();
    } else if (type == "Message") {
      counters?.incrementMessages();

      if (Get.isRegistered<ConversationsController>()) {
        Get.find<ConversationsController>().fetch(refresh: true);
      }
    }
    log("Silent Notification: ${jsonEncode(data)}");
  }

  // Optional: background handler
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();
    print("Background message received: ${message.messageId}");
  }
}
