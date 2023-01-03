import 'package:flutter/material.dart';

class RegistraVideo extends StatelessWidget {
  const RegistraVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(239, 232, 204, 1),
        body: Center(
          heightFactor: 2.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/illustrazione1.png', width: 237),
              const Text('Come ti senti oggi?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_circle_right_outlined, size: 82),
              )
            ],
          ),
        ));

    throw UnimplementedError();
  }
}
