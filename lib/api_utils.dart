import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

String URL = 'https://512d9102cfa78b.lhr.life';

Future<bool> doLogin(String email, String password) async {
  try {
    Map data = {
      'email': email,
      'password': password
    };
    var body = jsonEncode(data);

    String url = "$URL/api/auth/login";

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

Future<int> uploadVideo(String filePath, String emojiUser) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.getString('token');

  var newURL = pref.getString('URL');
  if(newURL != null){
    URL = newURL;
  }

  token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTY3NTM1NjE0MCwianRpIjoiZTg2ZmU1OTMtNGFhMy00YTBiLWE1YjItNWIxYTcwNWY0MGI1IiwidHlwZSI6ImFjY2VzcyIsInN1YiI6Im1hdXJvLnZlcmRvbmVAZ21haWwuY29tIiwibmJmIjoxNjc1MzU2MTQwfQ.auis5YnIgdN42OzZp1P4Xzabbm2K8pRVLR6EO33yanQ';

  Map<String, String> headers = {
    "Content-Type": "application/json",
    'Authorization': 'Bearer $token'
  };

  String url = "$URL/api/video";

  File videoFile = File(filePath);
  var request = MultipartRequest(
      "POST", Uri.parse(url));
  request.files.add(MultipartFile.fromBytes('file', videoFile.readAsBytesSync(), filename: 'video.mp4')); // TODO: change name
  request.headers.addAll(headers);
  request.fields['json'] = '{"idTesto":1,"emojiUser": "$emojiUser" }';

  try {
    var response = await request.send();

    print(response.statusCode);
    print(await response.stream.bytesToString());

    return response.statusCode;
  } catch (e) {
    return 400;
  }

}

Future<bool> uploadAudio(String filePath, String emojiUser) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.getString('token');

  var newURL = pref.getString('URL');
  if(newURL != null){
    URL = newURL;
  }

  token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTY3NTM1NjE0MCwianRpIjoiZTg2ZmU1OTMtNGFhMy00YTBiLWE1YjItNWIxYTcwNWY0MGI1IiwidHlwZSI6ImFjY2VzcyIsInN1YiI6Im1hdXJvLnZlcmRvbmVAZ21haWwuY29tIiwibmJmIjoxNjc1MzU2MTQwfQ.auis5YnIgdN42OzZp1P4Xzabbm2K8pRVLR6EO33yanQ';

  Map<String, String> headers = {
    "Content-Type": "application/json",
    'Authorization': 'Bearer $token'
  };

  String url = "$URL/api/audio";

  File audioFile = File(filePath);
  var request = MultipartRequest(
      "POST", Uri.parse(url));
  request.files.add(MultipartFile.fromBytes('file', audioFile.readAsBytesSync(), filename: 'audio.mp4')); // TODO: change name
  request.headers.addAll(headers);
  request.fields['json'] = '{"idTesto":1,"emojiUser": "$emojiUser" }';

  try {
    var response = await request.send();

    print(response.statusCode);
    print(await response.stream.bytesToString());

    return response.statusCode == 201;
  } catch (e){
    return false;
  }

}

class Emozioni {
  static String felice = 'felice';
  static String triste = 'triste';
  static String arrabbiato = 'arrabbiato';
  static String disgustato = 'disgustato';
  static String sorpreso = 'sorpreso';
  static String neutrale = 'neutrale';
  static String impaurito = 'impaurito';
}