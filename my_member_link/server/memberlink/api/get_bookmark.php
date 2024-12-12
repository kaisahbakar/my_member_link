<?php
include_once("../config.php");

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $user_id = $_GET['user_id'];

    $query = "SELECT news_id FROM bookmarks WHERE user_id = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();

    $bookmarks = [];
    while ($row = $result->fetch_assoc()) {
        $bookmarks[] = $row['news_id'];
    }

    echo json_encode(["status" => "success", "data" => $bookmarks]);
}
?>
