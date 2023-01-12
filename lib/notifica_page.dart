
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Image(
                width: 269,
                image: AssetImage('assets/images/pc.png'),
              ),
              SizedBox(
                width: 300,
                child: Text('ciao come stap',
                  //overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:FontWeight.normal,
                    decoration: TextDecoration.none,
                    color: Color.fromRGBO(81, 48, 14, 1),
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