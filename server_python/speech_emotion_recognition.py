import pickle

def analyze(filename):
    # load the saved model (after training)
    model = pickle.load(open("result/mlp_classifier.model", "rb"))
    result = model.predict_proba(filename)
    newResult = {}
    for k,v in result.items():
        match k:
            case 1.0:
                newResult["neutral"] = v
            case 2.0:
                newResult["disgust"] = v
            case 3.0:
                newResult["happy"] = v
            case 4.0:
                newResult["fear"] = v
            case 5.0:
                newResult["angry"] = v
            case 6.0:
                newResult["surprise"] = v
            case 7.0:
                newResult["sad"] = v
            case _:
                print("NOT FOUND")
    return newResult

if __name__ == "__main__":
    print("result:", analyze("C:\\Users\\silve\\Downloads\\speech-emotion-recognition\\test.wav"))
    
