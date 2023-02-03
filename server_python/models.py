import os
from sqlalchemy import Column, Integer, ForeignKey, Float, Text, MetaData, create_engine
from sqlalchemy.orm import declarative_base
from dotenv import load_dotenv
from sqlalchemy_serializer import SerializerMixin
from sqlalchemy.orm import class_mapper
import json

load_dotenv(".flaskenv")

metadata = MetaData()
Base = declarative_base()

database_url = os.environ.get("DATABASE_URL")

engine = create_engine(database_url, isolation_level="AUTOCOMMIT")

class TestoDaLeggere(Base, SerializerMixin):
   __tablename__ = 'testoDaLeggere'

   idTesto = Column(Text, primary_key=True, nullable=False)
   testo = Column(Text, nullable=False)

   def toJson(self):
      return self.to_dict()    


class ParametriVitali(Base, SerializerMixin):
   __tablename__ = 'parametriVitali'

   id = Column(Integer, primary_key=True, nullable=False)
   testo = Column(Text, nullable=False)
   dataInizio =  Column(Text, nullable=False)
   dataFine =  Column(Text, nullable=False)
   ora = Column(Text, nullable=False)
   battiti =  Column(Integer, nullable=False)
   frequenzaRespiratoria =  Column(Float, nullable=False)
   ossigenazione =  Column(Integer, nullable=False)
   qualitaSonno =  Column(Integer, nullable=False)
   idUtente = Column(Text, ForeignKey('utente.idutente'), nullable=False)

   def toJson(self):
      return self.to_dict()    

class ParametriAmbientali(Base, SerializerMixin):
   __tablename__ = 'parametriAmbientali'

   id = Column(Integer, primary_key=True, nullable=False)
   quantitaCO2 = Column(Integer, nullable=False)
   dataInizio =  Column(Text, nullable=False)
   dataFine =  Column(Text, nullable=False)
   luminosita = Column(Integer, nullable=False)
   quantitaPS25 =  Column(Float, nullable=False)
   quantitaPM10 =  Column(Float, nullable=False)
   idUtente = Column(Text, ForeignKey('utente.idutente'), nullable=False)

   def toJson(self):
      return self.to_dict()

class Video(Base, SerializerMixin):
   __tablename__ = 'video'

   idVideo = Column(Integer, primary_key=True, nullable=False, autoincrement = True)
   data =  Column(Text, nullable=False)
   durata = Column(Integer, nullable=False)
   emozioneIA =  Column(Text, nullable=False)
   emozioneUtente =  Column(Text, nullable=False)
   ora = Column(Text, nullable=False)
   idUtente = Column(Text, ForeignKey('utente.idutente'), nullable=False)
   path = Column(Text, nullable=False)

   def toJson(self):
      return self.to_dict()

class Audioc(Base, SerializerMixin):
   __tablename__ = 'audio'

   idaudio = Column(Integer, primary_key=True, nullable=False, autoincrement = True)
   data =  Column(Text, nullable=False)
   durata = Column(Integer, nullable=False)
   emozioneia =  Column(Text, nullable=False)
   emozioneutente =  Column(Text, nullable=False)
   idtesto = Column(Text, ForeignKey('testoDaLeggere.idTesto'), nullable=False)
   idutente = Column(Text, ForeignKey('utente.idutente'), nullable=False)
   path = Column(Text, nullable=False)

   def toJson(self):
      return self.to_dict()                

class User(Base, SerializerMixin):

    __tablename__ = 'utente'

    idutente = Column(Text, primary_key=True)
    cf = Column(Text, nullable=False)
    email = Column(Text, nullable=False)
    telefono = Column(Text, nullable=False)
    nome = Column(Text, nullable=False)
    cognome = Column(Text, nullable=False)
    data_di_nascita = Column(Text, nullable=False)
    residenza = Column(Text, nullable=False)
    password = Column(Text, nullable=False)
    key = Column(Text, nullable=False)
    tipo = Column(Integer, nullable=False)

    def toJson(self):
      return self.to_dict()

metadata.create_all(engine)