import cv2
import os
import models
from deepface import DeepFace
from time import monotonic
from pathlib import Path
from sqlalchemy.orm import sessionmaker
from threading import Thread
from utils import encrypt_file

_Session = sessionmaker(bind=models.engine)
session = _Session()


def remove_text_after_last_delimiter(s, delimiter):
    return s.rsplit(delimiter, 1)[0]

def createFinalDict(dict):

    emotions = ["fear", "surprise", "neutral", "sad", "happy", "disgust", "angry", "happy"]
    for emotion in emotions:
        if not emotion in dict:
            dict[emotion] = 0.0 

    return dict

def checkFace(filename):

    print("CONTROLLO VISO")

    try:

        file = os.path.basename(filename)
        base = file.split(".",1)[0]

        y = f"frames_{base}"
        z = os.path.join(remove_text_after_last_delimiter(filename, "/"), y)

        print(f"Main folder: {z}")

        try:
            if not os.path.exists(z):
                os.makedirs(z)
        except OSError as e:
            print(f"CARTELLA NULL: {e.strerror}")
            return False

        cam = cv2.VideoCapture(filename)
        ret,frame = cam.read()
        
        for n in range(0,3):
          ret,frame = cam.read()
        
        cam.release()
        if ret:
            name = os.path.join(z,"0.jpg")
            cv2.imwrite(name, frame)
            em = DeepFace.analyze(img_path = name, actions = ['emotion'])

            print(str(em))

            if em:
                print("VISO RILEVATO")
                return True
            else:
                print("EM NULL")
                return False
        else:
            print("RET NULL")
            return False
    except:
        print("ERRORE NULL")
        cam.release()
        return False
    
def rrmdir(path):
    for entry in os.scandir(path):
        if entry.is_dir():
            rrmdir(entry)
        else:
            os.remove(entry)
    os.rmdir(path)

def analyzeVideo(filename, idvideo, key_f):
    print("Start AI Video")

    try:
        start_time = monotonic()
        file = os.path.basename(filename)
        base = file.split(".",1)[0]

        y = f"frames_{base}"
        z = os.path.join(remove_text_after_last_delimiter(filename, "/"), y)

        try:
            if not os.path.exists(z):
                os.makedirs(z)
        except:
            print("Error folder")


        # Read the video from specified path
        cam = cv2.VideoCapture(filename)

        # frame
        currentframe = 0
        emo = dict()

        while(True):
      
            # reading from frame
            ret,frame = cam.read()
  
            if ret:
                # if video is still left continue creating images0
                name = os.path.join(z,f"{str(currentframe)}.jpg")
                print ('Creating...' + str(name))
  
                # writing the extracted images
                cv2.imwrite(name, frame)
  
                # increasing counter so that it will
                # show how many frames are created
                currentframe += 1

                em = DeepFace.analyze(img_path = name, actions = ['emotion'])

                y = em[0]['dominant_emotion']

                if y in emo:
                    emo[y] += 1
                else:
                    emo[y] = 1

            else:
                break
  
        # Release all space and windows once done
        cam.release()

        m = max(emo.values())

        for key in emo.keys():
            emo[key] = (emo[key]/m)


        emo = createFinalDict(emo)

        try:
            rrmdir(z)
        except:
            print("Error removing")

        print("AI Video completo")

        try:
            video = session.query(models.Video).filter(models.Video.idVideo == idvideo).first()
            video.emozioneIA = str(emo)
            video.status = "success"
            session.commit()
        except:
            video = session.query(models.Video).filter(models.Video.idVideo == idvideo).first()
            video.status = "error"
            session.commit()

        print("AI Video salvato")
        
        encrypt_file(key_f, filename)
        
        print("AI Video cryptato")
        print(f"TIME: {monotonic() - start_time}s")

    except:
        video = session.query(models.Video).filter(models.Video.idVideo == idvideo).first()
        session.delete(video)
        session.commit()
        rrmdir(filename)

def analyzeVideoThreaded(filename, idvideo, key):
    thread = Thread(target = analyzeVideo, args = (filename, idvideo, key))
    thread.daemon = True
    thread.start()
    thread.join()

if __name__ == "__main__":
    analyzeVideo('C:\\Users\\silve\\Downloads\\test.MOV')