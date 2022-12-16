from moviepy.editor import *
from cryptography.fernet import Fernet

def compress_and_encrypt_video(idutente, filepath):

    video = VideoFileClip(filepath)

    # getting width and height of video 1
    width_of_video1 = video.w
    height_of_video1 = video.h
    print("Width and Height of original video : ", end=" ")
    print(str(width_of_video1) + " x ", str(height_of_video1))
    print("#################################")

	# resizing....
    video_resized = video.resize(0.7)

	# getting width and height of video 2 which is resized
    width_of_video2 = video_resized.w
    height_of_video2 = video_resized.h
    
    print("Width and Height of resized video : ", end=" ")
    print(str(width_of_video2) + " x ", str(width_of_video2))
    
    print("###################################")
    video_resized.write_videofile(filepath,threads=8)
    print("###################################")
	
    #displaying final clip
    fernet = Fernet(idutente)
    video_resized.close()
    video.close()
 
	# opening the original file to encrypt
    with open(filepath, 'rb') as file:
        original = file.read()
     
	# encrypting the file
    encrypted = fernet.encrypt(original)
 
	# opening the file in write mode and
	# writing the encrypted data
    with open(filepath, 'wb') as encrypted_file:
        encrypted_file.write(encrypted)


def decrypt_video(idutente, filepath):
		fernet = Fernet(idutente)
		
		# opening the encrypted file
		with open(filepath, 'rb') as enc_file:
			encrypted = enc_file.read()
 
		# decrypting the file
		decrypted = fernet.decrypt(encrypted)
 
		# opening the file in write mode and
		# writing the decrypted data
		with open(filepath, 'wb') as dec_file:
			dec_file.write(decrypted)

if __name__ == '__main__':
    compress_and_encrypt_video('ZmDfcTF7_60GrrY167zsiPd67pEvs0aGOv2oasOM1Pg=',"C:\\Users\\silve\\Downloads\\Rick Astley - Never Gonna Give You Up (Official Music Video).mp4")