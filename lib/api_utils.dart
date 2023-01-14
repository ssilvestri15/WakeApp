import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> doLogin(String email, String password) async {
  try {
    Map data = {
      'email': email,
      'password': password
    };
    var body = jsonEncode(data);

    //URL da cambiare ogni volta
    String url = "https://ac2a34ce064144.lhr.life/api/auth/login";

    Response response = await post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body
    );

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 201) {
      var data = jsonDecode(response.body.toString());
      print(data['token']);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('token', data['token']);
      return true;
    } else {
      print('failed');
      return false;
    }
  } on Exception catch (e) {
    print(e);
    return false;
  }

}

Future<bool> uploadVideo(String filePath) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.getString('token');

  token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTY3MTIwODA5NSwianRpIjoiYmE4NDVkNTAtZGE5Ni00N2Q4LWE1NmItNTY0MjkxZGYxNDVhIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6InRlc3QxQGdtYWlsLmNvbSIsIm5iZiI6MTY3MTIwODA5NX0.ZDfA5LfmvtmoigWz4Fqww3yKlhkJKbcHysi7intLwKo';

  Map<String, String> headers = {
    "Content-Type": "application/json",
    'Authorization': 'Bearer $token'
  };

  String url = "https://4d3a52fff1bfe1.lhr.life/api/video";

  File videoFile = File(filePath);
  var request = MultipartRequest(
      "POST", Uri.parse(url));
  request.files.add(MultipartFile.fromBytes('file', videoFile.readAsBytesSync(), filename: 'video.mp4')); // TODO: change name
  request.headers.addAll(headers);

  var response = await request.send();

  print(response.statusCode);
  print(await response.stream.bytesToString());

  return response.statusCode == 201;

}

