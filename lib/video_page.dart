import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wakeapp/invioUmore.dart';
import 'package:wakeapp/api_utils.dart';

class VideoPage extends StatefulWidget {
  final String filePath;

  const VideoPage({Key? key, required this.filePath}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initVideoPlayer(),
        builder: (context, state) {
          if (state.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator());
          } else {
            return Container(
              color: Color.fromRGBO(255, 222, 232, 1),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 50),
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
                            child: Text('Vuoi inviare il video?',
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
                      Container(
                       height: 415.2,
                        width: 311.4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: VideoPlayer(_videoPlayerController),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              minimumSize: const Size(150, 40),
                              backgroundColor: const Color.fromRGBO(81, 48, 14, 1),
                            ),
                            child: const Text('Annulla',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 23,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              uploadVideo(widget.filePath).then((value) {
                                if (value) {
                                  //success
                                  showDialog(context: context, builder: (context) => const AlertDialog(
                                    title: Text("Video caricato correttamente"),
                                  ));
                                } else {
                                  showDialog(context: context, builder: (context) => const AlertDialog(
                                    title: Text("Error"),
                                  ));
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              minimumSize: const Size(150, 40),
                              backgroundColor: const Color.fromRGBO(81, 48, 14, 1),
                            ),
                            child: const Text('Invia',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 23,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

