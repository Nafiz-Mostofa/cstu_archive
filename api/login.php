<?php
include 'db_connect.php';
header('Content-Type: application/json');

$username = $_POST['username'];
$password = $_POST['password'];

$sql = "SELECT * FROM students WHERE username = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $username);
$stmt->execute();
$result = $stmt->get_result();

if ($user = $result->fetch_assoc()) {
    if (password_verify($password, $user['password'])) {
        echo json_encode(["success" => true, "message" => "Login successful", "data" => $user]);
    } else {
        echo json_encode(["success" => false, "message" => "Incorrect password"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "User not found"]);
}
?>
