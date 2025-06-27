<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: DELETE"); // DELETE pour suppression
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

// Vérification champ id
if (!isset($data['id'])) {
    echo json_encode(['success' => false, 'message' => 'ID manquant']);
    exit;
}

$id = (int) $data['id'];

if ($id <= 0) {
    echo json_encode(['success' => false, 'message' => 'ID invalide']);
    exit;
}

// Instanciation User avec la connexion PDO
$user = new User($pdo);

// Appel méthode suppression
$response = $user->supprimer($id);

// Retour JSON
echo json_encode($response);
