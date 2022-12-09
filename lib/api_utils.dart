import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

Future<bool> doLogin(String email, String password) async {

  try {
    Response response = await post(
        Uri.parse('https://http://172.19.161.41:5000/api/login'),
        body: {
          'email' : email,
          'password' : password
        }
    );

    if(response.statusCode == 200){
      var data = jsonDecode(response.body.toString());
      print(data['token']);
      return true;
    }else {
      print('failed');
      return false;
    }
  } on Exception catch (e) {
    print(e);
    return false;
  }

}