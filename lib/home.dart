import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:wakeapp/camera_page.dart';
import 'package:wakeapp/invioUmore.dart';
import 'package:wakeapp/notifica_page_audio.dart';
import 'package:wakeapp/notifica_page_video.dart';

import 'audio_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    var title = message.notification?.title ?? '';
    if (title.contains('video')) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificaPage()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificaPageAudio()));
    }

  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 227, 192, 1),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: 50, top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
               Padding(
                  padding: EdgeInsets.only(bottom: 50),
                 child: Image(image: AssetImage('assets/images/gatto.png'), width: 243),
          ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text('Non è ancora il momento', style:
                TextStyle(
                  fontSize: 30,
                  fontWeight:FontWeight.normal,
                ),),
              ),
              Text('Rilassati e goditi la vita', style:
              TextStyle(
                fontSize: 20,
                fontWeight:FontWeight.normal,
              ),)
            ],
          ),
        )
      ),
    );
  }
}