import os
import models
import uuid
from sqlalchemy import select, insert, exc
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv
from flask import Flask, request, send_file
from flask_restful import Resource, Api
from flask_jwt_extended import JWTManager, create_access_token, decode_token
from flask_bcrypt import Bcrypt
from flask_uploads import UploadSet, configure_uploads
from utils import allowed_file_video, allowed_file_audio, validate_register_input, ALLOWED_EXTENSIONS_VIDEO, ALLOWED_EXTENSIONS_AUDIO, encrypt_file, decrypt_video, send_not
from cryptography.fernet import Fernet
import schedule
import time
import firebase_admin
from firebase_admin import credentials, messaging
import random
from threading import Thread
from speech_emotion_recognition import analyze
from video_emotion_recognition import analyzeVideoThreaded, checkFace
from convert_wavs import convert_audio
import json
from datetime import datetime

def scheduleTime(isVideo):
    minuteI = random.randint(0, 59)
    hourI = random.randint(9, 21)
    minute = f"0{minuteI}" if (minuteI <= 9) else f"{minuteI}"
    hour = f"0{hourI}" if (hourI <= 9) else f"{hourI}"
    timeFinal = f"{hour}:{minute}:00"
    print(f"Next notication at {timeFinal}")
    if isVideo:
        schedule.every().day.at(timeFinal).do(send_not, messaging, "È l'ora del video!","Registra un video e dicci come ti senti 📽️❤️")
    else:
        schedule.every().day.at(timeFinal).do(send_not, messaging, "È l'ora dell'audio!","Leggi un breve testo e dicci come ti senti 📖❤️")
    return schedule.CancelJob

def scheduleNotification():
    schedule.every().day.at("07:00").do(scheduleTime, True)
    schedule.every().day.at("07:01").do(scheduleTime, False)
    while 1:
        schedule.run_pending()
        time.sleep(1)

firebase_cred = credentials.Certificate("firebase.json")
firebase_app = firebase_admin.initialize_app(firebase_cred)

load_dotenv(".flaskenv")

_Session = sessionmaker(bind=models.engine)
session = _Session()

app = Flask(__name__)
bcrypt = Bcrypt(app)

video_folder = os.environ.get("UPLOADED_VIDEOS_DEST")
audio_folder = os.environ.get("UPLOADED_AUDIOS_DEST")

app.config['JWT_SECRET_KEY'] = os.environ.get("JWT_SECRET_KEY")
app.config['UPLOADED_VIDEOS_DEST'] = video_folder
app.config['UPLOADED_VIDEOS_ALLOW'] = ALLOWED_EXTENSIONS_VIDEO
app.config['UPLOADED_AUDIOS_DEST'] = audio_folder
app.config['UPLOADED_AUDIOS_ALLOW'] = ALLOWED_EXTENSIONS_AUDIO
jwt = JWTManager(app)

videos = UploadSet('videos')
audios = UploadSet('audios')
configure_uploads(app, videos)
configure_uploads(app, audios)


api = Api(app)

class Notification(Resource):
    def post(self):

        token = request.headers.get("Authorization")
        user = verify_token_and_get_user2(token)
            
        if not user:
            return {'message' : 'Token non valido'}, 400

        if user.tipo != 1:
            return {'message' : 'Non sei autorizzato'}, 400

        type = request.form.get('type')
        title = request.form.get('title')
        body = request.form.get('body')

        if not type:
            return {'message':'Richiesta non valida'},400

        if not title and not body:
            if type == "Video":
                send_not(messaging, "È l'ora del video!","Registra un video e dicci come ti senti 📽️❤️")
            else:
                send_not(messaging,"È l'ora dell'audio!","Leggi un breve testo e dicci come ti senti 📖❤️")
        else:
            send_not(messaging, title, body)

        return {'message': 'Notifica inviata correttamente'}
        
def getAudioById(audio_id):
    try:
        return session.query(models.Audioc).filter(models.Audioc.idaudio == audio_id).first()
    except:
        return False

class AudioDetails(Resource):
    def get(self):
        # controllo token, faccio il redirect e decrypto
        token = request.headers.get("Authorization")
        user = verify_token_and_get_user2(token)
            
        if not user:
            return {'message' : 'Token non valido'}, 400

        if user.tipo != 1:
            return {'message' : 'Non sei autorizzato'}, 400

        audio_to_check = request.args.get('audio_id')
        if not audio_to_check or not isinstance(audio_to_check, str):
            return {'message': 'Richiesta non valida'}

        audio = getAudioById(audio_to_check)

        if not audio:
            return { 'message' : 'Si è verificato un errore'}

        name = os.path.basename(audio.path)
        return send_file(
         audio.path, 
         mimetype="audio/wav", 
         as_attachment=False, 
         download_name=f"{name}.wav")

class Audio(Resource):
    def post(self):
        # check if the post request has the file part
        if 'file' not in request.files:
            return {'message' : 'No file part in the request'}, 400
        file = request.files['file']

        text = request.form.get('json')

        if not text or text == '':
            return {'message' : 'Richiesta non valida'}, 400

        jsonT = json.loads(text)

        if not jsonT or jsonT == '':
            return {'message' : 'Richiesta non valida'}, 400

        if file.filename == '':
            return {'message' : 'No file selected for uploading'}, 400

        if file and allowed_file_audio(file.filename):
            
            token = request.headers.get("Authorization")
            user = verify_token_and_get_user2(token)
            
            if not user:
                return {'message' : 'Token non valido'}, 400

            ext = '.' in file.filename and file.filename.rsplit('.', 1)[1].lower()
            filename = audios.save(file, folder=str(user.idutente))
            filename = os.environ.get("UPLOADED_AUDIOS_DEST")+filename

            try: 
                convert_audio(filename, filename+".wav", True)
            except:
                return { 'message':'Si è verificato un errore - Audio'}
            
            filename = filename+".wav"
            emoji = analyze(filename)
            print(emoji)
            if not encrypt_file(str(user.key), filename):
                return { 'message':'Si è verificato un errore - Encrypt'}

            idTesto = jsonT["idTesto"]
            emojiUser = jsonT["emojiUser"]

            query = insert(models.Audioc.__table__).values(
                data = str(datetime.today().strftime("%d/%m/%Y")),
                durata = 10,
                emozioneia =  json.dumps(emoji, indent = 4),
                emozioneutente =  emojiUser,
                idtesto = idTesto,
                idutente = user.idutente,
                path = filename
            )

            try:
                result = session.execute(query)

                print(result)

                if (len(result.inserted_primary_key)) != 1:
                    print(f'Len: {len(result.inserted_primary_key)}')
                    return { 'message':'Ops, qualcosa è andato storto'}, 400

                
                return {'message' : f'File successfully uploaded: {filename}'}, 201
            except Exception as e:
                print(e)
                return { 'message':'Ops, qualcosa è andato storto'}, 400

        else:
            return {'message' : 'Allowed file types are m4a, flac, mp3, mp4, wav, wma, aac'}, 400

    def get(self):

        # Lista audio di un utente per la dashboard

        token = request.headers.get("Authorization")
        user = verify_token_and_get_user2(token)
            
        if not user:
            return {'message' : 'Token non valido'}, 400

        if user.tipo != 1:
            return {'message' : 'Non sei autorizzato'}, 400

        user_to_check = request.args.get('user_id')

        if not user_to_check or not isinstance(user_to_check, str):
            return {'message': 'Richiesta non valida'}

        user_fetched = getUserById(user_to_check, False)

        if not user_fetched:
             return { 'message': "L'utente richiesto non esiste" }

        lista_audio = getAudiosByUserId(user_fetched.idutente)

        if (len(lista_audio) == 0):
            return []

        list = []
        for audio in lista_audio:
            list.append(audio.toJson())

        print(list)

        return list          
    
def getVideoById(video_id):
    try:
        return session.query(models.Video).filter(models.Video.idVideo == video_id).first()
    except:
        return False

class VideoDetails(Resource):
    def get(self):
        # controllo token, faccio il redirect e decrypto
        token = request.headers.get("Authorization")
        user = verify_token_and_get_user2(token)
            
        if not user:
            return {'message' : 'Token non valido'}, 400

        if user.tipo != 1:
            return {'message' : 'Non sei autorizzato'}, 400

        video_to_check = request.args.get('video_id')
        if not video_to_check or not isinstance(video_to_check, str):
            return {'message': 'Richiesta non valida'}

        video = getVideoById(video_to_check)

        if not video:
            return { 'message' : 'Si è verificato un errore'}

        name = os.path.basename(video.path)
        return send_file(
         video.path, 
         mimetype="video/mp4", 
         as_attachment=False, 
         download_name=f"{name}.mp4")

class Video(Resource):
    def post(self):
        # check if the post request has the file part
        if 'file' not in request.files:
            return {'message' : 'No file part in the request'}, 400
        file = request.files['file']
        if file.filename == '':
            return {'message' : 'No file selected for uploading'}, 400

        text = request.form.get('json')
        if not text or text == '':
            return {'message' : 'Richiesta non valida json'}, 400

        jsonT = json.loads(text)
        if not jsonT or jsonT == '':
            return {'message' : 'Richiesta non valida json2'}, 400

        if file and allowed_file_video(file.filename):
            
            token = request.headers.get("Authorization")
            user = verify_token_and_get_user2(token)
            
            if not user:
                return {'message' : 'Token non valido'}, 400
            
            print(f"Key: {user.key}")

            filename = videos.save(file, folder=str(user.idutente))
            filename = os.environ.get("UPLOADED_VIDEOS_DEST")+filename

            if not checkFace(filename):
                return { "error": "Viso non rilevato"}

            emojiUser = jsonT["emojiUser"]

            query = insert(models.Video.__table__).values(
                data = str(datetime.today().strftime("%d/%m/%Y")),
                durata = 120,
                emozioneUtente = emojiUser,
                ora = str(datetime.today().strftime("%d/%m/%Y")),
                idUtente = user.idutente,
                path = filename,
                status = "processing"
            )

            try:
                result = session.execute(query)

                if (len(result.inserted_primary_key)) != 1:
                    return { 'message':'Ops, qualcosa è andato storto len'}, 400
                
                idvideo = result.inserted_primary_key[0]
                
                if not idvideo:
                    return { 'message':'Ops, qualcosa è andato storto idvideo'}, 400
                
                thread = Thread(target=analyzeVideoThreaded, args=(filename, str(idvideo), user.key))
                thread.start()

                return {'message' : f'File successfully uploaded: {filename}'}, 201
            except Exception as e:

                print(type(e))
                print(e)
                return { 'message':'Ops, qualcosa è andato storto excpt'}, 400

        else:
            print(f"{file.filename}")
            resp = {'message' : 'Allowed file types are mp4, mov, avi, flv, mkv, webm'}, 400
            return resp

    def get(self):

        # Lista video di un utente per la dashboard

        token = request.headers.get("Authorization")
        user = verify_token_and_get_user2(token)
            
        if not user:
            return {'message' : 'Token non valido'}, 400

        if user.tipo != 1:
            return {'message' : 'Non sei autorizzato'}, 400

        user_to_check = request.args.get('user_id')

        if not user_to_check or not isinstance(user_to_check, str):
            return {'message': 'Richiesta non valida'}

        user_fetched = getUserById(user_to_check, False)

        if not user_fetched:
             return { 'message': "L'utente richiesto non esiste" }

        lista_video = getVideosByUserId(user_fetched.idutente)

        if (len(lista_video) == 0):
            return []
        
        list = []
        for video in lista_video:
            list.append(video.toJson())

        return list
          
def getVideosByUserId(id):
    try:
        query = select(models.Video).where(models.Video.idUtente == id)
        result = session.execute(query).all()
        list = []
        for row in result:
            print(row)
            list.append(row[0])
        return list
    except Exception:
        return []

def getAudiosByUserId(id):
    try:
        query = select(models.Audioc).where(models.Audioc.idutente == id)
        result = session.execute(query).all()
        list = []
        for row in result:
            print(row)
            list.append(row[0])
        return list
    except Exception:
        return []

class Register(Resource):
    def post(self):

        data = request.get_json()
        email = data["email"]
        password = data["password"]
        cf = data["codice_fiscale"]
        telefono = data["telefono"]
        nome = data["nome"]
        cognome = data["cognome"]
        data_di_nascita = data["data_di_nascita"]
        residenza = data["residenza"]

        if not validate_register_input(email, password, cf, telefono, nome, cognome, data_di_nascita, residenza):
            return {'message' : 'I dati inseriti non sono validi'}, 400

        if getUserByEmail(email, False):
            return {'message' : 'User already exist'}, 400


        idutente = generateUID()
        encrypted = bcrypt.generate_password_hash(password).decode('utf-8')
        print(encrypted)

        query = insert(models.User.__table__).values(
            idutente = idutente,
            cf = cf, 
            email = email, 
            password = encrypted,
            telefono = telefono,
            nome = nome,
            cognome = cognome,
            data_di_nascita = data_di_nascita,
            residenza = residenza,
            key = (Fernet.generate_key()).decode('utf-8'),
            tipo = 0,
        )

        try:
            result = session.execute(query)

            if (len(result.inserted_primary_key)) != 1:
                print(f'Len: {len(result.inserted_primary_key)}')
                return { 'message':'Ops, qualcosa è andato storto'}, 400

            generated_uuid = result.inserted_primary_key[0]

            if not (generated_uuid == idutente):
                print(f'gu: {generated_uuid}\nuid: {idutente}')
                return { 'message':'Ops, qualcosa è andato storto'}, 400

            return { 'message':"L'utente è stato creato correttamente!"}
        except:
            return { 'message':'Ops, qualcosa è andato storto'}, 400

          

class Login(Resource):
    def post(self):
        data = request.get_json()
        email = data["email"]
        password = data["password"]
        
        query = select(models.User).where(models.User.email == email)
        result = session.execute(query).all()

        if (len(result) == 0):
             return {'message' : "L'utente non esiste"}, 400
        
        if (len(result) > 1):
             return {'message' : 'Ops, si è verificato un errore'}, 400
        
        user = result[0][0]
        print(f"0. {user.email}")
        print(f"1. {user.password}")
        print(f"2. {password}")
        if not bcrypt.check_password_hash(user.password, password):
            return {'message' : 'Passowrd errata'}, 400


        token = create_access_token(identity=user.email, expires_delta=False)    
        return {
            'id': user.idutente,
            'token': token
        }   
    

class Auth(Resource):
    pass


def verify_token_and_get_user2(token: str):
    
    if not isinstance(token, str):
        return False
        
    token = token.replace('Bearer ', '')
    try:
        email = decode_token(token)['sub']
        return getUserByEmail(email, False)
    except Exception:
        return False


def getUserByEmail(email: str, showPassword: bool):
    try:
        query = select(models.User).where(models.User.email == email)
        result = session.execute(query).all()
        if len(result) != 1:
            return False

        user = result[0][0]
        if not showPassword:
            user.password = ''    
        return user
    except Exception:
        return False

def getAllUsers(showPassword: bool):
    try:
        query = select(models.User).where(models.User.tipo == 0)
        result = session.execute(query).all()

        list = []
        
        for user in result:
            if not showPassword:
                user[0].password = ''    
            list.append(user[0])

        return list
    except Exception:
        return False

def getUserByCf(cf: str, showPassword: bool):
    try:
        query = select(models.User).where(models.User.cf == cf)
        result = session.execute(query).all()
        if len(result) != 1:
            return False

        user = result[0][0]
        if not showPassword:
            user.password = ''    
        return user
    except Exception:
        return False

def getUserById(id: str, showPassword: bool):
    try:
        query = select(models.User).where(models.User.idutente == id)
        result = session.execute(query).all()
        if len(result) != 1:
            return False

        user = result[0][0]
        if not showPassword:
            user.password = ''    
        return user
    except Exception:
        return False

def generateAudioId():
    id = uuid.uuid4()
    if getUserById(id, False):
        return generateUID()
    else:
        return id        

def generateUID():
    id = uuid.uuid4()
    if getUserById(id, False):
        return generateUID()
    else:
        return id        

class DetailsAll(Resource):
    def get(self):

        token = request.headers.get("Authorization")
        user = verify_token_and_get_user2(token)

        if not user:
            return {'message' : 'Token non valido'}, 400

        if (user.tipo != 1):
            return {'message': 'Non sei autorizzato'}, 400

        users = getAllUsers(False) 

        print(users)

        if not users:
            return []
        
        list = []
        for user in users:
            list.append(user.toJson())

        return list

class Details(Resource):
    def get(self):

        token = request.headers.get("Authorization")
        user = verify_token_and_get_user2(token)

        if not user:
            return {'message' : 'Token non valido'}, 400

        user_to_check = request.args.get('user_id')

        if not user_to_check or not isinstance(user_to_check, str):
            print(user.toJson())
            return user.toJson()

        if user_to_check == user.idutente:
            user.password = ''
            print(user.toJson())
            return user.toJson()
        
        if (user.tipo != 1):
            return {'message': 'Non sei autorizzato'}, 400

        user_fetched = getUserById(user_to_check, False) 

        if not user_fetched:
            return { 'message' : "L'utente richiesto non è stato trovato"}  

        print(user_fetched.toJson())
        return user_fetched.toJson()
                
    
class Api(Resource):
    def get(self):
        return { "successful": True, "message": "Le API sono attive e funzionanti" }, 200

api.add_resource(Api, "/api") #endpoint to
api.add_resource(Auth, "/api/auth") #endpoint to
api.add_resource(Register, "/api/auth/register") #endpoint to 
api.add_resource(Login, "/api/auth/login") #endpoint to 
api.add_resource(Details, "/api/user") #endpoint to
api.add_resource(DetailsAll, "/api/user/all") #endpoint to 
api.add_resource(Video, "/api/video") #endpoint to 
api.add_resource(VideoDetails, "/api/video/play") #endpoint to 
api.add_resource(Audio, "/api/audio") #endpoint to 
api.add_resource(AudioDetails, "/api/audio/play") #endpoint to
api.add_resource(Notification, "/api/notification")

if __name__ == '__main__':
    #app.run(host="172.19.161.41")  #uni
    #app.run(host="172.20.10.3") #matteo
    thread = Thread(target = scheduleNotification, args = ())
    thread.daemon = True
    thread.start()
    #send_not(messaging,"È l'ora dell'audio!","Leggi un breve testo e dicci come ti senti 📖❤️")
    app.run() #casa
