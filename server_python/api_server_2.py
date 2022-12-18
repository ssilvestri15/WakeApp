import os
import models
import uuid
from sqlalchemy import select, insert
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv
from flask import Flask, request
from flask_restful import Resource, Api
from flask_jwt_extended import JWTManager, create_access_token, decode_token
from flask_bcrypt import Bcrypt
from flask_uploads import UploadSet, configure_uploads
from utils import allowed_file, validate_register_input, ALLOWED_EXTENSIONS, encrypt_video, decrypt_video
from cryptography.fernet import Fernet


load_dotenv(".flaskenv")

_Session = sessionmaker(bind=models.engine)
session = _Session()

app = Flask(__name__)
bcrypt = Bcrypt(app)

app.config['JWT_SECRET_KEY'] = os.environ.get("JWT_SECRET_KEY")  # Change on production
app.config['UPLOADED_VIDEOS_DEST'] = os.environ.get("UPLOADED_VIDEOS_DEST")  # Change on production
app.config['UPLOADED_VIDEOS_ALLOW'] = ALLOWED_EXTENSIONS
jwt = JWTManager(app)

videos = UploadSet('videos')
configure_uploads(app, videos)
video_folder = os.environ.get("UPLOADED_VIDEOS_DEST")  #estrae url da env

api = Api(app)

class VideoDetails(Resource):
    def get(self):
        # controllo token, faccio il redirect e decrypto
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

        video_to_check = request.args.get('video_id')
        if not video_to_check or not isinstance(video_to_check, str):
            return {'message': 'Richiesta non valida'}


        #video = getUserVideoById(user_to_check, video_to_check)
        pass

class Video(Resource):
    def post(self):
        # check if the post request has the file part
        if 'file' not in request.files:
            return {'message' : 'No file part in the request'}, 400
        file = request.files['file']
        if file.filename == '':
            return {'message' : 'No file selected for uploading'}, 400
        if file and allowed_file(file.filename):
            
            token = request.headers.get("Authorization")
            user = verify_token_and_get_user2(token)
            
            if not user:
                return {'message' : 'Token non valido'}, 400

            # TODO
            # Aggiungere una voce al video al db
            # prendersi l'idvideo e usarlo come nome file
            
            filename = videos.save(file, folder=str(user.idutente))
            filename = os.environ.get("UPLOADED_VIDEOS_DEST")+filename
            if not encrypt_video(str(user.key), filename):
                return { 'message':'Si è verificato un errore'}

            return {'message' : f'File successfully uploaded: {filename}'}, 201
        else:
            resp = {'message' : 'Allowed file types are mp4, mov, avi, flv, mkv, webm'}
            resp.status_code = 400
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

        if not lista_video:
            return { 'message': "Si è verificato un errore" }

        if (len(lista_video) == 0):
            return { 'message':'Nessun video' }

        # TODO
        # ritornare lista video

        return 'ok'
          
def getVideosByUserId(id):
    try:
        query = select(models.Video).where(models.Video.idutente == id)
        result = session.execute(query).all()
        list = []
        for row in result:
            print(row)
            list.append(row[0])
        return list
    except Exception:
        return False      

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
        print(user.password)
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

def generateUID():
    id = uuid.uuid4()
    if getUserById(id, False):
        return generateUID()
    else:
        return id        

class Details(Resource):
    def get(self):

        token = request.headers.get("Authorization")
        user = verify_token_and_get_user2(token)

        if not user:
            return {'message' : 'Token non valido'}, 400

        user_to_check = request.args.get('user_id')

        if not user_to_check or not isinstance(user_to_check, str):
            return {'user': user.toJson()}

        if user_to_check == user.cf:
            user.password = ''
            return {'user': user.toJson()}

        if (user.tipo != 1):
            return {'message': 'Non sei autorizzato'}, 400

        user_fetched = getUserByCf(user_to_check, False) 

        if not user_fetched:
            return { 'message' : "L'utente richiesto non è stato trovato"}  

        return user_fetched.toJson()
                
    
class Api(Resource):
    def get(self):
        return { "successful": True, "message": "Le API sono attive e funzionanti" }, 200

api.add_resource(Api, "/api") #test endpoint
api.add_resource(Auth, "/api/auth") #endpoint to Auth
api.add_resource(Register, "/api/auth/register") #endpoint to Auth
api.add_resource(Login, "/api/auth/login") #endpoint to Auth
api.add_resource(Details, "/api/user") #endpoint to User
api.add_resource(Video, "/api/video") #endpoint to User
api.add_resource(Video, "/api/video/play") #endpoint to User

if __name__ == '__main__':
    #app.run(host="172.19.161.41")  #uni
    app.run() #casa
