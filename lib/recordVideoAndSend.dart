import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_camera/flutter_camera.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  RecordVideoAndSend createState() => RecordVideoAndSend();
}

class RecordVideoAndSend extends State<CameraPage> {
  @override
  Widget build(BuildContext context) {
    return FlutterCamera(
      color: Colors.amber,

      onImageCaptured: (value) {
      },
      onVideoRecorded: (value) {
      },
    );
    // return Container();
  }
}