from fer import Video
from fer import FER

def analyzeVideo(filename):
    video = Video(filename)

    # Analyze video, displaying the output
    detector = FER(mtcnn=True)
    raw_data = video.analyze(detector,
                             display=False,
                             save_frames=False,
                             save_video=False,
                             annotate_frames=False,
                             zip_images=False)
    df = video.to_pandas(raw_data)
    df = video.get_first_face(df)
    vid_df = video.get_emotions(df)

    angry = sum(vid_df.angry)
    disgust = sum(vid_df.disgust)
    fear = sum(vid_df.fear)
    happy = sum(vid_df.happy)
    sad = sum(vid_df.sad)
    surprise = sum(vid_df.surprise)
    neutral = sum(vid_df.neutral)
    emotions = ['arrabbiato', 'disgustato', 'impaurito', 'felice', 'triste', 'sorpreso', 'neutrale']
    emotions_values = [angry, disgust, fear, happy, sad, surprise, neutral]
    topEmotion = max(emotions_values)
    index = emotions_values.index(topEmotion)
    print(index)
    print(emotions[index])
    print(topEmotion)
    return topEmotion

if __name__ == "__main__":
    analyzeVideo('C:\\Users\\silve\\Downloads\\test.MOV')