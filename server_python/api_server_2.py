import os
import models
import json
from sqlalchemy import create_engine, select, insert
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv
from flask import Flask, request
from flask_restful import Resource, Api
from flask_jwt_extended import JWTManager, create_access_token, decode_token
from flask_bcrypt import Bcrypt
from werkzeug.utils import secure_filename
from utils import allowed_file

load_dotenv(".flaskenv")

database_url = os.environ.get("DATABASE_URL")
engine = create_engine(database_url)
connection = engine.connect()

_Session = sessionmaker(bind=engine)
session = _Session()

app = Flask(__name__)
bcrypt = Bcrypt(app)
app.config['JWT_SECRET_KEY'] = os.environ.get("JWT_SECRET_KEY")  # Change on production
jwt = JWTManager(app)
url = os.environ.get("DATABASE_URL")  #estrae url da env
video_folder = os.environ.get("UPLOAD_FOLDER")  #estrae url da env

api = Api(app)

## TODO: DA FINIRE ######################################################################
class Video(Resource):
    def post(self):
        # check if the post request has the file part
        if 'file' not in request.files:
            return {'message' : 'No file part in the request'}, 400
        file = request.files['file']
        if file.filename == '':
            return {'message' : 'No file selected for uploading'}, 400
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(video_folder, filename))
            return {'message' : 'File successfully uploaded'}, 201
        else:
            resp = {'message' : 'Allowed file types are mp4, mov, avi, flv, mkv, webm'}
            resp.status_code = 400
            return resp
#########################################################################################

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
        with connection:
            with connection.cursor() as cursor:
                cursor.execute(query.CHECK_USER_EXIST_BY_EMAIL, (email,))
                user = cursor.fetchall()
                print(user)
                if user:
                    cursor.close()
                    return {'message' : 'User already exist'}, 400
                else:
                    encrypted = bcrypt.generate_password_hash(password).decode('utf-8')
                    cursor.execute(query.INSERT_USER_RETURN_ID, (cf, email, encrypted, telefono, nome, cognome, data_di_nascita, residenza, 0))
                    user_id = cursor.fetchone()[0]
                    token = create_access_token(identity=email, )
                    cursor.close()
                    return {"id": user_id, "message": f"Room {email}:{password} created.", "token": token}, 201


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
        if not bcrypt.check_password_hash(user.password, password):
            return {'message' : 'Passowrd errata'}, 400


        token = create_access_token(identity=user.email, expires_delta=False)    
        return {
            'cf': user.cf,
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

if __name__ == '__main__':
    #app.run(host="172.19.161.41")  #uni
    app.run() #casa
