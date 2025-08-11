<?php
include 'db_connect.php';

$email = $_POST['email'];
$username = $_POST['username'];
$new_password = password_hash($_POST['new_password'], PASSWORD_DEFAULT);

$sql = "SELECT * FROM adminpanel WHERE email = ? AND username = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ss", $email, $username);
$stmt->execute();
$result = $stmt->get_result();

if ($result->fetch_assoc()) {
    $update = "UPDATE adminpanel SET password = ? WHERE email = ? AND username = ?";
    $stmt = $conn->prepare($update);
    $stmt->bind_param("sss", $new_password, $email, $username);
    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'Password updated successfully']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Password update failed']);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Email or username incorrect']);
}
?>
