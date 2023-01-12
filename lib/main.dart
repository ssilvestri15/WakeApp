import 'package:flutter/material.dart';
import 'package:wakeapp/audio_page.dart';
import 'package:wakeapp/camera_page.dart';
import 'package:wakeapp/end_page.dart';
import 'package:wakeapp/home.dart';
import 'package:wakeapp/invioUmore.dart';
import 'package:wakeapp/notifica_page.dart';
import 'login.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: const Color.fromRGBO(81, 48, 14, 1),
    ),
    home: const Home(),
    routes: {
      'login': (context) => const Login(),
    },
  ));

}
