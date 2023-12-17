import UIKit

class AccueilViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configuration de la barre de navigation
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false

        // Configuration de la page d'accueil
        let homeViewController = UIViewController()
        homeViewController.view.backgroundColor = UIColor.white
        homeViewController.title = "Accueil"

        // Configuration de la page Explorer
        let exploreViewController = UIViewController()
        exploreViewController.view.backgroundColor = UIColor.white
        exploreViewController.title = "Explorer"

        // Configuration de la page Caméra
        let cameraViewController = UIViewController()
        cameraViewController.view.backgroundColor = UIColor.white
        cameraViewController.title = "Caméra"

        // Configuration de la page Activité
        let activityViewController = UIViewController()
        activityViewController.view.backgroundColor = UIColor.white
        activityViewController.title = "Activité"

        // Configuration de la page Profil
        let profileViewController = UIViewController()
        profileViewController.view.backgroundColor = UIColor.white
        profileViewController.title = "Profil"

        // Ajout des ViewControllers à la barre d'onglets
        self.viewControllers = [homeViewController, exploreViewController, cameraViewController, activityViewController, profileViewController]

        // Ajout du bouton de déconnexion
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Déconnexion", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)

        // Positionnement du bouton de déconnexion en haut à gauche
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)

        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            logoutButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }

    @objc func logoutButtonTapped() {
        // Ajoutez le code de déconnexion ici
        // Par exemple, pour revenir à l'écran de connexion :
        navigationController?.popToRootViewController(animated: true)
    }
}

