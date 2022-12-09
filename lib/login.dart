import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakeapp/home.dart';
import 'package:wakeapp/api_utils.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();

}

class _LoginState extends State<Login> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(255, 233, 154, 1),
      systemNavigationBarColor: Color.fromRGBO(255, 233, 154, 1),
      systemNavigationBarDividerColor: Color.fromRGBO(255, 233, 154, 1),
    ));
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 233, 154, 1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              heightFactor: 4,
              child: Image.asset('assets/images/logo.png'),
            ),
            Container(
              margin: const EdgeInsets.only(left: 35, right: 35),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Color.fromRGBO(81, 48, 14, 1)),
                    decoration: InputDecoration(
                        fillColor: const Color.fromRGBO(255, 251, 236, 1),
                        filled: true,
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none
                        )
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: _passwordController,
                    style: const TextStyle(color: Color.fromRGBO(81, 48, 14, 1)),
                    obscureText: true,
                    decoration: InputDecoration(
                        fillColor: const Color.fromRGBO(255, 251, 236, 1),
                        filled: true,
                        hintText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none
                        )),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      var email = _emailController.text;
                      var password = _passwordController.text;
                      doLogin(email, password).then((value) {
                        if (value) {
                          //success
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Home()),
                          );
                        } else {
                          showDialog(context: context, builder: (context) => AlertDialog(
                            title: Text("Error"),
                          ));
                        }
                      });
                    },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: const Size(150, 40),
                        backgroundColor: const Color.fromRGBO(81, 48, 14, 1),
                      ),
                      child: const Text('Accedi',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 23,
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                        },
                        child: const Text(
                          'Password dimenticata',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Color.fromRGBO(81, 48, 14, 1),
                            fontSize: 15,
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      );
  }

}
