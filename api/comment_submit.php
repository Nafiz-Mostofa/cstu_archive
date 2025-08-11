<?php
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'message' => 'Invalid request method']);
    exit;
}

if (!isset($_POST['username']) || !isset($_POST['comment'])) {
    echo json_encode(['success' => false, 'message' => 'Required data not provided']);
    exit;
}

$username = trim($_POST['username']);
$comment = trim($_POST['comment']);

if (empty($username) || empty($comment)) {
    echo json_encode(['success' => false, 'message' => 'Username or comment is empty']);
    exit;
}

require_once 'db_connect.php';

// Debug log (optional)
error_log("Username: $username | Comment: $comment");

// Check user
$stmt = $conn->prepare("SELECT 1 FROM students WHERE username = ?");
$stmt->bind_param("s", $username);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows === 0) {
    echo json_encode(['success' => false, 'message' => "User not found for '$username'"]);
    $stmt->close();
    $conn->close();
    exit;
}
$stmt->close();

// Update comment
$updateStmt = $conn->prepare("UPDATE students SET comment = ? WHERE username = ?");
$updateStmt->bind_param("ss", $comment, $username);

if ($updateStmt->execute()) {
    echo json_encode(['success' => true, 'message' => 'Comment updated successfully']);
} else {
    echo json_encode(['success' => false, 'message' => 'Comment update failed: ' . $updateStmt->error]);
}

$updateStmt->close();
$conn->close();
?>
