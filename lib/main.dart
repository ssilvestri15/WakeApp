import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: const Color.fromRGBO(81, 48, 14, 1),
    ),
    home: const Login(),
    routes: {
      'login': (context) => const Login(),
    },
  ));

}
