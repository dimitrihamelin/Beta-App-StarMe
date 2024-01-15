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

//This is for ViewController 
