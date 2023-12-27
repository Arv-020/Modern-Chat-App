import 'package:chat_app/main.dart';
import 'package:chat_app/models/notification_model.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/notification_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer' as console show log;

import 'package:flutter/material.dart';
class NotificationService {
    final _fireBaseMessaging = FirebaseMessaging.instance;
 
Future<void>  handleMessage(RemoteMessage? message) async{
  if(message==null) return;

  
  var messageData = NotificationData.fromMap(message.data);
  navigatorKey.currentState?.push(MaterialPageRoute(builder: (context)=>
  ChatScreen(recieverId: messageData.recieverId, recieverUserName: messageData.recieverUserName, token: messageData.token) ));  

}  


Future<void> initPushNotification() async{
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true
  );
  
  
  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  FirebaseMessaging.onBackgroundMessage(handleMessage);
}

    
    
Future<void> initNotifications() async{
     await _fireBaseMessaging.requestPermission();
     var fcmToken =await _fireBaseMessaging.getToken();  
     console.log(fcmToken.toString());
     initPushNotification();
    }



 }