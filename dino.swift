import SwiftUI
import AVFoundation

struct DinoGameView: View {
    
    // State variables
    @State private var gameStarted = false
    @State private var dinoPosition = CGPoint(x: 50, y: 0)
    @State private var obstaclePosition = CGPoint(x: 400, y: 0)
    @State private var gameSpeed: Double = 10.0
    @State private var audioPlayer: AVAudioPlayer?
    @State private var score = 0
    @State private var highScore = UserDefaults.standard.integer(forKey: "highScore")
    @State private var isJumping = false // Indicator for jump status
    @State private var lastJumpTime: TimeInterval = 0 // Time of the last jump
    @State private var gravity: CGFloat = 5.0 // Gravity to pull the dino down
    @State private var lastThreeJumps = [CGFloat]() // To store the last three jump heights
    
    // Star properties
    @State private var stars = [Star]()

    // Game loop
    let gameTimer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background with galaxy gradient and shooting stars
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.purple, Color.orange]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                    ForEach(stars) { star in
                        Circle()
                            .fill(Color.white)
                            .frame(width: star.size, height: star.size)
                            .position(star.position)
                            .animation(Animation.linear(duration: star.speed).repeatForever(autoreverses: false))
                    }
                }.onAppear {
                    startStars(geo.size)
                    // Set initial positions based on the geometry size
                    dinoPosition = CGPoint(x: 50, y: geo.size.height / 2)
                    obstaclePosition = CGPoint(x: geo.size.width - 40, y: geo.size.height / 2)
                }
                
                // Dinosaur
                Image("poulet") // Update the image to a chicken
                    .resizable()
                    .frame(width: 50, height: 50)
                    .position(dinoPosition)
                
                // Obstacle (Chicken)
                Image("number3") // Make sure you have an image named "chicken" in your assets
                    .resizable()
                    .frame(width: 40, height: 40)
                    .position(obstaclePosition)
                
                // Score Display
                VStack {
                    Spacer()
                    HStack {
                        Text("Score: \(score)")
                            .font(.title)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding([.leading, .bottom], 20)
                }
                
                // Game Over Screen
                if !gameStarted {
                    VStack {
                        Text("Game Over")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                        Text("Score: \(score)")
                            .font(.title)
                            .foregroundColor(.white)
                        Text("High Score: \(highScore)")
                            .font(.title)
                            .foregroundColor(.white)
                        Button(action: {
                            restartGame(size: geo.size)
                        }) {
                            Text("Restart")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.7))
                }
            }
            .onReceive(gameTimer) { _ in
                updateGame(size: geo.size)
            }
            .onTapGesture {
                if gameStarted {
                    jump(size: geo.size)
                    playSound()
                } else {
                    startGame(size: geo.size)
                }
            }
            .background(Color.black) // Background color of the game
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    // Function to create star objects
    private func startStars(_ size: CGSize) {
        for _ in 0..<50 {
            let star = Star(
                position: CGPoint(x: .random(in: 0...size.width), y: .random(in: 0...size.height)),
                size: .random(in: 2...4),
                speed: .random(in: 5...10)
            )
            stars.append(star)
        }
    }
    
    private func playSound() {
        if let path = Bundle.main.path(forResource: "jump", ofType: "wav") {
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                self.audioPlayer?.play()
            } catch {
                print("Error playing sound file")
            }
        }
    }
    
    // Game functions
    private func updateGame(size: CGSize) {
        if gameStarted {
            moveObstacle(size: size)
            applyGravity(size: size)
            checkCollision()
            score += 1 // Update the score
        }
    }
    
    private func jump(size: CGSize) {
        let currentTime = Date().timeIntervalSince1970
        let jumpHeight: CGFloat = .random(in: 80...120)
        let jumpForwardDistance: CGFloat = 50 // Add a forward distance for the jump
        if !isJumping && !isRepeatedJump(height: jumpHeight) && currentTime - lastJumpTime > 0.5 {
            isJumping = true
            lastJumpTime = currentTime
            recordJump(height: jumpHeight)
            withAnimation(.easeOut(duration: 0.3)) {
                dinoPosition.y -= jumpHeight
                dinoPosition.x += jumpForwardDistance // Move the dino forward during the jump
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.fallAfterJump(height: jumpHeight, forwardDistance: jumpForwardDistance, size: size)
            }
        }
    }
    
    private func fallAfterJump(height: CGFloat, forwardDistance: CGFloat, size: CGSize) {
        withAnimation(.easeIn(duration: 0.3)) {
            dinoPosition.y += height
            dinoPosition.x -= forwardDistance // Adjust the position back after falling
            if dinoPosition.y > size.height / 2 {
                dinoPosition.y = size.height / 2
            }
            if dinoPosition.x < 50 {
                dinoPosition.x = 50 // Prevent dino from moving too far back
            }
        }
        isJumping = false
    }
    
    private func applyGravity(size: CGSize) {
        if dinoPosition.y < size.height / 2 && !isJumping {
            withAnimation {
                dinoPosition.y = min(dinoPosition.y + gravity, size.height / 2)
            }
        }
    }
    
    private func moveObstacle(size: CGSize) {
        obstaclePosition.x -= CGFloat(gameSpeed)
        
        // Reset obstacle position
        if obstaclePosition.x < -20 {
            obstaclePosition.x = size.width
        }
    }
    
    private func checkCollision() {
        // Adjust the collision detection to be less sensitive
        let dinoRect = CGRect(x: dinoPosition.x - 15, y: dinoPosition.y - 15, width: 30, height: 30)
        let obstacleRect = CGRect(x: obstaclePosition.x - 15, y: obstaclePosition.y - 15, width: 30, height: 30)
        
        if dinoRect.intersects(obstacleRect) {
            endGame()
        }
    }
    
    private func endGame() {
        gameStarted = false
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "highScore")
        }
    }
    
    private func restartGame(size: CGSize) {
        score = 0
        dinoPosition = CGPoint(x: 50, y: size.height / 2)
        obstaclePosition = CGPoint(x: size.width - 40, y: size.height / 2)
        gameStarted = true
        isJumping = false
        lastThreeJumps.removeAll()
    }
    
    private func startGame(size: CGSize) {
        score = 0
        gameStarted = true
        isJumping = false
        dinoPosition = CGPoint(x: 50, y: size.height / 2)
        obstaclePosition = CGPoint(x: size.width - 40, y: size.height / 2)
        lastThreeJumps.removeAll()
    }
    
    private func recordJump(height: CGFloat) {
        lastThreeJumps.append(height)
        if lastThreeJumps.count > 3 {
            lastThreeJumps.removeFirst()
        }
    }
    
    private func isRepeatedJump(height: CGFloat) -> Bool {
        return lastThreeJumps.filter { $0 == height }.count >= 2
    }
}

// Star model
struct Star: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var speed: Double
}
