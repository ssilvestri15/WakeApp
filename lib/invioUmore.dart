
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InvioUmore extends StatefulWidget{
  const InvioUmore({ Key? key}) : super(key: key);
  @override
  _InvioUmoreState createState() => _InvioUmoreState();
}

class _InvioUmoreState extends State<InvioUmore>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 214, 255, 1),
      body:

      Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: const [
                Text('Ci siamo quasi', style:
                TextStyle(
                  fontSize: 30,
                  fontWeight:FontWeight.bold,
                ),),
              ],
            ),
            Row(

              children: const [
                Text('Ora seleziona il tuo umore', style:

                TextStyle(
                    fontSize: 20,
                    fontWeight:FontWeight.normal,
                ),),
              ],
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
            InkWell(
              splashColor: Colors.deepOrange,
              onTap: () {},
              child: Ink.image(image: AssetImage('assets/images/emoji1.png'),
              height: 150,
              width: 150,
              ),
            ),
            InkWell(
              splashColor: Colors.deepOrange,
              onTap: () {},
              child: Ink.image(image: AssetImage('assets/images/emoji2.png'),
                height: 150,
                width: 150,
              ),
            ),
            InkWell(
              splashColor: Colors.deepOrange,
              onTap: () {},
              child: Ink.image(image: AssetImage('assets/images/emoji3.png'),
                height: 150,
                width: 150,
              ),
            ),
            InkWell(
              splashColor: Colors.deepOrange,
              onTap: () {},
              child: Ink.image(image: AssetImage('assets/images/emoji4.png'),
                height: 150,
                width: 150,
              ),
            )
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }

}



