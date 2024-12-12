<?php

include_once("dbconnect.php");

$sqlloadnews = "SELECT * FROM `tbl_news` ORDER BY `news_date` DESC";
$result = $conn->query($sqlloadnews);

if ($result->num_rows > 0) {
    $newsarray['news'] = array();
    while ($row = $result->fetch_assoc()) {
        $news = array();
        $news['news_id'] = $row['news_id'];
        $news['news_title'] = $row['news_title'];
        $news['news_details'] = $row['news_details'];
        $news['news_date'] = $row['news_date'];
        array_push($newsarray['news'], $news);
    }
    $response = array('status' => 'success', 'data' => $newsarray);
    sendJsonResponse($response);
}else{
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}
	
	
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>
