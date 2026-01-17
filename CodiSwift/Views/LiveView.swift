import SwiftUI
import SplineRuntime

struct LiveView: View {
    @ObservedObject var userManager = UserManager.shared
    @StateObject private var gameVM = LiveGameViewModel()
    
    
    
    var body: some View {
        ZStack {
            // Background
            if gameVM.currentMode == .menu { // Changed gameMode to gameVM.currentMode
                // Spline Scene for Menu
                SplineView(sceneFileURL: URL(string: "https://build.spline.design/07MOBgjTDL2KtTI0v2uF/scene.splineswift")!)
                    .ignoresSafeArea()
            } else {
                // Gradient for other modes
                LinearGradient(
                    colors: [Color.black, Color.darkColor],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            }
            
            switch gameVM.isGameOver ? LiveGameViewModel.ViewMode.results : gameVM.currentMode {
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
                    gameVM.currentMode = .host
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
                            .fill(Color.swiftColor)
                            .shadow(color: Color.swiftColor.opacity(0.4), radius: 8, y: 4)
                    )
                }
                
                Button {
                    gameVM.currentMode = .join
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
                            .fill(Color.darkColor)
                            .shadow(color: Color.black.opacity(0.4), radius: 8, y: 4)
                    )
                }
            }
            .frame(maxWidth: 400) // Center and limit width
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
                        gameVM.currentMode = .menu
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
                                    gameVM.pointsBet = amount
                                } label: {
                                    Text("\(amount)")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(gameVM.pointsBet == amount ? .white : .white.opacity(0.6))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(gameVM.pointsBet == amount ? Color.swiftColor : Color.cardBackground)
                                        )
                                }
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.cardBackground)
                    )
                    
                    // Your Points
                    HStack {
                        Text("Your Points:")
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        Text("\(userManager.currentUser.points)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color.swiftColor)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.cardBackground)
                    )
                }
                .padding(.horizontal, 20)
                
                // Create Game Button
                Button {
                    // Deduct points when hosting
                    _ = userManager.updatePoints(-gameVM.pointsBet)
                    gameVM.currentMode = .lobby
                    gameVM.gameCode = generateGameCode()
                } label: {
                    Text("Create Game")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.swiftColor)
                                .shadow(color: Color.swiftColor.opacity(0.4), radius: 8, y: 4)
                        )
                }
                .padding(.horizontal, 20)
                .disabled(userManager.currentUser.points < gameVM.pointsBet)
                .opacity(userManager.currentUser.points < gameVM.pointsBet ? 0.5 : 1)
                
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
                    gameVM.currentMode = .menu
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
                TextField("", text: $gameVM.gameCode)
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.cardBackground)
                    )
                    .padding(.horizontal, 40)
                
                Button {
                    // Deduct points when joining
                    _ = userManager.updatePoints(-gameVM.pointsBet)
                    gameVM.currentMode = .lobby
                } label: {
                    Text("Join Game")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.swiftColor)
                                .shadow(color: Color.swiftColor.opacity(0.4), radius: 8, y: 4)
                        )
                }
                .padding(.horizontal, 40)
                .disabled(gameVM.gameCode.count < 6)
                .opacity(gameVM.gameCode.count < 6 ? 0.5 : 1)
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
                
                Text(gameVM.gameCode)
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.swiftColor)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.cardBackground)
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
                gameVM.startTimer()
                gameVM.currentMode = .playing
            } label: {
                Text("Start Game")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.swiftColor)
                            .shadow(color: Color.swiftColor.opacity(0.4), radius: 8, y: 4)
                    )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
    
    // MARK: - Playing View
    private var playingView: some View {
        LiveGameView(gameVM: gameVM)
    }
    
    // MARK: - Results View
    private var resultsView: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Text(gameVM.userWon ? "You Won!" : "You Lost!")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 8) {
                Text(gameVM.userWon ? "+\(gameVM.pointsBet) points" : "-\(gameVM.pointsBet) points")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(gameVM.userWon ? .green : .red)
                
                Text(gameVM.userWon ? "You took them from \(gameVM.opponentName)" : "\(gameVM.opponentName) took your points")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            HStack(spacing: 40) {
                VStack {
                    Text(userManager.currentUser.emoji)
                        .font(.system(size: 40))
                    Text("You")
                        .font(.caption)
                    Text("\(gameVM.score)")
                        .font(.headline)
                }
                
                Text("VS")
                    .font(.title2.bold())
                    .foregroundColor(Color.swiftColor)
                
                VStack {
                    Text(gameVM.opponentEmoji)
                        .font(.system(size: 40))
                    Text(gameVM.opponentName)
                        .font(.caption)
                    Text("\(gameVM.opponentScore)")
                        .font(.headline)
                }
            }
            .foregroundColor(.white)
            .padding(24)
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.cardBackground))
            
            Spacer()
            
            Button {
                if gameVM.isGameOver {
                    if gameVM.userWon {
                        _ = userManager.updatePoints(gameVM.pointsBet * 2)
                        userManager.updateQuestProgress(action: .liveGames, amount: 1)
                    }
                    // Points were already deducted upon entering gameVM.host or gameVM.join views
                }
                gameVM.reset()
                gameVM.currentMode = .menu
            } label: {
                Text("Back to Menu")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.swiftColor)
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
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cardBackground)
        )
    }
}

// MARK: - Live Game View (Simplified Kahoot-style)
struct LiveGameView: View {
    @ObservedObject var gameVM: LiveGameViewModel
    @Environment(\.horizontalSizeClass) var sizeClass
    
    
    
    var body: some View {
        VStack(spacing: 0) {
            // Timer & Score
            HStack {
                Text("Score: \(gameVM.score)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(gameVM.timeRemaining)s")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(Color.swiftColor))
            }
            .padding(20)
            
            Spacer()
            
            // Question
            if let question = gameVM.currentQuestion {
                Text(question.question)
                    .font(.system(size: sizeClass == .regular ? 40 : 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .id(gameVM.currentQuestionIndex) // Force refresh for animation
                    .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
            }
            
            Spacer()
            
            // Answers
            if let question = gameVM.currentQuestion {
                let columns = [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ]
                
                LazyVGrid(columns: sizeClass == .regular ? columns : [GridItem(.flexible())], spacing: 16) {
                    ForEach(question.options, id: \.self) { answer in
                        Button {
                            gameVM.handleAnswer(answer)
                        } label: {
                            Text(answer)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: sizeClass == .regular ? 100 : 64)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(answerColor(answer, question: question))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        }
                        .disabled(gameVM.selectedAnswer != nil)
                    }
                }
                .padding(.horizontal, sizeClass == .regular ? 60 : 20)
                .padding(.bottom, sizeClass == .regular ? 60 : 40)
            }
        }
        .background(Color(hex: "1a1a1a"))
    }
    
    private func answerColor(_ answer: String, question: LiveQuestion) -> Color {
        if gameVM.selectedAnswer == nil {
            return Color.cardBackground
        }
        
        if answer == question.correctAnswer {
            return .green.opacity(0.6)
        } else if answer == gameVM.selectedAnswer {
            return .red.opacity(0.6)
        }
        
        return Color.cardBackground
    }
}

#Preview {
    LiveView()
}
