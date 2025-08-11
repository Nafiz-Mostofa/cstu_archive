<?php
include 'db_connect.php';
header('Content-Type: application/json');

// Basic validation
if (
    !isset($_POST['student_id'], $_POST['username'], $_POST['email'], $_POST['password']) ||
    $_POST['student_id'] === '' || $_POST['username'] === '' || $_POST['email'] === '' || $_POST['password'] === ''
) {
    echo json_encode(["success" => false, "message" => "All fields are required"]);
    exit;
}

$student_id = trim($_POST['student_id']);
$username   = trim($_POST['username']);
$email      = trim($_POST['email']);
$password   = password_hash($_POST['password'], PASSWORD_DEFAULT);

// 1) Check if student_id exists
$checkSql = "SELECT student_id, username, password, email FROM students WHERE student_id = ?";
$checkStmt = $conn->prepare($checkSql);
$checkStmt->bind_param("s", $student_id);
$checkStmt->execute();
$result = $checkStmt->get_result();

if (!$row = $result->fetch_assoc()) {
    echo json_encode(["success" => false, "message" => "Invalid Student ID"]);
    $checkStmt->close();
    $conn->close();
    exit;
}

// 2) Block re-registration if already registered (username or password already set)
$alreadyRegistered = false;

// You can tweak the condition as needed; usually username or password being non-empty means registered.
if (
    (isset($row['username']) && $row['username'] !== '') ||
    (isset($row['password']) && $row['password'] !== null && $row['password'] !== '')
) {
    $alreadyRegistered = true;
}

if ($alreadyRegistered) {
    echo json_encode(["success" => false, "message" => "Already registered"]);
    $checkStmt->close();
    $conn->close();
    exit;
}

// 3) (Optional) Ensure username is unique across table
$unameSql = "SELECT 1 FROM students WHERE username = ? AND student_id <> ?";
$unameStmt = $conn->prepare($unameSql);
$unameStmt->bind_param("ss", $username, $student_id);
$unameStmt->execute();
$unameStmt->store_result();

if ($unameStmt->num_rows > 0) {
    echo json_encode(["success" => false, "message" => "Username already taken"]);
    $unameStmt->close();
    $checkStmt->close();
    $conn->close();
    exit;
}
$unameStmt->close();

// 4) Proceed to set username/password/email for the first time
$update = "UPDATE students SET username = ?, password = ?, email = ? WHERE student_id = ?";
$updStmt = $conn->prepare($update);
$updStmt->bind_param("ssss", $username, $password, $email, $student_id);

if ($updStmt->execute()) {
    echo json_encode(["success" => true, "message" => "Signup successful"]);
} else {
    echo json_encode(["success" => false, "message" => "Signup failed"]);
}

$updStmt->close();
$checkStmt->close();
$conn->close();
