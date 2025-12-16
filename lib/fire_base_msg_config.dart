import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class FireBaseMsgConfig{
  configure() async{
    // You may set the permission requests to "provisional" which allows the user to choose what type
   // of notifications they would like to receive once the user receives a notification.
    final notificationSettings = await FirebaseMessaging.instance.requestPermission(provisional: true);


    if(notificationSettings.authorizationStatus == AuthorizationStatus.authorized){
      log("User granted permission : ${notificationSettings.authorizationStatus}");

      FirebaseMessaging.instance.getToken().then((value) => log("token:$value"));

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log('Got a message whilst in the foreground!');
        log('Message data: ${message.data}');

        if (message.notification != null) {
          log('Message also contained a notification: ${message.notification}');
        }
      });

    }
  }
}