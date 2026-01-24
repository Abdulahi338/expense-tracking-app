<?php
include 'db.php';

$id = $_GET['id'];

if (isset($_POST['update'])) {
    $name = $_POST['name'];
    $email = $_POST['email'];
    $course = $_POST['course'];

    mysqli_query($conn, "UPDATE students SET 
        name='$name', 
        email='$email', 
        course='$course' 
        WHERE id=$id");

    header("Location: index.php");
}

$result = mysqli_query($conn, "SELECT * FROM students WHERE id=$id");
$row = mysqli_fetch_assoc($result);
?>

<h2>Edit Student</h2>
<form method="POST">
    Name: <input type="text" name="name" value="<?php echo $row['name']; ?>"><br><br>
    Email: <input type="email" name="email" value="<?php echo $row['email']; ?>"><br><br>
    Course: <input type="text" name="course" value="<?php echo $row['course']; ?>"><br><br>
    <button name="update">Update</button>
</form>
