import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wakeapp/recordVideoAndSend.dart';

class RegistraVideo extends StatelessWidget {
  const RegistraVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(239, 232, 204, 1),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 50),
              child: Image.asset('assets/images/illustrazione1.png', width: 237),

            ),
            Container(
              padding: EdgeInsets.only(bottom: 50),
              child: const Text('Come ti senti oggi?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)
              ),

            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => CameraPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize: const Size(150, 40),
                      backgroundColor: const Color.fromRGBO(81, 48, 14, 1),
                    ),
                    child: const Text('Avanti',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                  ),
                  )
                ],
              )
            ),

          ],
        ),
      ),
    );

    throw UnimplementedError();
  }
}
