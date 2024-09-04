import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> initializeService() async {
  var service = FlutterBackgroundService();

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // const notiChannel = AndroidNotificationChannel('channelID', "AndChannel",
  //     importance: Importance.high);
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(notiChannel);

  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      notificationChannelId: "channelID",
      foregroundServiceNotificationId: 100,
      initialNotificationTitle: 'Preparing ...',
      initialNotificationContent: 'Background Service',
    ),
  );
  service.startService();
}

@pragma('vm:entry-point')
onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();

  service.on('setAsForeground').listen((event) {
    log("Foreground Service Started ...");
  });

  service.on('setAsBackground').listen((event) {
    log("Background Service Started ...");
  });

  service.on('stopService').listen((event) {
    service.stopSelf();
    log("Service Stopped ...");
  });

  Timer.periodic(Duration(seconds: 1), (timer) {
    log("${DateTime.now()}");
  });
}
