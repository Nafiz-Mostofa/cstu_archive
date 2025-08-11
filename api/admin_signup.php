<?php
include 'db_connect.php';
header('Content-Type: application/json');
// (Optional) CORS allow if needed from emulator/other device
// header('Access-Control-Allow-Origin: *');

// Basic validation
if (
    !isset($_POST['email'], $_POST['username'], $_POST['password'], $_POST['phone']) ||
    $_POST['email'] === '' || $_POST['username'] === '' || $_POST['password'] === '' || $_POST['phone'] === ''
) {
    echo json_encode(['success' => false, 'message' => 'All fields are required']);
    exit;
}

$email    = trim($_POST['email']);
$username = trim($_POST['username']);
$password = password_hash($_POST['password'], PASSWORD_DEFAULT);
$phone    = trim($_POST['phone']);

// 1) Check email exists in adminpanel (pre-seeded)
$checkSql = "SELECT email, username FROM adminpanel WHERE email = ?";
$checkStmt = $conn->prepare($checkSql);
$checkStmt->bind_param("s", $email);
$checkStmt->execute();
$result = $checkStmt->get_result();

if (!$row = $result->fetch_assoc()) {
    echo json_encode(['success' => false, 'message' => 'Email not found']);
    $checkStmt->close();
    $conn->close();
    exit;
}

// 2) Block re-registration if this email already has username set
if (isset($row['username']) && $row['username'] !== '') {
    echo json_encode(['success' => false, 'message' => 'Already registered with this email']);
    $checkStmt->close();
    $conn->close();
    exit;
}

// 3) (Optional) Ensure username is unique across adminpanel
$unameSql = "SELECT 1 FROM adminpanel WHERE username = ? LIMIT 1";
$unameStmt = $conn->prepare($unameSql);
$unameStmt->bind_param("s", $username);
$unameStmt->execute();
$unameStmt->store_result();

if ($unameStmt->num_rows > 0) {
    echo json_encode(['success' => false, 'message' => 'Username already taken']);
    $unameStmt->close();
    $checkStmt->close();
    $conn->close();
    exit;
}
$unameStmt->close();

// 4) First-time registration for this email → set username/password/phone
$updateSql = "UPDATE adminpanel SET username = ?, password = ?, phone = ? WHERE email = ?";
$updateStmt = $conn->prepare($updateSql);
$updateStmt->bind_param("ssss", $username, $password, $phone, $email);

if ($updateStmt->execute()) {
    echo json_encode(['success' => true, 'message' => 'Registration successful']);
} else {
    echo json_encode(['success' => false, 'message' => 'Update failed']);
}

$updateStmt->close();
$checkStmt->close();
$conn->close();
