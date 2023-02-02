import random
import models
import uuid
from datetime import datetime
from flask import Flask
from flask_bcrypt import Bcrypt
from sqlalchemy import select, insert
from sqlalchemy.orm import sessionmaker
from faker import Faker
from cryptography.fernet import Fernet
from codicefiscale import codicefiscale

_Session = sessionmaker(bind=models.engine)
session = _Session()

fake = Faker('it_IT')
fakeMaleNames = [fake.unique.first_name_male() for i in range(50)]
fakeFemaleNames = [fake.unique.first_name_female() for i in range(50)]
fakeLastNames = [fake.unique.last_name() for i in range(50)]

generatedName = []

app = Flask(__name__)
bcrypt = Bcrypt(app)

class Person:
  def __init__(self, name, lastname, gender):
    self.name = name
    self.lastname = lastname
    self.gender = gender
    self.fullname = name+" "+lastname
    self.email = (self.fullname.replace(" ",".").lower())+"@gmail.com"

def generateFakePerson():   
    gender = "M" if (random.randint(0, 1) == 0) else "F"
    name = random.choice(fakeMaleNames) if (gender == "M") else random.choice(fakeFemaleNames)
    lastName = random.choice(fakeLastNames)
    person = Person(name, lastName, gender)

    while ((person.fullname in generatedName) or (getUserByEmail(person.email))):
        person = generateFakePerson()
    
    generatedName.append(person.fullname)
    return person

def getUserByEmail(email: str):
    try:
        query = select(models.User).where(models.User.email == email)
        result = session.execute(query).all()
        if len(result) > 0:
            return True
        return False
    except Exception:
        return False


def getUserById(id: str):
    try:
        query = select(models.User).where(models.User.idutente == id)
        result = session.execute(query).all()
        if len(result) > 0:
            return True
        return False
    except Exception:
        return False

def generateUID():
    id = uuid.uuid4()
    if getUserById(id):
        return generateUID()
    else:
        return id    
    
def genDateOfBirth():
    CurrentTime = datetime.now()
    return f"{random.randrange(1, 28)}/{random.randrange(1, 12)}/{random.randrange(1911,CurrentTime.year-18)}"


def populate(num):

    added = 0
    for _ in range(0,num):

        person = generateFakePerson()
        idutente = generateUID()
        encrypted = bcrypt.generate_password_hash("simo").decode('utf-8')
        key = (Fernet.generate_key()).decode('utf-8')
        data = genDateOfBirth()
        city = fake.state()

        try:

            query = insert(models.User.__table__).values(
                idutente = idutente,
                cf = codicefiscale.encode(person.lastname, person.name, person.gender, data, city), 
                email = person.email, 
                password = encrypted,
                telefono = "0000000000",
                nome = person.name,
                cognome = person.lastname,
                data_di_nascita = data,
                residenza = city,
                key = key,
                tipo = 0,
            )

            result = session.execute(query)

            if (len(result.inserted_primary_key)) != 1:
                pass

            added += 1
            print(f"{added}. Aggiunto l'utente {person.fullname} con id: {idutente}")

        except:
            continue



if __name__ == '__main__':
    populate(30)
