<?php
// Include database connection
include 'dbconnect.php';

// Enable error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Get the POST data
$user_id = $_POST['user_id'];
$membership_type = $_POST['membership_type'];
$payment_method = $_POST['payment_method'];
$amount = $_POST['amount'];
$transaction_status = $_POST['transaction_status'];
$card_number = isset($_POST['card_number']) ? $_POST['card_number'] : null;
$bank_account_number = isset($_POST['bank_account_number']) ? $_POST['bank_account_number'] : null;
$paypal_email = isset($_POST['paypal_email']) ? $_POST['paypal_email'] : null;

// Log incoming POST data for debugging
error_log(print_r($_POST, true));

// Check if required fields are set
if (empty($user_id) || empty($membership_type) || empty($payment_method) || empty($amount) || empty($transaction_status)) {
    error_log("Required fields are missing.");
    echo json_encode(['status' => 'error', 'message' => 'Required fields are missing.']);
    exit;
}

// Prepare the SQL statement
$sql = "INSERT INTO PaymentInformation (user_id, membership_type, payment_method, amount, transaction_status, card_number, bank_account_number, paypal_email) \
        VALUES (:user_id, :membership_type, :payment_method, :amount, :transaction_status, :card_number, :bank_account_number, :paypal_email)";

$stmt = $pdo->prepare($sql);

// Bind the parameters
$stmt->bindParam(':user_id', $user_id);
$stmt->bindParam(':membership_type', $membership_type);
$stmt->bindParam(':payment_method', $payment_method);
$stmt->bindParam(':amount', $amount);
$stmt->bindParam(':transaction_status', $transaction_status);
$stmt->bindParam(':card_number', $card_number);
$stmt->bindParam(':bank_account_number', $bank_account_number);
$stmt->bindParam(':paypal_email', $paypal_email);

// Execute the statement
if ($stmt->execute()) {
    echo json_encode(['status' => 'success', 'message' => 'Payment information stored successfully.']);
} else {
    error_log("SQL Error: " . print_r($stmt->errorInfo(), true));
    echo json_encode(['status' => 'error', 'message' => 'Failed to store payment information.', 'error' => $stmt->errorInfo()]);
}

// Close the connection
$pdo = null;
?>
