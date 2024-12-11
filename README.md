<h3>This project aims to track objects in small closed areas where GPS is not availabe</h3>
<h3>This project installs ESP32 on wheelchairs and arduinos in many locations. The ESP connects via bluetooth to the closest arduino.</h3>
<b>
Technologies used:<br>
-Flutter<br>
-Python for backend<br>
-Arduino nano and RF 433<br>
-SQLite for database<br>
</b>
<br>
The link between flutter and python is throught post requests from flutter and flask api in python <br>
The link between ESP32 and python is throught post requests from ESP and flask api in python <br>
The link between ESP32 and arduino is via bluetooth.<br>
<br>
<h3>How the app works...</h3>
ESP is attached to wheelchair.<br>
Arduino devices are installed in different halls.<br>
Each arduino is named with the same name as the hall for simplicity.<br>
ESP Connects to closest arduino.<br>
ESP sends the name of the arduino to Python API server, Python stores the location in a SQLite database.<br>
User logs in using flutter and requests a chair.<br>
Employee logs in using flutter and accesps requests or retrieves chairs.<br>
<br><br>
Below are screen shots of the app<br><br>
<img src="https://github.com/ahmed0tolba/wheelchair_tracker/blob/main/screenshots/Screenshot_2.png" width="300" />
<img src="https://github.com/ahmed0tolba/wheelchair_tracker/blob/main/screenshots/Screenshot_3.png" width="300" />
<img src="https://github.com/ahmed0tolba/wheelchair_tracker/blob/main/screenshots/Screenshot_4.png" width="300" />
<img src="https://github.com/ahmed0tolba/wheelchair_tracker/blob/main/screenshots/Screenshot_5.png" width="300" />
<img src="https://github.com/ahmed0tolba/wheelchair_tracker/blob/main/screenshots/Screenshot_6.png" width="300" />
<img src="https://github.com/ahmed0tolba/wheelchair_tracker/blob/main/screenshots/Screenshot_7.png" width="300" />
<img src="https://github.com/ahmed0tolba/wheelchair_tracker/blob/main/screenshots/Screenshot_9.png" width="300" />

