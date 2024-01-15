import Foundation

class PointsSystem {
    var score: Int = 0

    func addPoints(_ points: Int) {
        score += points
    }

    func subtractPoints(_ points: Int) {
        score = max(0, score - points) // Empêche le score de devenir négatif
    }

    func resetPoints() {
        score = 0
    }
}

//testing code 

import UIKit

class ViewController: UIViewController {
    
    var pointsSystem = PointsSystem()
    @IBOutlet weak var scoreLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateScoreLabel()
    }

    func updateScoreLabel() {
        scoreLabel.text = "Score: \(pointsSystem.score)"
    }

    @IBAction func addPointsButtonTapped(_ sender: UIButton) {
        pointsSystem.addPoints(10)
        updateScoreLabel()
    }

    @IBAction func subtractPointsButtonTapped(_ sender: UIButton) {
        pointsSystem.subtractPoints(5)
        updateScoreLabel()
    }

    @IBAction func resetButtonTapped(_ sender: UIButton) {
        pointsSystem.resetPoints()
        updateScoreLabel()
    }
}

import Firebase

class PointsSystem {
    var score: Int = 0
    let db = Firestore.firestore()
    let userId: String // Identifiant de l'utilisateur

    init(userId: String) {
        self.userId = userId
        loadPoints()
    }

    func addPoints(_ points: Int) {
        score += points
        savePoints()
    }

    func subtractPoints(_ points: Int) {
        score = max(0, score - points)
        savePoints()
    }

    func resetPoints() {
        score = 0
        savePoints()
    }

    private func savePoints() {
        db.collection("users").document(userId).setData(["score": score])
    }

    private func loadPoints() {
        db.collection("users").document(userId).getDocument { (document, error) in
            if let document = document, document.exists {
                self.score = document.data()?["score"] as? Int ?? 0
            } else {
                print("Document does not exist")
            }
        }
    }
}

import UIKit

class ViewController: UIViewController {
    
    var pointsSystem = PointsSystem()
    @IBOutlet weak var scoreLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateScoreLabel()
    }

    func updateScoreLabel() {
        scoreLabel.text = "Score: \(pointsSystem.score)"
    }

    @IBAction func addPointsButtonTapped(_ sender: UIButton) {
        pointsSystem.addPoints(10)
        updateScoreLabel()
    }

    @IBAction func subtractPointsButtonTapped(_ sender: UIButton) {
        pointsSystem.subtractPoints(5)
        updateScoreLabel()
    }

    @IBAction func resetButtonTapped(_ sender: UIButton) {
        pointsSystem.resetPoints()
        updateScoreLabel()
    }
}



//This is for ViewController 
