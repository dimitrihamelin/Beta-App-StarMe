<?php
// Paramètres de connexion à la base de données
$servername = "localhost:3306";
$username = "pdyfwoyt_userbdd"; // Remplacez par votre nom d'utilisateur pour la BDD
$password = "G.vHZv^hQ=v%"; // Remplacez par votre mot de passe pour la BDD
$dbname = "pdyfwoyt_bddsite"; // Remplacez par le nom de votre base de données

// Création de la connexion
$conn = new mysqli($servername, $username, $password, $dbname);

// Définition du charset de la connexion pour supporter les accents et autres caractères spéciaux
mysqli_set_charset($conn, 'utf8');

// Vérification de la connexion
if ($conn->connect_error) {
    die("Échec de la connexion: " . $conn->connect_error);
}

// Récupération de l'email de l'utilisateur à partir des données envoyées depuis Firebase
$user_email = $_POST['user_email']; // Assurez-vous que le nom de la clé correspond à celui que vous envoyez depuis Firebase

// Requête SQL pour récupérer les informations des publications avec la vérification des likes par utilisateur
$sql = "
SELECT 
    p.id, 
    p.titre, 
    p.description, 
    CONCAT('https://locarodix.com/application/', p.image_path) AS image_path, 
    p.user_email, 
    p.date_creation, 
    p.likes, 
    p.username, 
    p.points, 
    p.nombre AS nombre_commentaires, 
    (CASE 
        WHEN (SELECT COUNT(*) FROM verification_likes v WHERE p.id = v.publication_id AND v.user_email = '$user_email') > 0 
        THEN '1' 
        ELSE '0' 
    END) AS a_liké
FROM 
    publications p 
WHERE 
    p.image_path IS NOT NULL 
    AND p.image_path <> ''
";

$result = $conn->query($sql);

$publications = [];

if ($result->num_rows > 0) {
    // Récupération des données de chaque publication
    while($row = $result->fetch_assoc()) {
        $publications[] = $row;
    }

    // Encodage des données en JSON et affichage
    echo json_encode($publications, JSON_UNESCAPED_UNICODE);
} else {
    // Affichage d'un tableau JSON vide si aucune publication avec une image n'est trouvée
    echo "[]";
}

// Fermeture de la connexion à la base de données
$conn->close();
?>
