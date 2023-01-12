import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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