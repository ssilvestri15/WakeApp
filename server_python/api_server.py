import os #The OS module in Python provides functions for creating and removing a directory (folder) etc
import psycopg2 #to use postgresql
from dotenv import load_dotenv #to use .flaskenv
from flask import Flask, request
from flask_restful import Resource, Api, reqparse
from flask_jwt_extended import JWTManager, jwt_required, create_access_token, decode_token
from werkzeug.utils import secure_filename
import pandas as pd #Analizza i dati
import ast

CREATE_USER_TABLE = (
    "CREATE TABLE IF NOT EXISTS users (id SERIAL PRIMARY KEY, email TEXT, password TEXT, type integer);"
)

INSERT_USER_RETURN_ID = "INSERT INTO users (email, password, type) VALUES (%s, %s, %d) RETURNING id;"

CHECK_USER_EXIST_BY_EMAIL = "SELECT * FROM users WHERE email=(%s);"

CHECK_USER_EXIST_BY_ID = "SELECT * FROM users WHERE id=(%s);"


LOGIN = "SELECT * FROM users WHERE email=(%s) AND password=(%s);"

ALLOWED_EXTENSIONS = set(['mp4', 'mov', 'avi', 'flv', 'mkv', 'webm'])

def allowed_file(filename):
	return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

load_dotenv(".flaskenv") #prende variabili da .flaskdev

app = Flask(__name__)
app.config['JWT_SECRET_KEY'] = 'super-secret'  # Change on production
jwt = JWTManager(app)
url = os.environ.get("DATABASE_URL")  #estrae url da env
video_folder = os.environ.get("UPLOAD_FOLDER")  #estrae url da env
connection = psycopg2.connect(url)

api = Api(app)

class Test(Resource):
    def get(self):
        return "GET successfull", 200
    def post(self):
            data = request.get_json()
            name = data["name"]
            with connection:
                with connection.cursor() as cursor:
                    #cursor.execute(CREATE_ROOMS_TABLE)
                    #cursor.execute(INSERT_ROOM_RETURN_ID, (name,))
                    room_id = cursor.fetchone()[0]
                    return {"id": room_id, "message": f"Room {name} created."}, 201
        
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


class Register(Resource):
    def post(self):
        data = request.get_json()
        email = data["email"]
        password = data["password"]
        with connection:
            with connection.cursor() as cursor:
                cursor.execute(CREATE_USER_TABLE)
                cursor.execute(CHECK_USER_EXIST_BY_EMAIL, (email,))
                user = cursor.fetchall()
                print(user)
                if user:
                    return {'message' : 'User already exist'}, 400
                else:
                    cursor.execute(INSERT_USER_RETURN_ID, (email, password, 0))
                    user_id = cursor.fetchone()[0]
                    token = create_access_token(identity=email)
                    return {"id": user_id, "message": f"Room {email}:{password} created.", "token": token}, 201

class Login(Resource):
    def post(self):
        data = request.get_json()
        email = data["email"]
        password = data["password"]
        with connection:
            with connection.cursor() as cursor:
                cursor.execute(CREATE_USER_TABLE)
                cursor.execute(LOGIN, (email, password))
                user = cursor.fetchall()
                if user:
                    token = create_access_token(identity=user[0][1], expires_delta=False)
                    return {"id": user[0][0], "message": f"Login successful", "token": token}, 201
                else:
                    return {'message' : 'User not exist'}, 400
                    cursor.execute(INSERT_USER_RETURN_ID, (email, password))
                    user_id = cursor.fetchone()[0]
                    token = create_access_token(identity=email)
                    return {"id": user_id, "message": f"Room {email}:{password} created.", "token": token}, 201

    

class Auth(Resource):
    pass

def verify_token_and_get_user(token: str):

    if not isinstance(token, str):
        return False

    token = token.replace('Bearer ', '')

    try:
        email = decode_token(token)['sub']
        with connection:
            with connection.cursor() as cursor:
                cursor.execute(CHECK_USER_EXIST_BY_EMAIL, (email,))
                user = cursor.fetchall()

                if not user or len(user) != 1:
                    return []

                return user[0]
                    
    except Exception:
        return []


class User(Resource):
    def get(self):

        token = request.headers.get("Authorization")
        user = verify_token_and_get_user(token)

        if not user or len(user) == 0:
            return {'message' : 'Token non valido'}, 400

        user_to_check = request.args.get('user_id')

        if not user_to_check or not isinstance(user_to_check, str):
            return {'user': user}

        if user_to_check == user[0]:
            return {'user': user}

        if (user[3] != 1):
            return {'message': 'Non sei autorizzato'}, 400

        with connection:
            with connection.cursor() as cursor:
                cursor.execute(CHECK_USER_EXIST_BY_ID, (user_to_check,))
                user_fetched = cursor.fetchall()
                
                if not user_fetched or len(user_fetched) != 1:
                    return {'message' : "L'utente richiesto non è stato trovato"}, 400 
                        
                return {'user': user_fetched[0]}        
                

    
class Api(Resource):
    def get(self):
        return { "successful": True, "message": "Le API sono attive e funzionanti" }, 200


api.add_resource(Api, "/api") #test endpoint
api.add_resource(Test, "/api/test") #test endpoint
api.add_resource(Auth, "/api/auth") #endpoint to Auth
api.add_resource(Register, "/api/auth/register") #endpoint to Auth
api.add_resource(Login, "/api/auth/login") #endpoint to Auth
api.add_resource(User, "/api/user") #endpoint to User
api.add_resource(Video, "/api/video") #endpoint to User

if __name__ == '__main__':
    #app.run(host="172.19.161.41")  #uni
    app.run(host='192.168.178.68') #casa