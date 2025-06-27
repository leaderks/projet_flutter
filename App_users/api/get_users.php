<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once '../conf/db.php';    // Fichier qui contient la classe Database
require_once '../model/users.php'; // Fichier qui contient la classe User

// Création de la connexion PDO
$database = new Database();
$pdo = $database->getConnexion();

if (!$pdo) {
    http_response_code(500);
    echo json_encode(['error' => 'Erreur de connexion à la base de données']);
    exit;
}

// Instanciation de User avec la connexion PDO
$user = new User($pdo);

// Récupération des utilisateurs
$users = $user->getAllUsers();

// Retourne la liste des utilisateurs au format JSON
echo json_encode($users);
