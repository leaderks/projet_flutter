<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST"); // POST car on crée une ressource
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once '../conf/db.php';    // Classe Database
require_once '../model/users.php'; // Classe User

// Création connexion PDO
$database = new Database();
$pdo = $database->getConnexion();

if (!$pdo) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Erreur de connexion à la base de données']);
    exit;
}

// Lecture des données JSON reçues
$data = json_decode(file_get_contents("php://input"), true);

// Vérifications basiques des champs requis
if (!isset($data['nom'], $data['email'], $data['password'])) {
    echo json_encode(['success' => false, 'message' => 'Champs requis manquants']);
    exit;
}

$nom = trim($data['nom']);
$email = trim($data['email']);
$password = $data['password'];

if (empty($nom) || empty($email) || empty($password)) {
    echo json_encode(['success' => false, 'message' => 'Nom, email ou mot de passe ne peuvent pas être vides']);
    exit;
}

// Instanciation User avec la connexion PDO
$user = new User($pdo);

// Appel de la méthode inscrire
$response = $user->inscrire($nom, $email, $password);

// Retour JSON
echo json_encode($response);
