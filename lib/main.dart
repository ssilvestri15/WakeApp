import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakeapp/audio_page.dart';
import 'package:wakeapp/camera_page.dart';
import 'package:wakeapp/end_page.dart';
import 'package:wakeapp/home.dart';
import 'package:wakeapp/invioUmore.dart';
import 'package:wakeapp/notifica_page.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: const Color.fromRGBO(81, 48, 14, 1),
    ),
    home: const CameraPage(),
    routes: {
      'login': (context) => const Login(),
    },
  ));

}
