<?php
class User
{
    private $pdo;

    // Constructeur avec injection de la connexion PDO
    public function __construct($pdo)
    {
        $this->pdo = $pdo;
    }

    // Vérifie si un email existe déjà
    private function emailExiste($email)
    {
        $stmt = $this->pdo->prepare("SELECT id FROM users WHERE email = ?");
        $stmt->execute(array($email));
        return $stmt->fetch() ? true : false;
    }

    // Crée un nouvel utilisateur
    public function inscrire($nom, $email, $password)
    {
        if ($this->emailExiste($email)) {
            return array('success' => false, 'message' => 'Email déjà utilisé');
        }

        $hash = password_hash($password, PASSWORD_DEFAULT);
        $stmt = $this->pdo->prepare("INSERT INTO users (nom, email, password) VALUES (?, ?, ?)");
        $success = $stmt->execute(array($nom, $email, $hash));

        return $success
            ? array('success' => true, 'message' => 'Inscription réussie')
            : array('success' => false, 'message' => 'Erreur lors de l\'inscription');
    }

    // Met à jour un utilisateur (sauf le mot de passe)
    public function mettreAJour($id, $nom, $email)
    {
        $stmt = $this->pdo->prepare("UPDATE users SET nom = ?, email = ? WHERE id = ?");
        $success = $stmt->execute(array($nom, $email, $id));

        return $success
            ? array('success' => true, 'message' => 'Utilisateur modifié avec succès')
            : array('success' => false, 'message' => 'Échec de la modification');
    }

    // Supprime un utilisateur par son ID
    public function supprimer($id)
    {
        $stmt = $this->pdo->prepare("DELETE FROM users WHERE id = ?");
        $success = $stmt->execute(array($id));

        return $success
            ? array('success' => true, 'message' => 'Utilisateur supprimé')
            : array('success' => false, 'message' => 'Échec de la suppression');
    }

    // Récupère tous les utilisateurs
    public function getAllUsers()
    {
        $stmt = $this->pdo->query("SELECT id, nom, email FROM users ORDER BY id DESC");
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Récupère un utilisateur par son ID
    public function getUserById($id)
    {
        $stmt = $this->pdo->prepare("SELECT id, nom, email FROM users WHERE id = ?");
        $stmt->execute(array($id));
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
}
