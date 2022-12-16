import os
from sqlalchemy import Column, Integer, ForeignKey, Float, Text, MetaData, create_engine
from sqlalchemy.orm import declarative_base
from dotenv import load_dotenv

load_dotenv(".flaskenv")

metadata = MetaData()
Base = declarative_base()

database_url = os.environ.get("DATABASE_URL")

engine = create_engine(database_url, isolation_level="AUTOCOMMIT")

class TestoDaLegger(Base):
   __tablename__ = 'testoDaLeggere'

   idTesto = Column(Text, primary_key=True, nullable=False)
   testo = Column(Text, nullable=False)

   def toJson(self):
      return {c.name: getattr(self, c.name) for c in self.__table__.columns}


class ParametriVitali(Base):
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
      return {c.name: getattr(self, c.name) for c in self.__table__.columns}

class ParametriAmbientali(Base):
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
      return {c.name: getattr(self, c.name) for c in self.__table__.columns} 

class Video(Base):
   __tablename__ = 'video'

   idVideo = Column(Integer, primary_key=True, nullable=False)
   data =  Column(Text, nullable=False)
   durata = Column(Integer, nullable=False)
   emozioneIA =  Column(Text, nullable=False)
   emozioneUtente =  Column(Text, nullable=False)
   ora = Column(Text, nullable=False)
   idUtente = Column(Text, ForeignKey('utente.idutente'), nullable=False)

   def toJson(self):
      return {c.name: getattr(self, c.name) for c in self.__table__.columns}

class Audioc(Base):
   __tablename__ = 'audio'

   idAudio = Column(Integer, primary_key=True, nullable=False)
   data =  Column(Text, nullable=False)
   durata = Column(Integer, nullable=False)
   emozioneIA =  Column(Text, nullable=False)
   emozioneUtente =  Column(Text, nullable=False)
   idTesto = Column(Text, ForeignKey('testoDaLeggere.idTesto'), nullable=False)
   idUtente = Column(Text, ForeignKey('utente.idutente'), nullable=False)

   def toJson(self):
      return {c.name: getattr(self, c.name) for c in self.__table__.columns}                     

class User(Base):

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
       return {c.name: getattr(self, c.name) for c in self.__table__.columns}


metadata.create_all(engine)