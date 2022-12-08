from flask_jwt_extended import decode_token
from query import CHECK_USER_EXIST_BY_EMAIL

ALLOWED_EXTENSIONS = set(['mp4', 'mov', 'avi', 'flv', 'mkv', 'webm'])

def allowed_file(filename):
	return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

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
