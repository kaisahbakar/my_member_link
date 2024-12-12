<?php
include_once("../config.php");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user_id = $_POST['user_id'];
    $news_id = $_POST['news_id'];

    $query = "DELETE FROM bookmarks WHERE user_id = ? AND news_id = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("ii", $user_id, $news_id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode(["status" => "error", "message" => $stmt->error]);
    }
}
?>
 
