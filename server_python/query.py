CREATE_USER_TABLE = "CREATE TABLE IF NOT EXISTS users (id SERIAL PRIMARY KEY, email TEXT, password TEXT, type integer);"

INSERT_USER_RETURN_ID = "INSERT INTO users (email, password, type) VALUES (%s, %s, %s) RETURNING id;"

CHECK_USER_EXIST_BY_EMAIL = "SELECT * FROM users WHERE email=(%s);"

CHECK_USER_EXIST_BY_ID = "SELECT * FROM users WHERE id=(%s);"

LOGIN = "SELECT * FROM users WHERE email=(%s);"