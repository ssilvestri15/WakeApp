import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  bool _isVideoNotificationSend = false;
  bool _isAudioNotificationSend = false;

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

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

  void checkVideoBackgroundNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dateString = prefs.getString('videoBackgroundNotification') ?? '';
    print('DATE VIDEO =============> ' + dateString);
    if (dateString == '') {
      return;
    }
    DateTime notificationDate = DateTime.parse(dateString);
    DateTime now = DateTime.now();
     setState(() {
       _isVideoNotificationSend = DateUtils.isSameDay(notificationDate, now);
       print(_isVideoNotificationSend);
     });

  }

  void checkAudioBackgroundNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dateString = prefs.getString('audioBackgroundNotification') ?? '';
    print('DATE Audio =============> ' + dateString);
    if (dateString == '') {
      return;
    }
    DateTime notificationDate = DateTime.parse(dateString);
    DateTime now = DateTime.now();
     setState(() {
       _isAudioNotificationSend = DateUtils.isSameDay(notificationDate, now);
       print(_isAudioNotificationSend);
     });
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
    checkAudioBackgroundNotification();
    checkVideoBackgroundNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(254, 227, 192, 1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50, top: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               const Padding(
                  padding: EdgeInsets.only(bottom: 50),
                 child: Image(image: AssetImage('assets/images/gatto.png'), width: 243),
               ),
              Visibility(
                visible: !_isVideoNotificationSend && !_isAudioNotificationSend,
                child: Column(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text('Non è ancora il momento', style:
                    TextStyle(
                      fontSize: 30,
                      fontWeight:FontWeight.w600,
                    ),),
                  ),
                  Text('Rilassati e attendi la notifica', style:
                  TextStyle(
                    fontSize: 20,
                    fontWeight:FontWeight.w500,
                  ),),
                ],
              ),
              ),
              Visibility(
                  visible: _isVideoNotificationSend,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Color.fromRGBO(248, 208, 156, 1),
                    child: SizedBox(
                      width: 300,
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Spacer(),
                          Icon(Icons.add_alert),
                          const Text('È il momento!',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight:FontWeight.normal,
                            ),),
                          Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificaPage()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(203, 80, 80, 1),
                              shape: const StadiumBorder(),
                              minimumSize: const Size(150, 40),
                            ),
                            //disabledColor: Colors.grey,
                            child: const Text('Registra il video',
                              style: TextStyle(
                                color: Color.fromRGBO(248, 208, 156, 1),
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      )
                    ),
                  ),
              ),
              Visibility(
                visible: _isAudioNotificationSend,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Color.fromRGBO(248, 208, 156, 1),
                  child: SizedBox(
                      width: 300,
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Spacer(),
                          Icon(Icons.add_alert),
                          const Text('È il momento!',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight:FontWeight.normal,
                            ),),
                          Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificaPageAudio()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(203, 80, 80, 1),
                              shape: const StadiumBorder(),
                              minimumSize: const Size(150, 40),
                            ),
                            //disabledColor: Colors.grey,
                            child: const Text('Registra l\'audio',
                              style: TextStyle(
                                color: Color.fromRGBO(248, 208, 156, 1),
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      )
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}