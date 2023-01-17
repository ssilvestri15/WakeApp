import pickle

def analyze(filename):
    # load the saved model (after training)
    model = pickle.load(open("result/mlp_classifier.model", "rb"))
    result = model.predict_proba(filename)
    newResult = {}
    for k,v in result.items():
        match k:
            case 1.0:
                newResult["neutrale"] = v
            case 2.0:
                newResult["disgustato"] = v
            case 3.0:
                newResult["felice"] = v
            case 4.0:
                newResult["inpaurito"] = v
            case 5.0:
                newResult["arrabbiato"] = v
            case 6.0:
                newResult["sorpreso"] = v
            case 7.0:
                newResult["triste"] = v
            case _:
                print("NOT FOUND")
    return newResult

if __name__ == "__main__":
    print("result:", analyze("C:\\Users\\silve\\Downloads\\speech-emotion-recognition\\test.wav"))
    
