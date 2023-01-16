
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wakeapp/camera_page.dart';
import 'package:wakeapp/home.dart';

class EndPage extends StatefulWidget{
  @override
  const EndPage({ Key? key}) : super(key: key);
  _EndPageState createState() => _EndPageState();
}

class _EndPageState extends State<EndPage>{

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
              children:  [
                Padding(padding: EdgeInsets.only(bottom: 150),
                  child: Image(
                    width: 323,
                    image: AssetImage('assets/images/end.png'),
                  ),
                ),

                ElevatedButton(
                  onPressed:() {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
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
                ),
              ],
            ),
          ),
        )

    );
    throw UnimplementedError();
  }

}