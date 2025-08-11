<?php
header('Content-Type: application/json');
require_once 'db_connect.php';

$sql = "SELECT student_id, student_name, username, email, gp, semester_credit, total_credit, gpa, cgpa, failed_subjects, subjects_to_register FROM students";
$result = $conn->query($sql);

if ($result && $result->num_rows > 0) {
    $students = [];

    while ($row = $result->fetch_assoc()) {
        $students[] = $row;
    }

    echo json_encode([
        'success' => true,
        'students' => $students
    ]);
} else {
    echo json_encode([
        'success' => false,
        'message' => 'No students found'
    ]);
}

$conn->close();
?>
