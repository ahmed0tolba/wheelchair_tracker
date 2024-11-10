from flask import Flask, request, jsonify  # pip install asasdasd
import sqlite3 # pip install asdasdasd
import os
from flask import jsonify  # pip install asdasdasd
from datetime import datetime

app = Flask(__name__)
basedir = os.path.abspath(os.path.dirname(__file__))

# database 
databasename = '_database.db'
emplyees_table = 'emplyees_table'
passengers_table = 'passengers_table'
chairs_table = 'chairs_table'
nanos_table = 'nanos_table'
locations_table = 'locations_table'

try: # create database and tables if not exist
  print(f'Checking if {databasename} exists or not...')
  conn = sqlite3.connect(databasename, uri=True)
  print(f'Database exists. Succesfully connected to {databasename}')
  conn.execute('CREATE TABLE IF NOT EXISTS ' + emplyees_table + ' (id INTEGER PRIMARY KEY AUTOINCREMENT,fullname TEXT ,nationality TEXT,gender TEXT,birthday TEXT,ssn TEXT,employeeid TEXT ,email TEXT UNIQUE NOT NULL,password TEXT NOT NULL,status TEXT default "free",gotopassengeremail TEXT)') # status : free , occupied
  conn.execute('CREATE TABLE IF NOT EXISTS ' + passengers_table + ' (id INTEGER PRIMARY KEY AUTOINCREMENT,fullname TEXT ,nationality TEXT,gender TEXT,birthday TEXT,ssn TEXT,email TEXT UNIQUE NOT NULL,password TEXT NOT NULL,status TEXT,needchair boolean default False ,location TEXT default "",haschair boolean default False, requiredservice TEXT,chairgoing boolean default False,employeehelping TEXT,appointmenttime TEXT)')
#   id ,fullname ,nationality,gender ,birthday ,ssn ,email ,password ,status,needchair ,location,haschair, requiredservice ,chairgoing ,employeehelping 
  conn.execute('CREATE TABLE IF NOT EXISTS ' + chairs_table + ' (id INTEGER PRIMARY KEY AUTOINCREMENT,espname TEXT UNIQUE NOT NULL,location TEXT,lastlocationtime TEXT,status TEXT default "free",passengeremail TEXT,employeeemail TEXT)') # status : free , going, occupied,returning
  conn.execute('CREATE TABLE IF NOT EXISTS ' + nanos_table + ' (id INTEGER PRIMARY KEY AUTOINCREMENT,nanoname TEXT UNIQUE NOT NULL,lastlocationtime TEXT,status TEXT)')
  conn.execute('CREATE TABLE IF NOT EXISTS ' + locations_table + ' (id INTEGER PRIMARY KEY AUTOINCREMENT,location TEXT UNIQUE NOT NULL,chaircount INTEGER default 0,status TEXT)')
  print(f'Succesfully Created Tables')
except sqlite3.OperationalError as err:
  print('Database error,see log')
  print(err)

# create admin if not exist
connt = sqlite3.connect(databasename, uri=True)
curt = connt.cursor()
curt.execute('select * from '+ emplyees_table )
records = curt.fetchall()
if len(records)==0:
    conn = sqlite3.connect(databasename, uri=True)
    cur = conn.cursor()
    sqlite_insert_query = 'INSERT INTO '+ emplyees_table +' (fullname,email,password,employeeid) VALUES (?,?,?,?);'
    data_tuple = ("mona","mona@a.a","1234","12345678")
    cur.execute(sqlite_insert_query,data_tuple)
    conn.commit()
    sqlite_insert_query = 'INSERT INTO '+ emplyees_table +' (fullname,email,password) VALUES (?,?,?);'
    data_tuple = ("noha","noha@a.a","1234")
    cur.execute(sqlite_insert_query,data_tuple)
    conn.commit()

curt.execute('select * from '+ passengers_table )
records = curt.fetchall()
if len(records)==0:
    conn = sqlite3.connect(databasename, uri=True)
    cur = conn.cursor()
    sqlite_insert_query = 'INSERT INTO '+ passengers_table +' (fullname,email,password) VALUES (?,?,?);'
    data_tuple = ("ahmed","ahmed@a.a","1234")
    cur.execute(sqlite_insert_query,data_tuple)
    conn.commit()
    sqlite_insert_query = 'INSERT INTO '+ passengers_table +' (fullname,email,password,needchair,requiredservice,location,appointmenttime) VALUES (?,?,?,?,?,?,?);'
    data_tuple = ("ali","ali@a.a","1234",True,"rampwheelchair","halltest2",datetime.now())
    cur.execute(sqlite_insert_query,data_tuple)
    conn.commit()
    sqlite_insert_query = 'INSERT INTO '+ passengers_table +' (fullname,email,password,needchair,requiredservice,location,appointmenttime) VALUES (?,?,?,?,?,?,?);'
    data_tuple = ("mazen","mazen@a.a","1234",True,"stairswheelchair","halltest1",datetime.now())
    cur.execute(sqlite_insert_query,data_tuple)
    conn.commit()

curt.execute('select * from '+ chairs_table )
records = curt.fetchall()
if len(records)==0:
    conn = sqlite3.connect(databasename, uri=True)
    cur = conn.cursor()
    sqlite_insert_query = 'INSERT INTO '+ chairs_table +' (espname,location) VALUES (?,?);'
    data_tuple = ("esptest1","halltest1")
    cur.execute(sqlite_insert_query,data_tuple)
    conn.commit()
    sqlite_insert_query = 'INSERT INTO '+ chairs_table +' (espname,location) VALUES (?,?);'
    data_tuple = ("esptest2","halltest2")
    cur.execute(sqlite_insert_query,data_tuple)
    conn.commit()

curt.execute('select * from '+ locations_table )
records = curt.fetchall()
if len(records)==0:
    conn = sqlite3.connect(databasename, uri=True)
    cur = conn.cursor()
    sqlite_insert_query = 'INSERT INTO '+ locations_table +' (location) VALUES (?);'
    data_tuple = ("halltest1",)
    cur.execute(sqlite_insert_query,data_tuple)
    conn.commit()
    sqlite_insert_query = 'INSERT INTO '+ locations_table +' (location) VALUES (?);'
    data_tuple = ("halltest2",)
    cur.execute(sqlite_insert_query,data_tuple)
    conn.commit()
    sqlite_insert_query = 'INSERT INTO '+ locations_table +' (location) VALUES (?);'
    data_tuple = ("terminal1test1",)
    cur.execute(sqlite_insert_query,data_tuple)
    conn.commit()
    sqlite_insert_query = 'INSERT INTO '+ locations_table +' (location) VALUES (?);'
    data_tuple = ("entrancetest1",)
    cur.execute(sqlite_insert_query,data_tuple)
    conn.commit()
connt.close()    
conn.close()

@app.route('/', methods=['GET'])
def home():
    return "Server is running"

@app.route('/login', methods=['POST'])
def login():
    print("login")
    resp = jsonify(success=False)
    success=False
    email = ""
    usertype = ""
    username = ""
    employeeid = ""
    if request.method == 'POST':
        print("post")
        # print(request.args)
        email = request.args.get('email')  #request.json['username']
        password = request.args.get('password')
        con = sqlite3.connect(databasename, uri=True)
        cur2 = con.cursor()
        cur2.execute('select * from '+ emplyees_table +' where email = ? and password = ? ', (email,password,))
        records = cur2.fetchall()
        if len(records)>0:
            username = records[0][1]
            employeeid = records[0][6]
            success=True
            email = email
            usertype = "employee"
        else:
            cur2 = con.cursor()
            cur2.execute('select * from '+ passengers_table +' where email = ? and password = ? ', (email,password,))
            records = cur2.fetchall()
            if len(records)>0:
                username = records[0][1]
                success=True
                email = email
                usertype = "passenger"
        
        cur2.close()
        con.close()



    resp = jsonify(success=success,email = email,usertype=usertype,username=username,employeeid=employeeid)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

@app.route('/addemployee', methods=['POST'])
def addemployee():
    print("addemployee")
    success = False
    message = ""
    status = 0 
    if request.method == 'POST':
        print("post") 
        if not "fullname" in request.args:
            message = "Invalid full name"
            status = -10 
        if not "nationality" in request.args:
            message = "Invalid nationality"
            status = -11 
        if not "gender" in request.args:
            message = "Invalid Gender"
            status = -12 
        if not "birthday" in request.args:
            message = "Invalid birthday"
            status = -13 
        if not "ssn" in request.args:
            message = "Invalid ssn"
            status = -14 
        if not "employeeID" in request.args:
            message = "Invalid Employee ID"
            status = -15 
        if not "email" in request.args:
            message = "Invalid email"
            status = -16 
        if not "password" in request.args:
            message = "Invalid password"
            status = -17 


        if status == 0: # all inputs are valid
            fullname = request.args.get('fullname')
            nationality = request.args.get('nationality')
            gender = request.args.get('gender')
            birthday = request.args.get('birthday')
            ssn = request.args.get('ssn')
            employeeID = request.args.get('employeeID')
            email = request.args.get('email')
            password = request.args.get('password')
            if fullname == "" or len(fullname) < 3: 
                message = "Invalid fullname" 
                status = -20
            if nationality == "" or len(nationality) < 3 or nationality == "null":
                message = "Invalid nationality"
                status = -21 
            if  gender == "" or len(gender) < 3 or gender == "null":
                message = "Invalid gender"
                status = -22 
            if  birthday == "" or len(birthday) < 3:
                message = "Invalid birthday"
                status = -23 
            if  ssn == "" or len(ssn) < 3 or not ssn.isdigit():
                message = "Invalid ssn"
                status = -24
            if  employeeID == "" or len(employeeID) < 3 or not employeeID.isdigit():
                message = "Invalid employeeID"
                status = -25 
            if  email == "" or len(email) < 3 or email.find('@')<0 or email.find('.')<0 :
                message = "Invalid email"
                status = -24 
            if  password == "" or len(password) < 3:
                message = "Invalid password"
                status = -27 
            if status == 0:
                con = sqlite3.connect(databasename, uri=True)
                cur2 = con.cursor() # id fullname,nationality,gender,birthday,ssn,employeeid,email,password 
                cur2.execute('select * from '+ emplyees_table +' where email = ? or ssn = ? or employeeid = ? ', (email,ssn,employeeID,))
                records = cur2.fetchall()
                if len(records) > 0: # one paramiter unduplicable already exists 
                    message = "Duplicated entery"
                    status = -1
                    
                    for row in records:
                        # print(row)
                        if row[7] == email:
                            message = "Duplicated Email"
                            status = -2
                        if row[5] == ssn:
                            message = "Duplicated ssn"
                            status = -3
                        if row[6] == employeeID:
                            message = "Duplicated employeeID"
                            status = -4
                        break
                else: # store employee
                    cur2.execute('INSERT INTO ' + emplyees_table + ' (fullname,nationality,gender,birthday,ssn,employeeid,email,password) VALUES (?,?,?,?,?,?,?,?) ', (fullname,nationality,gender,birthday,ssn,employeeID,email,password,))
                    con.commit()
                    success = True
                    status = 1
                cur2.close()
                con.close()        
    resp = jsonify(success = success , message = message , status = status)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

@app.route('/addpassenger', methods=['POST'])
def addpassenger():
    print("addpassenger")
    success = False
    message = ""
    status = 0 
    if request.method == 'POST':
        print("post") 
        if not "fullname" in request.args:
            message = "Invalid full name"
            status = -10 
        if not "nationality" in request.args:
            message = "Invalid nationality"
            status = -11 
        if not "gender" in request.args:
            message = "Invalid Gender"
            status = -12 
        if not "birthday" in request.args:
            message = "Invalid birthday"
            status = -13 
        if not "ssn" in request.args:
            message = "Invalid ssn"
            status = -14 
        if not "email" in request.args:
            message = "Invalid email"
            status = -16 
        if not "password" in request.args:
            message = "Invalid password"
            status = -17 


        if status == 0: # all inputs are valid
            fullname = request.args.get('fullname')
            nationality = request.args.get('nationality')
            gender = request.args.get('gender')
            birthday = request.args.get('birthday')
            ssn = request.args.get('ssn')
            email = request.args.get('email')
            password = request.args.get('password')
            if fullname == "" or len(fullname) < 3: 
                message = "Invalid fullname" 
                status = -20
            if nationality == "" or len(nationality) < 3 or nationality == "null":
                message = "Invalid nationality"
                status = -21 
            if  gender == "" or len(gender) < 3 or gender == "null":
                message = "Invalid gender"
                status = -22 
            if  birthday == "" or len(birthday) < 3:
                message = "Invalid birthday"
                status = -23 
            if  ssn == "" or len(ssn) < 3 or not ssn.isdigit():
                message = "Invalid ssn"
                status = -24
            if  email == "" or len(email) < 3 or email.find('@')<0 or email.find('.')<0 :
                message = "Invalid email"
                status = -24 
            if  password == "" or len(password) < 3:
                message = "Invalid password"
                status = -27 
            if status == 0:
                con = sqlite3.connect(databasename, uri=True)
                cur2 = con.cursor() # id fullname,nationality,gender,birthday,ssn,employeeid,email,password 
                cur2.execute('select * from '+ passengers_table +' where email = ? or ssn = ? ', (email,ssn,))
                records = cur2.fetchall()
                if len(records) > 0: # one paramiter unduplicable already exists 
                    message = "Duplicated entery"
                    status = -1
                    
                    for row in records:
                        # print(row)
                        if row[7] == email:
                            message = "Duplicated Email"
                            status = -2
                        if row[5] == ssn:
                            message = "Duplicated ssn"
                            status = -3
                        break
                else: # store employee
                    cur2.execute('INSERT INTO ' + passengers_table + ' (fullname,nationality,gender,birthday,ssn,email,password) VALUES (?,?,?,?,?,?,?) ', (fullname,nationality,gender,birthday,ssn,email,password,))
                    con.commit()
                    success = True
                    status = 1
                cur2.close()
                con.close()        
    resp = jsonify(success = success , message = message , status = status)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

@app.route('/createrequest', methods=['POST'])
def createrequest():
    print("createrequest")
    success = False
    message = ""
    status = 0 
    if request.method == 'POST':
        print("post") 
        if not "email" in request.args:
            message = "Invalid email"
            status = -10 
        if not "location" in request.args:
            message = "Invalid location"
            status = -11 
        if not "requiredservice" in request.args:
            message = "Invalid required service"
            status = -12
        if not "appointmenttime" in request.args:
            message = "Invalid appointment time"
            status = -13
        
        if status == 0: # all inputs are valid
            email = request.args.get('email')
            location = request.args.get('location')
            requiredservice = request.args.get('requiredservice')
            appointmenttime = request.args.get('appointmenttime')
            con = sqlite3.connect(databasename, uri=True)
            cur2 = con.cursor() # needchair  ,location ,haschair
            cur2.execute('UPDATE ' + passengers_table + ' SET needchair = ? , location = ? , haschair = ? , requiredservice = ? , appointmenttime = ? WHERE email = ? ', (True,location,False,requiredservice,appointmenttime,email,))

            con.commit()
            success = True
            status = 1
            cur2.close()
            con.close()        
    resp = jsonify(success = success , message = message , status = status)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp



@app.route('/updateesplocation', methods=['GET','POST'])
def updateesplocation():
    print("updateesplocation")
    success = False
    message = ""
    status = 0 
    # if request.method == 'POST':
    print("post update esp location") 

    espname = request.args.get('espid')
    nanoname = request.args.get('nanoid')
    
    
    con = sqlite3.connect(databasename, uri=True)
    
    cur2 = con.cursor() 
    cur2.execute('select * from '+ chairs_table +' where espname = ? ', (espname,))
    records = cur2.fetchall()
    if len(records) == 0: 
        cur2.execute('INSERT INTO ' + chairs_table + ' (espname) VALUES (?) ', (espname,))
        con.commit()
    
    cur2.execute('select * from '+ nanos_table +' where nanoname = ? ', (nanoname,))
    records = cur2.fetchall()
    if len(records) == 0: 
        cur2.execute('INSERT INTO ' + nanos_table + ' (nanoname) VALUES (?) ', (nanoname,))
        con.commit()
    
    cur2.execute('select * from '+ locations_table +' where location = ? ', (nanoname,))
    records = cur2.fetchall()
    if len(records) == 0: 
        cur2.execute('INSERT INTO ' + locations_table + ' (location) VALUES (?) ', (nanoname,))
        con.commit()

    cur2.execute('UPDATE ' + chairs_table + ' SET location = ? , lastlocationtime = ? WHERE espname = ? ', (nanoname,datetime.now().strftime("%H:%M:%S"),espname,))
    con.commit()
    
    success = True
    status = 1
    cur2.close()
    con.close()        

    resp = jsonify(success = success , message = message , status = status)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

# id ,espname ,location ,lastlocationtime ,status ,passengeremail 
@app.route('/listchairsdata', methods=['GET','POST'])
def listchairsdata():
    espsnames = []
    espslocations = []
    espslastlocationstimes = []
    espsstatuss = []
    espspassengeremail = []

    con = sqlite3.connect(databasename, uri=True)
    cur2 = con.cursor()
    if request.method == 'POST':        
        print("listchairsdata POST")        
        cur2.execute('select * from '+ chairs_table)

        records = cur2.fetchall()
        for row in records:
            espsnames.append(str(row[1]))
            espslocations.append(row[2])
            espslastlocationstimes.append(row[3])
            espsstatuss.append(row[4])
            espspassengeremail.append(str(row[5]))

    cur2.close()
    con.close()

    print(espsnames,espslocations,espslastlocationstimes,espsstatuss,espspassengeremail)
    resp = jsonify(espsnames = espsnames , espslocations = espslocations, espslastlocationstimes = espslastlocationstimes , espsstatuss = espsstatuss, espspassengeremail =espspassengeremail)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

# id ,espname ,location ,lastlocationtime ,status ,passengeremail 
@app.route('/listrequests', methods=['GET','POST'])
def listrequests():
    # id ,fullname ,nationality ,gender ,birthday ,ssn ,email ,password ,status ,needchair False ,location  ,haschair False, requiredservice ,chairgoing
    fullnames = []
    genders = []
    locations = []
    requiredservices = []
    chairsgoing = []
    emails = []
    appointmenttimes = []
    employeeisfree = True
    gotopassengeremail = ""
    email = request.args.get('email')
    con = sqlite3.connect(databasename, uri=True)
    cur2 = con.cursor()
    if request.method == 'POST':        
        print("listrequests POST")        
        cur2.execute('select * from '+ passengers_table + ' WHERE needchair = ?', (True,))
        records = cur2.fetchall()
        for row in records:
            if row[1]:
                fullnames.append(row[1])
            else:
                fullnames.append("")
            if row[3]:
                genders.append(row[3])
            else:
                genders.append("")            
            if row[6]:
                emails.append(row[6])
            else:
                emails.append("")
            if row[10]:
                locations.append(row[10])
            else:
                locations.append("")
            if row[12]:
                requiredservices.append(row[12])
            else:
                requiredservices.append("")
            if row[13]:
                chairsgoing.append(row[13])
            else:
                chairsgoing.append("")
            if row[15]:
                appointmenttimes.append(row[15])
            else:
                appointmenttimes.append("")

        cur2.execute('select * from '+ emplyees_table + ' WHERE email = ?', (email,))
        records = cur2.fetchall()
        for row in records:
            if row[9] != "free":
                employeeisfree = False
                gotopassengeremail = row[10]

    cur2.close()
    con.close()

    print(fullnames,genders,emails,locations,requiredservices,chairsgoing,employeeisfree)
    resp = jsonify(fullnames = fullnames , genders = genders, emails = emails , locations = locations , requiredservices = requiredservices,chairsgoing = chairsgoing,employeeisfree=employeeisfree,gotopassengeremail=gotopassengeremail , appointmenttimes = appointmenttimes)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp


@app.route('/iwilldotask', methods=['POST'])
def iwilldotask():
    success = False
    message = ""
    status = 0 
    if request.method == 'POST':
        employeeemail = request.args.get('employeeemail')
        passengeremail = request.args.get('passengeremail')
        seatname = request.args.get('seatname')
        con = sqlite3.connect(databasename, uri=True)
        cur2 = con.cursor()
        cur2.execute('UPDATE ' + emplyees_table + ' SET status = ? , gotopassengeremail = ? WHERE email = ? ', ("occupied",passengeremail,employeeemail,))
        con.commit()
        cur2.execute('UPDATE ' + passengers_table + ' SET chairgoing = ? , employeehelping = ? WHERE email = ? ', (True,employeeemail,passengeremail,))
        con.commit()
        cur2.execute('UPDATE ' + chairs_table + ' SET status = ? , passengeremail = ? , employeeemail =? WHERE espname = ? ', ("occupied",passengeremail,employeeemail,seatname,))
        con.commit()
        
        cur2.close()
        con.close()
        success = True
        status = 1
    
    resp = jsonify(success = success , message = message , status = status)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

@app.route('/finishtask', methods=['POST'])
def finishtask():
    success = False
    message = ""
    status = 0 
    if request.method == 'POST':
        employeeemail = request.args.get('employeeemail')
        con = sqlite3.connect(databasename, uri=True)
        cur2 = con.cursor()
        cur2.execute('select email from '+ passengers_table + ' where employeehelping = ? ', (employeeemail,))
        records = cur2.fetchall()
        passengeremail = records[0][0]
        cur2.execute('select espname from '+ chairs_table + ' where employeeemail = ? ', (employeeemail,))
        records = cur2.fetchall()
        seatname = records[0][0]


        cur2.execute('UPDATE ' + emplyees_table + ' SET status = ?, gotopassengeremail = ? WHERE email = ? ', ("free","",employeeemail,))
        con.commit()
        cur2.execute('UPDATE ' + passengers_table + ' SET needchair = ?,haschair = ?, requiredservice = ?,chairgoing = ?,employeehelping = ? WHERE email = ? ', (False,False,"",False,"",passengeremail,))
        con.commit()
        cur2.execute('UPDATE ' + chairs_table + ' SET status = ? , passengeremail = ? , employeeemail =? WHERE espname = ? ', ("free","","",seatname,))
        con.commit()
        
        cur2.close()
        con.close()
        success = True
        status = 1
    
    resp = jsonify(success = success , message = message , status = status)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

@app.route('/listlocations', methods=['GET'])
def listlocations():
    locations_list=[]
    con = sqlite3.connect(databasename, uri=True)
    cur2 = con.cursor()
    cur2.execute('select * from '+ locations_table)
    records = cur2.fetchall()
    for row in records:
        locations_list.append(row[1])
    cur2.close()
    con.close()
    resp = jsonify(locations_list = locations_list)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

@app.route('/loadavailabledevicesnames', methods=['GET'])
def loadavailabledevicesnames():
    availabledevicesnames=[]
    con = sqlite3.connect(databasename, uri=True)
    cur2 = con.cursor()
    cur2.execute('select * from '+ chairs_table + ' where status = ? ',("free",))
    records = cur2.fetchall()
    for row in records:
        availabledevicesnames.append(row[1])
    cur2.close()
    con.close()
    resp = jsonify(availabledevicesnames = availabledevicesnames)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

#   id ,fullname ,nationality,gender ,birthday ,ssn ,email ,password ,status,needchair ,location,haschair, requiredservice ,chairgoing ,employeehelping 
@app.route('/loadpassengerdata', methods=['GET'])
def loadpassengerdata():
    print("loadpassengerdata")
    fullname = ""
    nationality = ""
    gender = "" 
    birthday = "" 
    ssn = "" 
    email = "" 
    password = ""
    status = ""
    needchair = False 
    location = ""
    haschair = False
    requiredservice = "" 
    chairgoing = False 
    employeehelping = ""
    email = request.args.get('email')
    con = sqlite3.connect(databasename, uri=True)
    cur2 = con.cursor()
    cur2.execute('select * from '+ passengers_table + ' where email = ? ',(email,))
    records = cur2.fetchall()
    fullname = records[0][1]
    nationality = records[0][2]
    gender = records[0][3] 
    birthday = records[0][4] 
    ssn = records[0][5] 
    email = records[0][6] 
    password = records[0][7]
    status = records[0][8]
    needchair = records[0][9]
    location = records[0][10]
    haschair = records[0][11]
    requiredservice = records[0][12] 
    chairgoing = records[0][13]
    employeehelping = records[0][14]

    cur2.close()
    con.close()
    resp = jsonify(fullname =fullname,nationality=nationality,gender =gender,birthday =birthday,ssn =ssn,email =email,password =password,status=status,needchair =needchair,location=location,haschair=haschair, requiredservice =requiredservice,chairgoing=chairgoing ,employeehelping=employeehelping )
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp




if __name__ == '__main__':
    app.run(debug=True,port=12000,use_reloader=False,host='0.0.0.0')

# GET http://127.0.0.1:12000/updateesplocation?espid=1&nanoid=1
# GET 127.0.0.1:12000/updateesplocation?espid=1&nanoid=1