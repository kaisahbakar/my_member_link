<?php
// Include database connection
include_once("dbconnect.php");

// Billplz API credentials
$apiKey = 'YOUR_API_KEY'; // Replace with your actual API key
$endpoint = 'https://www.billplz.com/api/v2/transactions';

// Payment details
$userid = $_GET['userid'];
$amount = $_GET['amount'];
$name = $_GET['name'];
$email = $_GET['email'];
$phone = $_GET['phone'];

// Create payment request
$data = array(
    'collection_id' => 'YOUR_COLLECTION_ID', // Replace with your collection ID
    'email' => $email,
    'name' => $name,
    'amount' => $amount * 100, // Amount in cents
    'phone' => $phone,
    'description' => 'Payment for order',
    'redirect_url' => 'YOUR_REDIRECT_URL', // URL to redirect after payment
);

$ch = curl_init($endpoint);

curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, array(
    'Content-Type: application/json',
    'Authorization: Bearer ' . $apiKey
));
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);

if ($httpCode == 201) {
    $responseData = json_decode($response, true);
    // Redirect to Billplz payment page
    header('Location: ' . $responseData['url']);
    exit();
} else {
    // Handle error
    echo 'Payment request failed: ' . $response;
}
?>
