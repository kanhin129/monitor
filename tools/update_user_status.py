#!/usr/bin/python
# -*- coding: UTF-8 -*-

import sqlite3
import sys

pwd     = '$2b$12$/cRaMbRM0lgo6zyk.VLTcuI5uypaRToUn2tmBoZjahE8XbfXs9M62' #123456
db_path = '/root/matrix-riot-docker/files/homeserver.db'
def disable_user(status, name):


    print(name)

    conn = sqlite3.connect(db_path)
    c = conn.cursor()

    print ("Opened database successfully")

    if status =='off':
        print('off')
        update_sql="UPDATE users SET password_hash='' , deactivated=1 WHERE name='@{}:chat.chatkingking.com' ;".format(name)
        c.execute(update_sql)
        conn.commit()

    elif status =='on':
        print('on')
        update_sql="UPDATE users SET password_hash='{}' , deactivated=0 WHERE name='@{}:chat.chatkingking.com' ;".format(pwd, name)
        c.execute(update_sql)
        conn.commit()

    select_sql="SELECT name, password_hash, deactivated  FROM users WHERE name = '@{}:chat.chatkingking.com'; ".format(name)
    cursor = c.execute(select_sql)


    for row in cursor:
       print ("name = ", row[0])
       print ("password_hash = ", row[1])
       print ("deactivated", row[2])

    print ("Operation done successfully")
    conn.close()

if __name__ == "__main__":

    status = sys.argv[1]
    name   = sys.argv[2]
    disable_user(status, name)


