import SwiftUI
import Combine

struct LiveQuestion: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctAnswer: String
}

class LiveGameViewModel: ObservableObject {
    enum ViewMode {
        case menu
        case host
        case join
        case lobby
        case playing
        case results
    }

    @Published var currentMode: ViewMode = .menu
    @Published var gameCode = ""
    @Published var pointsBet = 100
    
    @Published var currentQuestionIndex = 0
    @Published var timeRemaining = 15
    @Published var selectedAnswer: String? = nil
    @Published var score = 0
    @Published var isGameOver = false
    @Published var questions: [LiveQuestion] = []
    
    // Opponent Simulation
    @Published var opponentName = "Alex"
    @Published var opponentScore = 0
    @Published var opponentEmoji = "👨‍💻"
    
    private var timer: AnyCancellable?
    private let totalQuestions = 5
    
    init() {
        setupQuestions()
    }
    
    func setupQuestions() {
        let pool = [
            LiveQuestion(question: "Which keyword is used to declare a constant in Swift?", options: ["var", "let", "const", "final"], correctAnswer: "let"),
            LiveQuestion(question: "What is the result of 5 + 3 * 2?", options: ["16", "11", "13", "10"], correctAnswer: "11"),
            LiveQuestion(question: "Which of these is a value type in Swift?", options: ["Class", "Struct", "Function", "Closure"], correctAnswer: "Struct"),
            LiveQuestion(question: "How do you define a function in Swift?", options: ["func name()", "def name()", "function name()", "void name()"], correctAnswer: "func name()"),
            LiveQuestion(question: "Which collection type stores unique values?", options: ["Array", "Dictionary", "Set", "List"], correctAnswer: "Set"),
            LiveQuestion(question: "What does '??' operator do?", options: ["Force unwrap", "Nil coalescing", "Comparison", "Ternary"], correctAnswer: "Nil coalescing"),
            LiveQuestion(question: "How do you start a for loop in Swift?", options: ["for i in 0...5", "for (i=0; i<5; i++)", "foreach i in collection", "loop i to 5"], correctAnswer: "for i in 0...5"),
            LiveQuestion(question: "Which keyword is used to handle errors?", options: ["catch", "try", "error", "handle"], correctAnswer: "try"),
            LiveQuestion(question: "What type is 'true' or 'false'?", options: ["String", "Int", "Bool", "Double"], correctAnswer: "Bool"),
            LiveQuestion(question: "Which keyword is used for inheritance in Classes?", options: ["extends", "implements", "inherits", ":"], correctAnswer: ":")
        ]
        
        self.questions = Array(pool.shuffled().prefix(totalQuestions))
    }
    
    var currentQuestion: LiveQuestion? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    func startTimer() {
        timer?.cancel()
        timeRemaining = 15
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.handleTimeOut()
                }
            }
    }
    
    func handleAnswer(_ answer: String) {
        timer?.cancel()
        selectedAnswer = answer
        
        if answer == currentQuestion?.correctAnswer {
            score += 100 + (timeRemaining * 10) // Bonus for speed
        }
        
        // Simulating opponent progress
        simulateOpponent()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.nextQuestion()
        }
    }
    
    private func handleTimeOut() {
        timer?.cancel()
        selectedAnswer = "" // Indicates no selection
        
        simulateOpponent()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.nextQuestion()
        }
    }
    
    private func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswer = nil
            startTimer()
        } else {
            isGameOver = true
        }
    }
    
    func reset() {
        currentQuestionIndex = 0
        score = 0
        opponentScore = 0
        isGameOver = false
        selectedAnswer = nil
        setupQuestions()
    }
    
    private func simulateOpponent() {
        // Randomly add points to opponent
        let correct = Bool.random()
        if correct {
            let speedBonus = Int.random(in: 0...15) * 10
            opponentScore += 100 + speedBonus
        }
    }
    
    var userWon: Bool {
        score >= opponentScore
    }
}
