<?php
// Database configuration
$host = 'localhost'; // Your database host
$dbname = 'your_database_name'; // Your database name
$username = 'your_username'; // Your database username
$password = 'your_password'; // Your database password

// Create a new PDO instance
try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Could not connect to the database: " . $e->getMessage());
}

// Get the POST data
$user_id = $_POST['user_id'];
$membership_type = $_POST['membership_type'];
$payment_method = $_POST['payment_method'];
$amount = $_POST['amount'];
$transaction_status = $_POST['transaction_status'];
$card_number = isset($_POST['card_number']) ? $_POST['card_number'] : null;
$bank_account_number = isset($_POST['bank_account_number']) ? $_POST['bank_account_number'] : null;
$paypal_email = isset($_POST['paypal_email']) ? $_POST['paypal_email'] : null;

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
    echo json_encode(['status' => 'error', 'message' => 'Failed to store payment information.']);
}

// Close the connection
$pdo = null;
?>
