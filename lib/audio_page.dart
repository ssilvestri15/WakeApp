import 'dart:convert';
import 'dart:math';
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
  String t1 = 'Il delitto passionale, il capitano Bellodi pensava, in Sicilia non scatta dalla vera e propria passione, dalla passione del cuore; ma da una specie di passione intellettuale, da una passione o preoccupazione di formalismo, come dire? giuridico: nel senso di quella astrazione in cui le leggi vanno assottigliandosi attraverso i gradi di giudizio del nostro ordinamento, fino a raggiungere quella trasparenza formale in cui il merito, cioè l’umano peso dei fatti, non conta più; e, abolita l’immagine dell’uomo, la legge nella legge si specchia. Quel personaggio di nome Ciampa, nel Berretto a sonagli di Pirandello: parlava come se nella sua bocca ci fosse la Cassazione a sezioni riunite, tanto accuratamente notomizzava e ricostituiva la forma senza sfiorare il merito.';
  String t2 = 'Quando la terra è d\'ombre ricoperta e soffia il vento, e in su l\'arene estreme l\'onda va e vienche mormorando geme e appar la luna tra le nubi incerta ....';
  String t3 = 'Il maestro Jedi Qui-Gon Jinn e il suo padawan Obi-Wan Kenobi vengono inviati sul pianeta Naboo per mediare una disputa tra la Repubblica Galattica e la corrotta Federazione dei Mercanti, alle dipendenze del Signore Oscuro dei Sith Darth Sidious. Dopo il fallimento della mediazione, incrociano un gungan di nome Jar Jar Binks e decidono di aiutare la regina Padmé Amidala a lasciare il pianeta per denunciare la crisi al Senato della Repubblica. A causa di un guasto all\'iperpropulsore, il gruppo deve atterrare sul pianeta desertico Tatooine, dove incontra Anakin Skywalker, uno schiavo di nove anni, che Qui-Gon crede essere il Prescelto, destinato a portare equilibrio nella Forza. Dopo aver riscattato la propria libertà in una gara di sgusci, Anakin lascia il pianeta insieme al gruppo, diretto verso la capitale della Repubblica, Coruscant. Tornati a Naboo, ormai teatro di battaglia tra la popolazione del pianeta e la Federazione, Qui-Gon viene ucciso nello scontro col Sith Darth Maul, che poco dopo viene sconfitto da Obi-Wan. Il padawan promette al maestro morente di addestrare Anakin affinché diventi un Jedi, nonostante il consiglio Jedi, guidato da Yoda, abbia delle riserve sul ragazzo. Pochi giorni dopo, Obi-Wan e Anakin vengono accolti come eroi su Naboo, onorati da Amidala e dal nuovo cancelliere della Repubblica, Palpatine.';
  String t4 = 'Uno dei temi più misteriosi del teatro tragico greco è la predestinazione dei figli a pagare le colpe dei padri. Non importa se i figli sono buoni, innocenti, pii: se i loro padri hanno peccato, essi devono essere puniti. È il coro – un coro democratico – che si dichiara depositario di tale verità: e la enuncia senza introdurla e senza illustrarla, tanto gli pare naturale. Confesso che questo tema del teatro greco io l’ho sempre accettato come qualcosa di estraneo al mio sapere, accaduto «altrove» e in un «altro tempo». Non senza una certa ingenuità scolastica, ho sempre considerato tale tema come assurdo e, a sua volta, ingenuo, «antropologicamente» ingenuo. Ma poi è arrivato il momento della mia vita in cui ho dovuto ammettere di appartenere senza scampo alla generazione dei padri. Senza scampo, perché i figli non solo sono nati, non solo sono cresciuti, ma sono giunti all’età della ragione e il loro destino, quindi, comincia a essere ineluttabilmente quello che deve essere, rendendoli adulti.';
  String t5 = 'Ma un giorno finalmente vennero a dirmi che mia moglie era stata assalita dalle doglie, e che corressi subito a casa. Scappai come un dàino: ma più per sfuggire a me stesso, per non rimanere neanche un minuto a tu per tu con me, a pensare che io stavo per avere un figliuolo, io, in quelle condizioni, un figliuolo! Appena arrivato alla porta di casa, mia suocera m’afferrò per le spalle e mi fece girar su me stesso: – Un medico! Scappa! Romilda muore! Viene da restare, no? a una siffatta notizia a bruciapelo. E invece, « Correte! ». Non mi sentivo più le gambe; non sapevo più da qual parte pigliare; e mentre correvo, non so come, – Un medico! un medico! – andavo dicendo; e la gente si fermava per via, e pretendeva che mi fermassi anch’io a spiegare che cosa mi fosse accaduto; mi sentivo tirar per le maniche, mi vedevo di fronte facce pallide, costernate; scansavo, scansavo tutti: – Un medico! un medico! E il medico intanto era la, già a casa mia. Quando trafelato, in uno stato miserando, dopo aver girato tutte le farmacie, rincasai, disperato e furibondo, la prima bambina era già nata; si stentava a far venir l’altra alla luce. – Due!';
  String t6 = 'La solitudine non è mai con voi; è sempre senza di voi, e soltanto possibile con un estraneo attorno: luogo o persona che sia, che del tutto vi ignorino, che del tutto voi ignoriate, così che la vostra volontà e il vostro sentimento restino sospesi e smarriti in un’incertezza angosciosa e, cessando ogni affermazione di voi, cessi l’intimità stessa della vostra coscienza. La vera solitudine è in un luogo che vive per sé e che per voi non ha traccia né voce, e dove dunque l’estraneo siete voi. Come sopportare in me quell’estraneo? Quest’estraneo che ero io stesso per me? Come non vederlo? Come non conoscerlo? Come restare per sempre condannato a portarmelo con me, in me, alla vista degli altri e fuori intanto della mia? Ci vorrebbe un po’ più d’intesa tra l’uomo e la natura. Troppo spesso la natura si diverte a buttare all’aria tutte le nostre ingegnose costruzioni. Cicloni, terremoti… Ma l’uomo non si dà per vinto. Ricostruisce, ricostruisce, bestiolina pervicace. E tutto è per lui materia di ricostruzione. Perché ha in sé quella tal cosa che non si sa che sia, per cui deve per forza costruire, trasformare a suo modo la materia che gli offre la natura ignara, forse e, almeno quando vuole, paziente. Ma si contentasse soltanto delle cose, di cui, fino a prova contraria, non si conosce che abbiano in sé facoltà di sentire lo strazio a causa dei nostri adattamenti e delle nostre costruzioni! Nossignori. L’uomo piglia a materia anche se stesso, e si costruisce, sissignori, come una casa. Voi credete di conoscervi se non vi costruite in qualche modo? E ch’io possa conoscervi, se non vi costruisco a modo mio? …perché una realtà non ci fu data e non c’è ma dobbiamo farcela noi, se vogliamo essere: e non sarà mai una per tutti, una per sempre, ma di continuo e infinitamente mutabile. La facoltà d’illuderci che la realtà d’oggi sia la sola vera, se da un canto ci sostiene, dall’altro ci precipita in un vuoto senza fine, perché la realtà d’oggi è destinata a scoprircisi illusione domani. E la vita non conclude. Non può concludere. Se domani conclude, è finita.';
  String t7 = 'Sempre caro mi fu quest’ermo colle,\nE questa siepe, che da tanta parte\nDell’ultimo orizzonte il guardo esclude.\nMa sedendo e mirando, interminatiSpazi di là da quella, e sovrumani\nSilenzi, e profondissima quiete\nIo nel pensier mi fingo; ove per poco\nIl cor non si spaura. E come il vento\nOdo stormir tra queste piante, io quello\nInfinito silenzio a questa voce\nVo comparando: e mi sovvien l’eterno,\nE le morte stagioni, e la presente\nE viva, e il suon di lei. Così tra questa\nImmensità s’annega il pensier mio:\nE il naufragar m’è dolce in questo mare.\n Giacomo Leopardi';
  String t8 = 'Forse perché della fatal quiete\ntu sei l’immago, a me si cara vieni,\no Sera! E quando ti corteggian liete\nle nubi estive e i zeffiri sereni,\ne quando dal nevoso aere inquiete\ntenebre e lunghe all’universo meni,\nsempre scendi invocata, e le secrete\nvie del mio cor soavemente tieni.\nVagar mi fai co’ miei pensier su l’orme\nche vanno al nulla eterno; e intanto fugge\nquesto reo tempo, e van con lui le torme\ndelle cure onde meco egli si strugge;\ne mentre guardo la tua pace, dorme\nquello spirto guerrier ch’entro mi rugge.\n Ugo Foscolo';
  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  var filePath;
  bool _isAvantiButtonVisible = false;
  List<String> testi = [];
  int random = -1;
  Random r = new Random();

  void showAvantiButton() {
    setState(() {
      _isAvantiButtonVisible = !_isAvantiButtonVisible;
    });
  }

  @override
  void initState() {
    testi.add(t1);
    testi.add(t2);
    testi.add(t3);
    testi.add(t4);
    testi.add(t5);
    testi.add(t6);
    testi.add(t7);
    testi.add(t8);
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
        filePath = value;
        _mplaybackReady = true;
        _isAvantiButtonVisible = true;
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
      setState(() {
      });
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
    if(random == -1) {
      random = r.nextInt(7);
    }
    Widget makeBody() {
      return
        Padding(
          padding: const EdgeInsets.only(top: 50, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                    width: 200,
                    image: AssetImage('assets/images/audio.png'),
                  )
                ],
              ),
              SizedBox(
                width: 350,
                height: 300,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(testi[random],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight:FontWeight.bold,
                      decoration: TextDecoration.none,
                      color: Color.fromRGBO(81, 48, 14, 1),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 30, bottom: 30),
                child: FloatingActionButton.large(
                  backgroundColor: const Color.fromRGBO(235, 155, 121, 1),
                  onPressed: getRecorderFn(),
                  child: Icon(
                    _mRecorder!.isRecording ? Icons.stop : Icons.mic,
                    size: 50,
                    color: const Color.fromRGBO(239, 222, 204, 1),
                  ),
                ),
              ),

              Visibility(
                  visible: _isAvantiButtonVisible,
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.only(right: 30),
                          child: ElevatedButton(
                            onPressed: getPlaybackFn(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(235, 155, 121, 1),
                              shape: const StadiumBorder(),
                              minimumSize: const Size(150, 40),
                            ),
                            //disabledColor: Colors.grey,
                            child: Text(_mPlayer!.isPlaying ? 'Stop' : 'Ascolta',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 23,
                              ),
                            ),
                          )
                      ),
                      ElevatedButton(
                        onPressed: (){
                          stopPlayer();
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => InvioUmore(filePath: filePath, isFromVideo:false))
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(235, 155, 121, 1),
                          shape: const StadiumBorder(),
                          minimumSize: const Size(150, 40),
                        ),
                        //disabledColor: Colors.grey,
                        child:  const Text('Avanti',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 23,
                          ),
                        ),
                      ),

                    ],
                  )
              ),

            ],
          ),
        );
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 222, 232, 1),

      body: makeBody(),
    );
  }


}



