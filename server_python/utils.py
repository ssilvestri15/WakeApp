from flask_jwt_extended import decode_token
from query import CHECK_USER_EXIST_BY_EMAIL
import base64
from moviepy.editor import *
from cryptography.fernet import Fernet
from flask_bcrypt import Bcrypt

ALLOWED_EXTENSIONS_VIDEO = set(['mp4', 'mov', 'avi', 'flv', 'mkv', 'webm'])
ALLOWED_EXTENSIONS_AUDIO = set(['m4a', 'flac', 'mp3', 'mp4', 'wav', 'wma', 'aac'])

def allowed_file_video(filename):
	return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS_VIDEO

def allowed_file_audio(filename):
	return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS_AUDIO

def verify_token_and_get_user(token: str, connection):

	if not isinstance(token, str):
		return False

	token = token.replace('Bearer ', '')

	try:
		email = decode_token(token)['sub']
		with connection:
			with connection.cursor() as cursor:
				cursor.execute(CHECK_USER_EXIST_BY_EMAIL, (email,))
				user = cursor.fetchall()

				if not user or len(user) != 1:
					return []

				return user[0]

	except Exception:
		return []

def validate_register_input(email, password, cf, telefono, nome, cognome, data_di_nascita, residenza):
	return True

def encrypt_file(key, filepath):
	try:
		fernet = Fernet(key)
		
		# opening the original file to encrypt
		with open(filepath, 'rb') as file:
			original = file.read()

		# encrypting the file
		encrypted = fernet.encrypt(original)
		file.close()
 
		# opening the file in write mode and
		# writing the encrypted data
		with open(filepath, 'wb') as encrypted_file:
			encrypted_file.write(encrypted)
		encrypted_file.close()

		return True	
	except Exception as e:
		print(e)
		return False

def decrypt_video(key, filepath):
	try:
		fernet = Fernet(key)
		
		# opening the encrypted file
		with open(filepath, 'rb') as enc_file:
			encrypted = enc_file.read()
 
		# decrypting the file
		decrypted = fernet.decrypt(encrypted)
 
		# opening the file in write mode and
		# writing the decrypted data
		with open(filepath, 'wb') as dec_file:
			dec_file.write(decrypted)
	except:
		return False		