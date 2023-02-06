import cv2
import os
from deepface import DeepFace
from time import monotonic
from pathlib import Path


def remove_text_after_last_delimiter(s, delimiter):
    return s.rsplit(delimiter, 1)[0]

def analyzeVideo(filename):

    start_time = monotonic()
    try:
      
        # creating a folder named data
        if not os.path.exists('data'):
            os.makedirs('data')
  
    # if not created then raise error
    except OSError:
        print ('Error: Creating directory of data')

    # Read the video from specified path
    cam = cv2.VideoCapture(filename)

    # frame
    currentframe = 0
    emo = dict()

    p = Path(filename)
    p.parents[0].mkdir(parents=True, exist_ok=True)

    while(True):
      
        # reading from frame
        ret,frame = cam.read()
  
        if ret:
            # if video is still left continue creating images0
            name = Path(p,f"/frames/{str(currentframe)}.jpg")
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

    print(emo)

    print(f"TIME: {monotonic() - start_time}s")
    return emo

if __name__ == "__main__":
    analyzeVideo('C:\\Users\\silve\\Downloads\\test.MOV')