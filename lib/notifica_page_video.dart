
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wakeapp/camera_page.dart';

class NotificaPage extends StatefulWidget{
  @override
  const NotificaPage({ Key? key}) : super(key: key);
  _NotificaPageState createState() => _NotificaPageState();
}

class _NotificaPageState extends State<NotificaPage>{

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(255, 222, 232, 1),
      child: Center (
        child: Padding(
          padding: const EdgeInsets.only(top: 50, bottom: 50),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  [
              Image(
                width: 269,
                image: AssetImage('assets/images/pc.png'),
              ),
              SizedBox(
                width: 300,
                child: Text('Registra un breve video di due minuti. Quando sei pronto clicca su “Inizia”',
                  //overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:FontWeight.normal,
                    decoration: TextDecoration.none,
                    color: Color.fromRGBO(81, 48, 14, 1),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const CameraPage()));

                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  minimumSize: const Size(150, 40),
                  backgroundColor: const Color.fromRGBO(235, 189, 121, 1),
                ),
                child: const Text('Inizia',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 23,
                  ),
                ),
              ),
            ],
          ),
        ),
      )

    );
    throw UnimplementedError();
  }

}