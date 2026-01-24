<?php
// db.php
$conn = mysqli_connect("localhost", "root", "", "php_crud");

if (!$conn) {
    die("Xidhiidhka database-ku wuu fashilmay: " . mysqli_connect_error());
}
?>