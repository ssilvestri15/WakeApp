import 'dart:convert';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakeapp/invioUmore.dart';

typedef _Fn = void Function();

const theSource = 1;

class AudioPage extends StatefulWidget {

  const AudioPage({Key? key}) : super(key: key);
  @override
  _AudioPageState createState() => _AudioPageState();
}
class _AudioPageState extends State<AudioPage>{
  String testo = 'Naruto Uzumaki è un ninja dodicenne del Villaggio della Foglia con il sogno di diventare hokage, il ninja più importante del villaggio, allo scopo di essere accettato dagli altri. Naruto infatti ha passato l infanzia nell emarginazione e, durante lo scontro col ninja traditore Mizuki, ne scopre il motivo: dentro di lui è sigillata la Volpe a Nove Code, uno dei nove cercoteri, giganteschi demoni sovrannaturali. A seguito della promozione all accademia ninja Naruto entra a far parte, insieme a Sasuke Uchiha e Sakura Haruno, del gruppo 7, sotto la guida del maestro Kakashi Hatake. Dopo varie avventure, Sasuke decide di abbandonare il Villaggio della Foglia per allenarsi con Orochimaru, allo scopo di ottenere il potere necessario per uccidere il fratello Itachi e vendicare il suo clan, da lui apparentemente sterminato senza un chiaro movente';
  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  @override
  void initState() {
    _mPlayer!.openPlayer().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });

    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _mPlayer!.closePlayer();
    _mPlayer = null;

    _mRecorder!.closeRecorder();
    _mRecorder = null;
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openRecorder();
    if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _mPath = 'tau_file.webm';
      if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
        return;
      }
    }
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
      AVAudioSessionCategoryOptions.allowBluetooth |
      AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
      AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------

  void record() {
    _mRecorder!
        .startRecorder(
      toFile: _mPath,
      codec: _codec,
      //audioSource: ,
    )
        .then((value) {
      setState(() {});
    });
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      setState(() {
        //var url = value;
        _mplaybackReady = true;
      });
    });
  }

  void play() {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder!.isStopped &&
        _mPlayer!.isStopped);
    _mPlayer!
        .startPlayer(
        fromURI: _mPath,
        //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
        whenFinished: () {
          print(_mPath);
          setState(() {});
        })
        .then((value) {
      setState(() {});
    });
  }

  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      setState(() {});
    });
  }


  _Fn? getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer!.isStopped) {
      return null;
    }
    return _mRecorder!.isStopped ? record : stopRecorder;
  }

  _Fn? getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
      return null;
    }
    return _mPlayer!.isStopped ? play : stopPlayer;
  }

  @override
  Widget build(BuildContext context) {
    Widget makeBody() {
      return
        Padding(
          padding: EdgeInsets.only(top: 50, bottom: 50),
        child:
          Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                /*SizedBox(           immagine gia con testo, per ora va bene
                width: 150,
                child: Text('È il momento della favola',
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: Color.fromRGBO(81, 48, 14, 1),
                  ),
                ),
              ),*/
                Image(
                  width: 240,
                  image: AssetImage('assets/images/audio.png'),
                )
              ],
            ),
            const SizedBox(
              width: 380,
              child: Text('Naruto Uzumaki è un ninja dodicenne del Villaggio della Foglia con il sogno di diventare hokage, il ninja più importante del villaggio, allo scopo di essere accettato dagli altri. Naruto infatti ha passato l infanzia nell emarginazione e, durante lo scontro col ninja traditore Mizuki, ne scopre il motivo: dentro di lui è sigillata la Volpe a Nove Code, uno dei nove cercoteri, giganteschi demoni sovrannaturali.',
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:FontWeight.bold,
                  decoration: TextDecoration.none,
                  color: Color.fromRGBO(81, 48, 14, 1),
                ),
              ),
            ),


            FloatingActionButton.large(
              backgroundColor: const Color.fromRGBO(235, 155, 121, 1),
              onPressed: getRecorderFn(),
              child: Icon(
                _mRecorder!.isRecording ? Icons.stop : Icons.mic,
                size: 70,
                color: const Color.fromRGBO(239, 222, 204, 1),
              ),
            ),
            ElevatedButton(
              onPressed: getPlaybackFn(),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(235, 155, 121, 1)
              ),
              //disabledColor: Colors.grey,
              child: Text(_mPlayer!.isPlaying ? 'Stop' : 'Ascolta di nuovo'),
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InvioUmore(filePath: _mPath))
                );
              },
              style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(235, 155, 121, 1)
              ),
              //disabledColor: Colors.grey,
              child: Text('Invia'),
            ),
          ],
        )
          ,);
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 222, 232, 1),

      body: makeBody(),
    );
  }
}



