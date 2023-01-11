import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import 'package:file/file.dart';

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
      print(data['token']);
      return true;
    } else {
      print('failed');
      return false;
    }
  } on Exception catch (e) {
    print(e);
    return false;
  }

  Future<int> uploadVideo(File videoFile) async {
    var token = ""; //TODO: get token from stored data

    Map<String, String> headers = {
    "Content-Type": "application/json",
    'Authorization': 'Bearer $token'
    };

    String url = ""; // TODO: change url

    var request = MultipartRequest(
        "POST", Uri.parse('your api url here'));
    request.files.add(MultipartFile.fromBytes('video', videoFile.readAsBytesSync(), filename: 'video'));

    var response = await request.send();

    return response.statusCode;

  }

  }
