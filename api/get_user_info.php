<?php
$host = "localhost";
$username = "root";
$password = "";
$database = "flutter_auth"; 

$conn = new mysqli($host, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Check if 'username' parameter is set
if (isset($_POST['username'])) {
    $username = $_POST['username'];

    // Prepare SQL statement
    $stmt = $conn->prepare("SELECT student_name, student_id, gp, semester_credit, total_credit, gpa, cgpa, failed_subjects FROM students WHERE username = ?");

    // Check if prepare() failed
    if ($stmt === false) {
        echo json_encode([
            "success" => false,
            "message" => "SQL Prepare Failed: " . $conn->error
        ]);
        exit();
    }

    // Bind parameter and execute
    $stmt->bind_param("s", $username);
    $stmt->execute();
    $stmt->store_result();

    // Check if user found
    if ($stmt->num_rows > 0) {
        $stmt->bind_result($name, $student_id, $gp, $semester_credit, $total_credit, $gpa, $cgpa, $failed_subjects);
        $stmt->fetch();

        // Send JSON response
        echo json_encode([
            "success" => true,
            "name" => $name,
            "student_id" => $student_id,
            "gp" => $gp,
            "earned_credit" => $semester_credit,
            "total_credit" => $total_credit,
            "gpa" => $gpa,
            "cgpa" => $cgpa,
            "failed_subjects" => $failed_subjects
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "No user found"
        ]);
    }

    $stmt->close();
} else {
    echo json_encode([
        "success" => false,
        "message" => "Username not provided"
    ]);
}

$conn->close();
?>
