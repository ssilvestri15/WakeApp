INSERT_USER_RETURN_ID = "INSERT INTO utente (cf, email, password, telefono, nome, cognome, data_di_nascita, residenza, tipo) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s) RETURNING cf;"

CHECK_USER_EXIST_BY_EMAIL = "SELECT * FROM utente WHERE email=(%s);"

CHECK_USER_EXIST_BY_ID = "SELECT * FROM utente WHERE cf=(%s) EXECPT password;"

LOGIN = "SELECT email, password FROM utente WHERE email=(%s);"