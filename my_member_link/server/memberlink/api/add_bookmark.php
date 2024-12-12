<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

include_once("../config.php");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['user_id'], $_POST['news_id'])) {
        $user_id = (int) $_POST['user_id'];
        $news_id = (int) $_POST['news_id'];

        // Validate if user_id exists in users table
        $user_check_query = "SELECT id FROM users WHERE id = ?";
        $user_stmt = $conn->prepare($user_check_query);
        $user_stmt->bind_param("i", $user_id);
        $user_stmt->execute();
        $user_result = $user_stmt->get_result();

        if ($user_result->num_rows === 0) {
            echo json_encode(["status" => "error", "message" => "Invalid user_id."]);
            exit;
        }

        // Validate if news_id exists in news table
        $news_check_query = "SELECT news_id FROM news WHERE news_id = ?";
        $news_stmt = $conn->prepare($news_check_query);
        $news_stmt->bind_param("i", $news_id);
        $news_stmt->execute();
        $news_result = $news_stmt->get_result();

        if ($news_result->num_rows === 0) {
            echo json_encode(["status" => "error", "message" => "Invalid news_id."]);
            exit;
        }

        // Check if the bookmark already exists
        $bookmark_check_query = "SELECT * FROM bookmarks WHERE user_id = ? AND news_id = ?";
        $bookmark_stmt = $conn->prepare($bookmark_check_query);
        $bookmark_stmt->bind_param("ii", $user_id, $news_id);
        $bookmark_stmt->execute();
        $bookmark_result = $bookmark_stmt->get_result();

        if ($bookmark_result->num_rows > 0) {
            echo json_encode(["status" => "exists", "message" => "Bookmark already exists."]);
            exit;
        }

        // Insert the bookmark into the table
        $insert_query = "INSERT INTO bookmarks (user_id, news_id) VALUES (?, ?)";
        $insert_stmt = $conn->prepare($insert_query);
        $insert_stmt->bind_param("ii", $user_id, $news_id);

        try {
            $insert_stmt->execute();
            echo json_encode(["status" => "success"]);
        } catch (mysqli_sql_exception $e) {
            if ($e->getCode() === 1062) { // Duplicate entry error code
                echo json_encode(["status" => "exists", "message" => "Bookmark already exists."]);
            } elseif ($e->getCode() === 1452) { // Foreign key violation
                echo json_encode(["status" => "error", "message" => "Invalid user_id or news_id."]);
            } else {
                echo json_encode(["status" => "error", "message" => $e->getMessage()]);
            }
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Missing parameters."]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method."]);
}

?>
