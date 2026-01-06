import SwiftUI
import SplineRuntime

struct LiveView: View {
    @ObservedObject var userManager = UserManager.shared
    @State private var gameMode: GameMode = .menu
    @State private var gameCode = ""
    @State private var pointsBet = 100
    
    let swiftColor = Color(hex: "FF684B")
    let darkColor = Color(hex: "232223")
    let cardBackground = Color(hex: "2a2a2a")
    
    enum GameMode {
        case menu
        case host
        case join
        case lobby
        case playing
        case results
    }
    
    var body: some View {
        ZStack {
            // Background
            if gameMode == .menu {
                // Spline Scene for Menu
                SplineView(sceneFileURL: URL(string: "https://build.spline.design/07MOBgjTDL2KtTI0v2uF/scene.splineswift")!)
                    .ignoresSafeArea()
            } else {
                // Gradient for other modes
                LinearGradient(
                    colors: [Color(hex: "1a1a1a"), Color(hex: "2a1a3a")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            }
            
            switch gameMode {
            case .menu:
                menuView
            case .host:
                hostView
            case .join:
                joinView
            case .lobby:
                lobbyView
            case .playing:
                playingView
            case .results:
                resultsView
            }
        }
    }
    
    // MARK: - Menu View
    private var menuView: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Note: Title removed to let Spline scene shine!
            
            Spacer()
            
            // Buttons
            VStack(spacing: 16) {
                Button {
                    gameMode = .host
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 20))
                        Text("Host a Game")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(swiftColor)
                            .shadow(color: swiftColor.opacity(0.4), radius: 8, y: 4)
                    )
                }
                
                Button {
                    gameMode = .join
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 20))
                        Text("Join a Game")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.purple)
                            .shadow(color: Color.purple.opacity(0.4), radius: 8, y: 4)
                    )
                }
            }
            .padding(.horizontal, 32)
            
            Spacer().frame(height: 100)
        }
    }
    
    // MARK: - Host View
    private var hostView: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Back button
                HStack {
                    Button {
                        gameMode = .menu
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                // Title
                VStack(spacing: 8) {
                    Text("🎯")
                        .font(.system(size: 60))
                    
                    Text("Host a Game")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }
                
                // Game Settings
                VStack(spacing: 16) {
                    // Points Bet
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Points to Bet")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 16) {
                            ForEach([50, 100, 200, 500], id: \.self) { amount in
                                Button {
                                    pointsBet = amount
                                } label: {
                                    Text("\(amount)")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(pointsBet == amount ? .white : .white.opacity(0.6))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(pointsBet == amount ? swiftColor : cardBackground)
                                        )
                                }
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(cardBackground)
                    )
                    
                    // Your Points
                    HStack {
                        Text("Your Points:")
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        Text("\(userManager.currentUser.points)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(swiftColor)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(cardBackground)
                    )
                }
                .padding(.horizontal, 20)
                
                // Create Game Button
                Button {
                    gameMode = .lobby
                    gameCode = generateGameCode()
                } label: {
                    Text("Create Game")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(swiftColor)
                                .shadow(color: swiftColor.opacity(0.4), radius: 8, y: 4)
                        )
                }
                .padding(.horizontal, 20)
                .disabled(userManager.currentUser.points < pointsBet)
                .opacity(userManager.currentUser.points < pointsBet ? 0.5 : 1)
                
                Spacer().frame(height: 100)
            }
        }
    }
    
    // MARK: - Join View
    private var joinView: some View {
        VStack(spacing: 32) {
            // Back button
            HStack {
                Button {
                    gameMode = .menu
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.white.opacity(0.7))
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            Spacer()
            
            VStack(spacing: 24) {
                Text("🔗")
                    .font(.system(size: 60))
                
                Text("Join a Game")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Enter the game code")
                    .foregroundColor(.white.opacity(0.7))
                
                // Code Input
                TextField("", text: $gameCode)
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(cardBackground)
                    )
                    .padding(.horizontal, 40)
                
                Button {
                    // Simulate joining
                    gameMode = .lobby
                } label: {
                    Text("Join Game")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.purple)
                                .shadow(color: Color.purple.opacity(0.4), radius: 8, y: 4)
                        )
                }
                .padding(.horizontal, 40)
                .disabled(gameCode.isEmpty)
                .opacity(gameCode.isEmpty ? 0.5 : 1)
            }
            
            Spacer()
            Spacer().frame(height: 100)
        }
    }
    
    // MARK: - Lobby View
    private var lobbyView: some View {
        VStack(spacing: 24) {
            // Game Code
            VStack(spacing: 12) {
                Text("Game Code")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                
                Text(gameCode)
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .foregroundColor(swiftColor)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(cardBackground)
                    )
            }
            .padding(.top, 40)
            
            // Players Waiting
            VStack(alignment: .leading, spacing: 16) {
                Text("Players (2)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 12) {
                    PlayerCard(name: userManager.currentUser.name, emoji: userManager.currentUser.emoji, isReady: true)
                    PlayerCard(name: "Alex", emoji: "👨‍💻", isReady: true)
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Start Button
            Button {
                gameMode = .playing
            } label: {
                Text("Start Game")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(swiftColor)
                            .shadow(color: swiftColor.opacity(0.4), radius: 8, y: 4)
                    )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
    
    // MARK: - Playing View (Simplified)
    private var playingView: some View {
        LiveGameView(onComplete: {
            gameMode = .results
        })
    }
    
    // MARK: - Results View
    private var resultsView: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Text("🏆")
                .font(.system(size: 80))
            
            Text("You Won!")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
            
            Text("+\(pointsBet * 2) points")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(swiftColor)
            
            Spacer()
            
            Button {
                gameMode = .menu
            } label: {
                Text("Back to Menu")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(swiftColor)
                    )
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 120)
        }
    }
    
    // MARK: - Helper
    private func generateGameCode() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<6).map { _ in letters.randomElement()! })
    }
}

// MARK: - Player Card
struct PlayerCard: View {
    let name: String
    let emoji: String
    let isReady: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Text(emoji)
                .font(.system(size: 32))
            
            Text(name)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            Spacer()
            
            if isReady {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Ready")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.green)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "2a2a2a"))
        )
    }
}

// MARK: - Live Game View (Simplified Kahoot-style)
struct LiveGameView: View {
    let onComplete: () -> Void
    @State private var currentQuestion = 0
    @State private var timeRemaining = 10
    @State private var selectedAnswer: String? = nil
    @State private var timer: Timer? = nil
    
    let swiftColor = Color(hex: "FF684B")
    let questions = [
        ("What keyword creates a variable?", ["var", "let", "const", "int"], "var"),
        ("What keyword creates a constant?", ["var", "let", "const", "final"], "let")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Timer
            HStack {
                Spacer()
                Text("\(timeRemaining)s")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(swiftColor))
            }
            .padding(20)
            
            Spacer()
            
            // Question
            Text(questions[currentQuestion].0)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Spacer()
            
            // Answers
            VStack(spacing: 16) {
                ForEach(Array(questions[currentQuestion].1.enumerated()), id: \.offset) { index, answer in
                    Button {
                        selectedAnswer = answer
                        timer?.invalidate()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            if currentQuestion < questions.count - 1 {
                                currentQuestion += 1
                                selectedAnswer = nil
                                timeRemaining = 10
                                startTimer()
                            } else {
                                onComplete()
                            }
                        }
                    } label: {
                        Text(answer)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(answerColor(answer))
                            )
                    }
                    .disabled(selectedAnswer != nil)
                }
            }
            .padding(.horizontal, 20)
            
            Spacer().frame(height: 120)
        }
        .background(Color(hex: "1a1a1a"))
        .onAppear {
            startTimer()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                selectedAnswer = ""
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    if currentQuestion < questions.count - 1 {
                        currentQuestion += 1
                        selectedAnswer = nil
                        timeRemaining = 10
                        startTimer()
                    } else {
                        onComplete()
                    }
                }
            }
        }
    }
    
    private func answerColor(_ answer: String) -> Color {
        if selectedAnswer == nil {
            return Color(hex: "2a2a2a")
        }
        
        if answer == questions[currentQuestion].2 {
            return .green.opacity(0.3)
        } else if answer == selectedAnswer {
            return .red.opacity(0.3)
        }
        
        return Color(hex: "2a2a2a")
    }
}

#Preview {
    LiveView()
}
