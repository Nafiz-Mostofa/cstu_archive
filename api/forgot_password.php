<?php
include 'db_connect.php';

$student_id = $_POST['student_id'];
$username = $_POST['username'];
$new_password = password_hash($_POST['new_password'], PASSWORD_DEFAULT);

$sql = "SELECT * FROM students WHERE student_id = ? AND username = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ss", $student_id, $username);
$stmt->execute();
$result = $stmt->get_result();

if ($result->fetch_assoc()) {
    $update = "UPDATE students SET password = ? WHERE student_id = ? AND username = ?";
    $stmt = $conn->prepare($update);
    $stmt->bind_param("sss", $new_password, $student_id, $username);
    if ($stmt->execute()) {
        echo json_encode(["success" => true, "message" => "Password updated successfully"]);
    } else {
        echo json_encode(["success" => false, "message" => "Password update failed"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Student ID or Username incorrect"]);
}
?>
