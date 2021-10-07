import pymysql
import os
from flask import Flask, jsonify
from flaskext.mysql import MySQL

app = Flask(__name__)

mysql = MySQL()

# MySQL configurations
app.config['MYSQL_DATABASE_USER'] = os.environ['MYSQL_DATABASE_USER']
app.config['MYSQL_DATABASE_PASSWORD'] = os.environ['MYSQL_DATABASE_PASSWORD']
app.config['MYSQL_DATABASE_DB'] = os.environ['MYSQL_DATABASE_DB']
app.config['MYSQL_DATABASE_HOST'] = os.environ['MYSQL_DATABASE_HOST']
mysql.init_app(app)


table = os.environ['TABLE']
columns = os.environ['COLUMNS']


@app.route("/")
def main():
    cursor = None
    conn = None

    try:
        conn = mysql.connect()
        cursor = conn.cursor(pymysql.cursors.DictCursor)
        print(table)
        cursor.execute("SELECT " + columns + " FROM "+table)
        rows = cursor.fetchall()
        resp = jsonify(rows)
        resp.status_code = 200
        return resp

    finally:
        if cursor != None:
            cursor.close()
            conn.close()
    return "Failed"


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8081)
