<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST"); // POST car on modifie
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once '../conf/db.php';    // Classe Database
require_once '../model/users.php'; // Classe User

// Création de la connexion PDO
$database = new Database();
$pdo = $database->getConnexion();

if (!$pdo) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Erreur de connexion à la base de données']);
    exit;
}

// Lecture et vérification des données reçues
$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['id'], $data['nom'], $data['email'])) {
    echo json_encode(['success' => false, 'message' => 'Champs requis manquants']);
    exit;
}

$id = (int) $data['id'];
$nom = trim($data['nom']);
$email = trim($data['email']);

if (empty($nom) || empty($email)) {
    echo json_encode(['success' => false, 'message' => 'Nom ou email ne peuvent pas être vides']);
    exit;
}

// Instanciation User avec la connexion PDO
$user = new User($pdo);

// Appel méthode de mise à jour
$response = $user->mettreAJour($id, $nom, $email);

// Retourne la réponse JSON
echo json_encode($response);
