import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'video_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);
  @override
  _CameraPageState createState() => _CameraPageState();
}
class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front); //prendiamo la camera frontale
    _cameraController = CameraController(front, ResolutionPreset.medium);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo() async{
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoPage(filePath: file.path),
      );
      print(file.path + "*******************************************"); //path del file da caricare su server

      Navigator.push(context, route);
    } else {
      recordTime();
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  String recordingTime = '00:00'; // to store value

  void recordTime() {
    var startTime = DateTime.now();
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      var diff = DateTime.now().difference(startTime);

      if (!_isRecording) {
        t.cancel();
      }
      setState(() {
        recordingTime =
        '${diff.inHours == 0 ? '' : '${diff.inHours.toString().padLeft(2,
            "0")}:'}${(diff.inMinutes % 60).floor().toString().padLeft(2,
            "0")}:${(diff.inSeconds % 60).floor().toString().padLeft(2, '0')}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Container(
        color: Color.fromRGBO(255, 222, 232, 1),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 150,
                      child: Text('È il momento di raccontare',
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight:FontWeight.bold,
                          decoration: TextDecoration.none,
                          color: Color.fromRGBO(81, 48, 14, 1),
                        ),
                      ),
                    ),
                    Image(
                      width: 150,
                      image: AssetImage('assets/images/racconta.png'),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 70, right: 70),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CameraPreview(_cameraController),
                  ),
                ),
                Text(recordingTime,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight:FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: Color.fromRGBO(81, 48, 14, 1),
                  ),
                ),
                FloatingActionButton.large(
                  backgroundColor: Color.fromRGBO(235, 155, 121, 1),
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.circle,
                    size: 60,
                    color: Color.fromRGBO(239, 222, 204, 1),
                  ),
                  onPressed: () => _recordVideo(),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
