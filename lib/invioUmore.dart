
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'api_utils.dart';

class InvioUmore extends StatefulWidget{

  final String filePath;

  const InvioUmore({ Key? key, required this.filePath}) : super(key: key);
  @override
  _InvioUmoreState createState() => _InvioUmoreState();
}

class _InvioUmoreState extends State<InvioUmore>{

  late String emojiSelezionata;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 214, 255, 1),
      body:Padding(
        padding: EdgeInsets.only(bottom: 50, top: 50),
        child: Container(
          alignment: Alignment.center,
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
              /* Container(
              child: const Text('Ci siamo quasi', style:
                TextStyle(
                  fontSize: 30,
                  fontWeight:FontWeight.bold,
                ),),
            ),
            Container(
              child: const Text('Ora seleziona il tuo umore', style:
              TextStyle(
                fontSize: 20,
                fontWeight:FontWeight.normal,
              ),
              ),
              margin: EdgeInsetsDirectional.only(bottom: 20),
            ),*/
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: () {} , icon: Image(image: AssetImage('assets/images/emoji1.png')),
                    iconSize: 100,
                    splashColor: Colors.amberAccent, ),
                  IconButton(onPressed: () {} , icon: Image(image: AssetImage('assets/images/emoji2.png')),
                    iconSize: 100,
                    splashColor: Colors.amberAccent, ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: () {} , icon: Image(image: AssetImage('assets/images/emoji3.png')),
                    iconSize: 100,
                    splashColor: Colors.amberAccent, ),
                  IconButton(onPressed: () {} , icon: Image(image: AssetImage('assets/images/emoji4.png')),
                    iconSize: 100,
                    splashColor: Colors.amberAccent, ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: () {} , icon: Image(image: AssetImage('assets/images/disgusto.png')),
                    iconSize: 100,
                    splashColor: Colors.amberAccent, ),
                  IconButton(onPressed: () {} , icon: Image(image: AssetImage('assets/images/felice.png')),
                    iconSize: 100,
                    splashColor: Colors.amberAccent, ),
                ],
              ),
              IconButton(onPressed: () {} , icon: Image(image: AssetImage('assets/images/sorpresa.png')),
                iconSize: 100,
                splashColor: Colors.amberAccent, ),

              Padding(padding: EdgeInsets.only(top: 50),
              child: ElevatedButton(
                onPressed: () {
                  uploadVideo(widget.filePath, emojiSelezionata).then((value) {
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
                  minimumSize: const Size(200, 60),
                  backgroundColor:  Colors.orange,
                ),
                child: const Text('Esci',
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
      )

    );
    throw UnimplementedError();
  }

}



