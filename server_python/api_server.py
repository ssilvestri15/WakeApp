import os #The OS module in Python provides functions for creating and removing a directory (folder) etc
import psycopg2 #to use postgresql
from dotenv import load_dotenv #to use .flaskenv
from flask import Flask, request
from flask_restful import Resource, Api, reqparse
import pandas as pd #Analizza i dati
import ast

CREATE_ROOMS_TABLE = (
    "CREATE TABLE IF NOT EXISTS rooms (id SERIAL PRIMARY KEY, name TEXT);"
)

INSERT_ROOM_RETURN_ID = "INSERT INTO rooms (name) VALUES (%s) RETURNING id;"

load_dotenv(".flaskenv") #prende variabili da .flaskdev

app = Flask(__name__)
url = os.environ.get("DATABASE_URL")  #estrae url da env
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
                    cursor.execute(CREATE_ROOMS_TABLE)
                    cursor.execute(INSERT_ROOM_RETURN_ID, (name,))
                    room_id = cursor.fetchone()[0]
                    return {"id": room_id, "message": f"Room {name} created."}, 201
        

class Auth(Resource):
    pass

class User(Resource):
    pass

class Api(Resource):
    def get(self):
        return "API ON"


api.add_resource(Api, "/api") #test endpoint
api.add_resource(Test, "/api/test") #test endpoint
api.add_resource(Auth, "/api/auth") #endpoint to Auth
api.add_resource(User, "/api/user") #endpoint to User

if __name__ == '__main__':
    app.run()  # run our Flask app
