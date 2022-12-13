from sqlalchemy import Column, Integer, String, DateTime, Text
from sqlalchemy.orm import declarative_base
from datetime import datetime

Base = declarative_base()

class User(Base):
    __tablename__ = 'utente'

    cf = Column(Text, primary_key=True)
    email = Column(Text, nullable=False)
    telefono = Column(Text, nullable=False)
    nome = Column(Text, nullable=False)
    cognome = Column(Text, nullable=False)
    data_di_nascita = Column(Text, nullable=False)
    residenza = Column(Text, nullable=False)
    password = Column(Text, nullable=False)
    tipo = Column(Integer, nullable=False)

    def toJson(self):
       return {c.name: getattr(self, c.name) for c in self.__table__.columns}
