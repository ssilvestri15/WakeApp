
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakeapp/audio_page.dart';
import 'package:wakeapp/camera_page.dart';
import 'package:wakeapp/end_page.dart';
import 'package:wakeapp/home.dart';
import 'package:wakeapp/invioUmore.dart';
import 'package:wakeapp/notifica_page_audio.dart';
import 'package:wakeapp/notifica_page_video.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wakeapp/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message -> ${message.notification?.title}:${message.notification?.body}");

  saveNotificationDate(message);

}

void saveNotificationDate(RemoteMessage message) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String todayDate = DateTime.now().toString();
  var title = message.notification?.title ?? '';
  if (title.contains('video')) {
    prefs.setString('videoBackgroundNotification', todayDate);
  } else if (title.contains('audio')) {
    prefs.setString('audioBackgroundNotification', todayDate);
  }
}

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.subscribeToTopic('wakeapp');

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);



    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  String? token = prefs.getString('token');

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: const Color.fromRGBO(81, 48, 14, 1),
      fontFamily: 'Montserrat'
    ),
    home: const NotificaPageAudio(),
    routes: {
      'login': (context) => const Login(),
      'notificaVideo': (context) => NotificaPage(),
    },
  ));



}
