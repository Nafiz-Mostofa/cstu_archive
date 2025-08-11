# cstu_archive

CSTU Archive — Setup Guide
This project is built using Flutter (frontend) and PHP/MySQL (backend).
The Flutter code is inside the lib/ folder, and the PHP API scripts are inside the api/ folder.

1) Requirements
Flutter SDK (stable channel)

Android Studio or VS Code with Android SDK

PHP 7.4+ and MySQL/MariaDB
(Windows: XAMPP/WAMP, macOS: MAMP, Linux: LAMP)

2) Clone and Install Dependencies
bash
Copy
Edit
git clone https://github.com/Nafiz-Mostofa/cstu_archive.git
cd cstu_archive
flutter pub get
3) Database Setup
Create a MySQL database named flutter_auth.

Create the required tables (or import them if you have a .sql file):

students table example:

pgsql
Copy
Edit
student_id (PK)  VARCHAR
student_name     VARCHAR
username         VARCHAR NULL
email            VARCHAR NULL
password         VARCHAR NULL
gp               DECIMAL
semester_credit  DECIMAL
total_credit     DECIMAL
gpa              DECIMAL
cgpa             DECIMAL
failed_subjects  INT
subjects_to_register TEXT
adminpanel table:

pgsql
Copy
Edit
id (PK)      INT AI
email        VARCHAR UNIQUE
username     VARCHAR NULL
password     VARCHAR NULL
phone        VARCHAR NULL
Insert the three allowed admin emails first (leave username, password, and phone as NULL):

graphql
Copy
Edit
cstuadmin1@gmail.com
cstuadmin2@gmail.com
cstuadmin3@gmail.com
Note: Make sure the email addresses are correct.

4) PHP API Configuration
Edit api/db_connect.php to match your local database connection:

php
Copy
Edit
<?php
$host = "127.0.0.1";   // or localhost
$user = "root";        // your MySQL username
$pass = "";            // your MySQL password
$db   = "flutter_auth";

$conn = new mysqli($host, $user, $pass, $db);
if ($conn->connect_error) {
  http_response_code(500);
  die(json_encode(["success"=>false,"message"=>"DB connection failed"]));
}
header('Content-Type: application/json');
?>
Make sure your Apache/PHP server is running, so you can access the API at http://localhost/api/.

5) Set the Base API URL in Flutter
Edit lib/services/auth_service.dart and lib/services/admin_auth_service.dart and update the baseUrl:

Android Emulator:

arduino
Copy
Edit
http://10.0.2.2/api/
iOS Simulator:

arduino
Copy
Edit
http://127.0.0.1:8080/api/
Physical Phone (on the same Wi-Fi/LAN):

perl
Copy
Edit
http://<YOUR_PC_LAN_IP>/api/
Example: http://192.168.0.105/api/

To find your PC's IP:
Windows: ipconfig → check IPv4 under Wi-Fi/Ethernet
macOS/Linux: ifconfig or ip a

6) Allow HTTP in Android (Cleartext Traffic)
If you use HTTP instead of HTTPS, add this inside the <application> tag in android/app/src/main/AndroidManifest.xml:

xml
Copy
Edit
android:usesCleartextTraffic="true"
7) Run the Project
bash
Copy
Edit
flutter run
To run on a specific device:

bash
Copy
Edit
flutter devices
flutter run -d emulator-5554
8) Login & Signup Flow (Summary)
Student Signup: Requires a valid student_id. Once registered, the same ID cannot be used again.

Student Login: Uses username + password.

Forgot Password (Student): Verifies student_id + username before allowing password reset.

Admin Signup: Only works for pre-added emails in the adminpanel table. Can register once only.

Admin Login: Uses username + password.

Admin Forgot Password: Verifies email + username before allowing password reset.

9) Common Issues & Solutions
Problem: API not reachable from phone
Solution:

Ensure phone & PC are on the same network.

Use your PC’s LAN IP in baseUrl.

Check if firewall/antivirus is blocking Apache/PHP.

Problem: ERR_CONNECTION_TIMED_OUT
Solution:

Check Apache/PHP is running.

Open http://localhost/api/get_all_students.php in browser.

Verify IP/port in baseUrl.

Problem: 500 / DB connection failed
Solution:

Check database credentials in db_connect.php.

Verify MySQL is running.

Problem: UI overflow when keyboard opens
Solution:

The app uses resizeToAvoidBottomInset: true and SingleChildScrollView.

If still happening, adjust small-screen font scaling in device settings.

10) Project Structure (Short)
vbnet
Copy
Edit
cstu_archive/
 ├─ lib/
 │   ├─ services/
 │   │   ├─ auth_service.dart
 │   │   └─ admin_auth_service.dart
 │   └─ screens...
 ├─ api/
 │   ├─ db_connect.php
 │   ├─ login.php
 │   ├─ signup.php
 │   ├─ forgot_password.php
 │   ├─ get_user_details.php
 │   ├─ get_all_students.php
 │   ├─ admin_login.php
 │   ├─ admin_signup.php
 │   └─ admin_forgot_password.php
 ├─ android/
 ├─ pubspec.yaml
 └─ README.md
11) Build for Production
bash
Copy
Edit
flutter build apk --release
# or
flutter build appbundle --release
Security Note:
For production, use HTTPS if possible, sanitize all SQL inputs, and keep sensitive config (DB password) out of public repositories by adding them to .gitignore.


