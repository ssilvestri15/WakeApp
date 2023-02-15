
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_utils.dart';
import 'end_page.dart';

class InvioUmore extends StatefulWidget{

  final String filePath;
  final bool isFromVideo;
  const InvioUmore({ Key? key, required this.filePath, required this.isFromVideo}) : super(key: key);
  @override
  _InvioUmoreState createState() => _InvioUmoreState();
}

class _InvioUmoreState extends State<InvioUmore>{

  String emojiSelezionata = "null";
  bool isSending = false;
  Color _favIconColor1 = Color.fromRGBO(226, 214, 255, 1);
  Color _favIconColor2 = Color.fromRGBO(226, 214, 255, 1);
  Color _favIconColor3 = Color.fromRGBO(226, 214, 255, 1);
  Color _favIconColor4 = Color.fromRGBO(226, 214, 255, 1);
  Color _favIconColor5 = Color.fromRGBO(226, 214, 255, 1);
  Color _favIconColor6 = Color.fromRGBO(226, 214, 255, 1);
  Color _favIconColor7 = Color.fromRGBO(226, 214, 255, 1);

  void removeAudioNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('audioBackgroundNotification');
  }

  void removeVideoNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('videoBackgroundNotification');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 214, 255, 1),
      body:Padding(
        padding: const EdgeInsets.only(bottom: 30, top: 30),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: !isSending,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Row(
                          children: const [
                            Text('Ci siamo quasi', style:
                            TextStyle(
                              fontSize: 30,
                              fontWeight:FontWeight.bold,
                            ),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30,bottom: 50),
                        child:Row(
                          children: const [
                            Text('Ora seleziona il tuo umore', style:
                            TextStyle(
                              fontSize: 20,
                              fontWeight:FontWeight.normal,
                            ),),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: (){
                              emojiSelezionata = Emozioni.arrabbiato;
                              setState(() {
                                _favIconColor2 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor3 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor4 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor5 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor6 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor7 = const Color.fromRGBO(226, 214, 255, 1);
                                if(_favIconColor1 == const Color.fromRGBO(226, 214, 255, 1)) {
                                  _favIconColor1 = Colors.orange;
                                } else {
                                  _favIconColor1 = const Color.fromRGBO(226, 214, 255, 1);
                                }

                              });

                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: _favIconColor1,
                              fixedSize: const Size(130,130),
                              elevation: 0,
                            ),
                            child: const Image(image: AssetImage('assets/images/emoji1.png')),
                          ),
                          ElevatedButton(
                            onPressed: (){
                              emojiSelezionata = Emozioni.triste;
                              setState(() {
                                _favIconColor1 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor3 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor4 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor5 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor6 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor7 = const Color.fromRGBO(226, 214, 255, 1);
                                if(_favIconColor2 == const Color.fromRGBO(226, 214, 255, 1)) {
                                  _favIconColor2 = Colors.orange;
                                } else {
                                  _favIconColor2 = const Color.fromRGBO(226, 214, 255, 1);
                                }
                              });

                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: _favIconColor2,
                              fixedSize: const Size(130,130),
                              elevation: 0,
                            ),
                            child: const Image(image: AssetImage('assets/images/emoji2.png')),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: (){
                              emojiSelezionata = Emozioni.neutrale;
                              setState(() {
                                _favIconColor1 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor2 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor4 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor5 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor6 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor7 = const Color.fromRGBO(226, 214, 255, 1);
                                if(_favIconColor3 == const Color.fromRGBO(226, 214, 255, 1)) {
                                  _favIconColor3 = Colors.orange;
                                } else {
                                  _favIconColor3 = const Color.fromRGBO(226, 214, 255, 1);
                                }
                              });

                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: _favIconColor3,
                              fixedSize: const Size(130,130),
                              elevation: 0,
                            ),
                            child: const Image(image: AssetImage('assets/images/emoji3.png')),
                          ),
                          ElevatedButton(
                            onPressed: (){
                              _favIconColor1 = const Color.fromRGBO(226, 214, 255, 1);
                              _favIconColor2 = const Color.fromRGBO(226, 214, 255, 1);
                              _favIconColor3 = const Color.fromRGBO(226, 214, 255, 1);
                              _favIconColor5 = const Color.fromRGBO(226, 214, 255, 1);
                              _favIconColor6 = const Color.fromRGBO(226, 214, 255, 1);
                              _favIconColor7 = const Color.fromRGBO(226, 214, 255, 1);
                              emojiSelezionata = Emozioni.felice;
                              setState(() {
                                if(_favIconColor4 == const Color.fromRGBO(226, 214, 255, 1)) {
                                  _favIconColor4 = Colors.orange;
                                } else {
                                  _favIconColor4 = const Color.fromRGBO(226, 214, 255, 1);
                                }
                              });

                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: _favIconColor4,
                              fixedSize: const Size(130,130),
                              elevation: 0,
                            ),
                            child: const Image(image: AssetImage('assets/images/emoji4.png')),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: (){
                              emojiSelezionata = Emozioni.disgustato;
                              setState(() {
                                _favIconColor1 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor2 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor3 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor4 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor6 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor7 = const Color.fromRGBO(226, 214, 255, 1);
                                if(_favIconColor5 == const Color.fromRGBO(226, 214, 255, 1)) {
                                  _favIconColor5 = Colors.orange;
                                } else {
                                  _favIconColor5 = const Color.fromRGBO(226, 214, 255, 1);
                                }
                              });

                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: _favIconColor5,
                              fixedSize: const Size(130,130),
                              elevation: 0,
                            ),
                            child: const Image(image: AssetImage('assets/images/disgusto.png')),
                          ),
                          ElevatedButton(
                            onPressed: (){
                              emojiSelezionata = Emozioni.impaurito;
                              setState(() {
                                _favIconColor1 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor2 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor3 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor4 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor5 = const Color.fromRGBO(226, 214, 255, 1);
                                _favIconColor7 = const Color.fromRGBO(226, 214, 255, 1);
                                if(_favIconColor6 == const Color.fromRGBO(226, 214, 255, 1)) {
                                  _favIconColor6 = Colors.orange;
                                } else {
                                  _favIconColor6 = const Color.fromRGBO(226, 214, 255, 1);
                                }
                              });

                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: _favIconColor6,
                              fixedSize: const Size(130,130),
                              elevation: 0,
                            ),
                            child: const Image(image: AssetImage('assets/images/impaurito.png')),
                          ),
                        ],
                      ),
                      ElevatedButton(
                          onPressed: (){
                            emojiSelezionata = Emozioni.sorpreso;
                            setState(() {
                              _favIconColor1 = const Color.fromRGBO(226, 214, 255, 1);
                              _favIconColor2 = const Color.fromRGBO(226, 214, 255, 1);
                              _favIconColor3 = const Color.fromRGBO(226, 214, 255, 1);
                              _favIconColor4 = const Color.fromRGBO(226, 214, 255, 1);
                              _favIconColor5 = const Color.fromRGBO(226, 214, 255, 1);
                              _favIconColor6 = const Color.fromRGBO(226, 214, 255, 1);
                              if(_favIconColor7 == const Color.fromRGBO(226, 214, 255, 1)) {
                                _favIconColor7 = Colors.orange;
                              } else {
                                _favIconColor7 = const Color.fromRGBO(226, 214, 255, 1);
                              }
                            });

                          },
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: _favIconColor7,
                              fixedSize: const Size(130,130),
                              elevation: 0,
                          ),
                          child: const Image(image: AssetImage('assets/images/sorpresa.png')),
                      ),

                      Padding(padding: EdgeInsets.only(top: 50),
                        child: ElevatedButton(
                          onPressed: () {

                            if (emojiSelezionata == "null") {
                              showDialog(context: context, builder: (context) => const AlertDialog(
                                title: Text("Attenzione, seleziona una emoji!"),
                              ));
                              return;
                            }

                            setState(() {
                              isSending = true;
                            });
                            print(widget.isFromVideo);
                            if(widget.isFromVideo){
                              uploadVideo(widget.filePath, emojiSelezionata).then((statusCode) {
                                switch(statusCode) {
                                  case 201: case 200:
                                  //success
                                    removeVideoNotification();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => EndPage())
                                    );
                                    break;

                                  case 420:
                                    //no face
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Attenzione! Viso nel video non rilevato! Riprova per favore.'),
                                          actions: [
                                            TextButton(
                                              child: Text('OK'),
                                              onPressed: () async {
                                                // do something with the input text
                                                setState(() {
                                                  isSending = false;
                                                });
                                                // navigate to a new page and remove all other pages from the stack
                                                Navigator.pushNamedAndRemoveUntil(context, 'notificaVideo', (route) => false);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    break;

                                  default:
                                    //error
                                    setState(() {
                                      isSending = false;
                                    });
                                    showDialog(context: context, builder: (context) => const AlertDialog(
                                      title: Text("Error"),
                                    ));
                                }
                              });
                            } else {
                              uploadAudio(widget.filePath, emojiSelezionata).then((value) {
                                if (value) {
                                  //success
                                  removeAudioNotification();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => EndPage())
                                  );
                                } else {
                                  setState(() {
                                    isSending = false;
                                  });
                                  showDialog(context: context, builder: (context) => const AlertDialog(
                                    title: Text("Error"),
                                  ));
                                }
                              });
                            }
                            print(widget.filePath + '********************' + emojiSelezionata );

                          },
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            minimumSize: const Size(200, 60),
                            backgroundColor:  Colors.orange,
                          ),
                          child: const Text('Invia',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 23,
                            ),
                          ),
                        ),)

                    ],
                  ),
                ),
              ),
              Visibility(
                visible: isSending,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 4,
                  )
              )
            ],
          )
        ),
      )

    );
    throw UnimplementedError();
  }

}



