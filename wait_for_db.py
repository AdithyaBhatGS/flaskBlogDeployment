import os
import time
import pymysql

host = os.getenv("DB_HOST", "mysql")
user = os.getenv("DB_USER", "root")
password = os.getenv("DB_PASSWORD")
db = os.getenv("DB_NAME")
port = int(os.getenv("DB_PORT", 3306))

while True:
    try:
        conn = pymysql.connect(
            host=host,
            user=user,
            password=password,
            database=db,
            port=port
        )
        conn.close()
        break
    except Exception as e:
        print("Waiting for MySQL...", e)
        time.sleep(2)

print("MySQL is ready!")

