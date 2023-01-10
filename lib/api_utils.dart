import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

Future<bool> doLogin(String email, String password) async {
  try {
    Map data = {
      'email' : email,
      'password' : password
    };
    var body = jsonEncode(data);

    //URL da cambiare ogni volta
    String url = "https://4f601d1f972432.lhr.life/api/auth/login";

    Response response = await post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body
    );

    print(response.body);
    print(response.statusCode);
    
    if(response.statusCode == 201){
      var data = jsonDecode(response.body.toString());
      return true;
    } else {
      return false;
    }
  } on Exception catch (e) {
    print(e);
    return false;
  }
}