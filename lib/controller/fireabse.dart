// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingInitializer extends StatefulWidget {
  const FirebaseMessagingInitializer({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FirebaseMessagingInitializerState createState() =>
      _FirebaseMessagingInitializerState();
}

class _FirebaseMessagingInitializerState
    extends State<FirebaseMessagingInitializer> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initFirebaseMessaging();
  }

  void _initFirebaseMessaging() async {
    try {
      await _firebaseMessaging.requestPermission();
      _firebaseMessaging.getToken().then((token) {
        if (token != null) {
          print("FCM Token: $token"); // Print the token to the debug console
        } else {
          print("Unable to get FCM token");
        }
      });

      FirebaseMessaging.onMessage.listen((message) async {
        if (Platform.isAndroid) {
          _initLocalNotifications();
          _showNotification(message);
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) async {
        // Handle tap on notification when app is in background or terminated
        _handleMessage(message);
      });
    } catch (e) {
      print("Error initializing Firebase Messaging: $e");
    }
  }

  void _initLocalNotifications() async {
    var androidInitializationSettings = const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  void _showNotification(RemoteMessage message) async {
    var androidNotificationDetails = const AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title!,
      message.notification!.body!,
      platformChannelSpecifics,
    );
  }

  void _handleMessage(RemoteMessage message) {
    // Handle message data
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // This widget does not have any UI, it's just for initialization
  }
}
