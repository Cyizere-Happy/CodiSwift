import SwiftUI
import ConfettiSwiftUI

// MARK: - Main Lesson View
struct NewLessonView: View {
    let level: Int
    var onComplete: (Bool) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var userManager = UserManager.shared
    @State private var currentPhase: LessonPhase = .study
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var selectedAnswer: String?
    @State private var showingResult = false
    @State private var confettiTrigger = 0
    @State private var timeRemaining = 15
    @State private var timer: Timer?
    
    // Brand Colors
    let codiColor = Color(hex: "232223")
    let swiftColor = Color(hex: "FF684B")
    let backgroundColor = Color.white // Light mode background
    let cardBackground = Color.white
    let secondaryBackground = Color(uiColor: .systemGray6)
    
    enum LessonPhase {
        case study
        case quiz
        case completed
    }
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                header
                
                // Content based on phase
                switch currentPhase {
                case .study:
                    studyPhaseView
                case .quiz:
                    quizPhaseView
                case .completed:
                    completionView
                }
            }
        }
        .confettiCannon(
            trigger: $confettiTrigger,
            confettis: [.text("🎉"), .text("⭐️"), .text("🎈"), .text("✨")],
            repetitions: 3,
            repetitionInterval: 0.7
        )
    }
    
    // MARK: - Header
    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Exit")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(.black.opacity(0.7))
            }
            
            Spacer()
            
            if currentPhase == .quiz {
                HStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 14))
                    Text("\(timeRemaining)s")
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(swiftColor)
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }
    
    // MARK: - Study Phase
    private var studyPhaseView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Title with icon
                HStack(spacing: 12) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 24))
                        .foregroundColor(swiftColor)
                    
                    Text(lessonData.title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                // Learn the concept card
                VStack(alignment: .leading, spacing: 12) {
                    Text("📚 Learn the concept first, then test your knowledge")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(swiftColor.opacity(0.9))
                        )
                }
                .padding(.horizontal, 20)
                
                // What is it section
                VStack(alignment: .leading, spacing: 12) {
                    Text("What is it?")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(lessonData.explanation)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.black.opacity(0.8))
                        .lineSpacing(4)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(cardBackground)
                        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal, 20)
                
                // Examples section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Examples")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    
                    ForEach(lessonData.examples, id: \.self) { example in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(example.code)
                                .font(.system(size: 14, design: .monospaced))
                                .foregroundColor(swiftColor)
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(secondaryBackground)
                                )
                            
                            if let explanation = example.explanation {
                                Text(explanation)
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(.black.opacity(0.7))
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // Key Points section
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "lightbulb.fill")
                        
                            .foregroundColor(.yellow)
                        Text("Key Points to Remember")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    ForEach(lessonData.keyPoints, id: \.self) { point in
                        HStack(alignment: .top, spacing: 8) {
                            Text("•")
                                .foregroundColor(.white)
                            Text(point)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(
                            colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                )
                .padding(.horizontal, 20)
                
                // Start Quiz Button
                Button {
                    withAnimation {
                        currentPhase = .quiz
                        startTimer()
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text("Start Quiz")
                            .font(.system(size: 18, weight: .bold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .bold))
                    }
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
                .padding(.bottom, 30)
            }
        }
    }
    
    // MARK: - Quiz Phase
    private var quizPhaseView: some View {
        VStack(spacing: 0) {
            // Progress bar
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(lessonData.title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.black)
                    Spacer()
                }
                
                Text("Question \(currentQuestionIndex + 1) of \(lessonData.quizQuestions.count)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black.opacity(0.6))
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.black.opacity(0.1))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(swiftColor)
                            .frame(width: geometry.size.width * CGFloat(currentQuestionIndex + 1) / CGFloat(lessonData.quizQuestions.count), height: 8)
                    }
                }
                .frame(height: 8)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            
            Spacer()
            
            if currentQuestionIndex < lessonData.quizQuestions.count {
                let question = lessonData.quizQuestions[currentQuestionIndex]
                
                VStack(spacing: 24) {
                    // Question
                    Text(question.question)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    // Points
                    HStack(spacing: 6) {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(swiftColor)
                        Text("100 points")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(swiftColor)
                    }
                    
                    // Answer options
                    VStack(spacing: 14) {
                        ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                            Button {
                                selectAnswer(option, correctAnswer: question.correctAnswer)
                            } label: {
                                HStack(spacing: 12) {
                                    Text(String(UnicodeScalar(65 + index)!))
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.black)
                                        .frame(width: 32, height: 32)
                                        .background(Circle().fill(Color.black.opacity(0.1)))
                                    
                                    Text(option)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(answerBackgroundColor(option, correctAnswer: question.correctAnswer))
                                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                                )
                            }
                            .disabled(showingResult)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            Spacer()
            
            // Score footer
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Current Score")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.black.opacity(0.6))
                    Text("\(score)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Correct Answers")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.black.opacity(0.6))
                    Text("\(score / 100)/\(lessonData.quizQuestions.count)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(swiftColor)
                }
            }
            .padding(20)
            .background(Color.white.shadow(color: .black.opacity(0.05), radius: 10, y: -5))
        }
    }
    
    // MARK: - Completion View
    private var completionView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "star.circle.fill")
                .resizable()
                .frame(width: 120, height: 120)
                .foregroundColor(.yellow)
                .rotationEffect(.degrees(confettiTrigger > 0 ? 360 : 0))
                .animation(
                    .linear(duration: 1.2)
                        .repeatForever(autoreverses: false),
                    value: confettiTrigger
                )
            
            Text("Amazing Work! 🎉")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.black)
            
            Text("You scored \(score) points!")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(swiftColor)
            
            Text("\(score / 100)/\(lessonData.quizQuestions.count) correct answers")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.black.opacity(0.7))
            
            Spacer()
            
            Button {
                // Track lesson completion with UserManager
                let correctCount = score / 100
                userManager.completeLesson(level, correctAnswers: correctCount, totalQuestions: lessonData.quizQuestions.count)
                userManager.addPoints(score)
                
                onComplete(true)
                dismiss()
            } label: {
                Text("Continue Learning ✅")
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
            .padding(.bottom, 30)
        }
    }
    
    // MARK: - Helper Functions
    private func selectAnswer(_ answer: String, correctAnswer: String) {
        selectedAnswer = answer
        showingResult = true
        timer?.invalidate()
        
        if answer == correctAnswer {
            score += 100
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if currentQuestionIndex < lessonData.quizQuestions.count - 1 {
                currentQuestionIndex += 1
                selectedAnswer = nil
                showingResult = false
                timeRemaining = 15
                startTimer()
            } else {
                currentPhase = .completed
                confettiTrigger += 1
            }
        }
    }
    
    private func answerBackgroundColor(_ answer: String, correctAnswer: String) -> Color {
        if !showingResult {
            return .white // Default light mode card
        }
        
        if answer == correctAnswer {
            return Color.green.opacity(0.2)
        } else if answer == selectedAnswer {
            return Color.red.opacity(0.2)
        }
        
        return .white
    }
    
    private func startTimer() {
        timer?.invalidate()
        timeRemaining = 15
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                // Time's up - auto select wrong answer
                timer?.invalidate()
                selectAnswer("", correctAnswer: lessonData.quizQuestions[currentQuestionIndex].correctAnswer)
            }
        }
    }
    
    private var lessonData: LessonData {
        LessonData.getData(for: level)
    }
}

// MARK: - Lesson Data Models
struct LessonData {
    let title: String
    let explanation: String
    let examples: [CodeExample]
    let keyPoints: [String]
    let quizQuestions: [QuizQuestion]
    
    static func getData(for level: Int) -> LessonData {
        switch level {
        case 1:
            return LessonData(
                title: "Variables & Constants",
                explanation: "In Swift, we store information in containers called variables and constants. Variables can change their value, while constants stay the same forever! Think of a variable like a toy box - you can put different toys in it. A constant is like a birthday - once it happens, the date never changes.",
                examples: [
                    CodeExample(
                        code: "var score = 100\nscore = 150\n// score is now 150 ✓",
                        explanation: "Variables use the \"var\" keyword and can be changed anytime."
                    ),
                    CodeExample(
                        code: "let birthday = \"January 15\"\n// birthday = \"March 20\" ✗\n// This would cause an error!",
                        explanation: "Constants use the \"let\" keyword and cannot be changed once set."
                    ),
                    CodeExample(
                        code: "var name: String = \"Alex\"\nvar age: Int = 10\nvar isStudent: Bool = true",
                        explanation: "You can specify the type of data using a colon (:) after the name."
                    )
                ],
                keyPoints: [
                    "Use \"var\" for values that change",
                    "Use \"let\" for values that stay the same",
                    "Swift can figure out types automatically",
                    "Always choose \"let\" when possible - it's safer!"
                ],
                quizQuestions: [
                    QuizQuestion(
                        question: "What keyword is used to declare a constant in Swift?",
                        options: ["var", "let", "const", "final"],
                        correctAnswer: "let"
                    ),
                    QuizQuestion(
                        question: "Which can change its value?",
                        options: ["constant", "variable", "both", "neither"],
                        correctAnswer: "variable"
                    ),
                    QuizQuestion(
                        question: "What's the keyword for a variable?",
                        options: ["let", "var", "int", "string"],
                        correctAnswer: "var"
                    ),
                    QuizQuestion(
                        question: "Which is safer to use when possible?",
                        options: ["var", "let", "both are equal", "neither"],
                        correctAnswer: "let"
                    ),
                    QuizQuestion(
                        question: "Can you change a constant after setting it?",
                        options: ["Yes, always", "No, never", "Sometimes", "Only once"],
                        correctAnswer: "No, never"
                    )
                ]
            )
        case 2:
            return LessonData(
                title: "Functions & Loops",
                explanation: "Functions are like magic spells - you give them a name and they do something special! Loops help you repeat actions without writing the same code over and over. It's like telling your robot to do jumping jacks 10 times!",
                examples: [
                    CodeExample(
                        code: "func sayHello() {\n    print(\"Hello!\")\n}\nsayHello() // Prints: Hello!",
                        explanation: "Functions let you reuse code by calling their name."
                    ),
                    CodeExample(
                        code: "for i in 1...5 {\n    print(\"Count: \\(i)\")\n}",
                        explanation: "Loops repeat code. This prints numbers 1 to 5."
                    )
                ],
                keyPoints: [
                    "Functions group code together",
                    "Loops repeat actions automatically",
                    "Use 'for' loops to count or iterate",
                    "Functions make code reusable"
                ],
                quizQuestions: [
                    QuizQuestion(
                        question: "What keyword creates a function?",
                        options: ["func", "function", "def", "method"],
                        correctAnswer: "func"
                    ),
                    QuizQuestion(
                        question: "What repeats code multiple times?",
                        options: ["function", "loop", "variable", "constant"],
                        correctAnswer: "loop"
                    ),
                    QuizQuestion(
                        question: "Which loop keyword is used in Swift?",
                        options: ["repeat", "for", "while", "all of these"],
                        correctAnswer: "all of these"
                    ),
                    QuizQuestion(
                        question: "What do functions help with?",
                        options: ["Reusing code", "Making code messy", "Slowing down apps", "Nothing"],
                        correctAnswer: "Reusing code"
                    ),
                    QuizQuestion(
                        question: "How do you call a function named 'jump'?",
                        options: ["jump()", "call jump", "run jump", "execute jump"],
                        correctAnswer: "jump()"
                    )
                ]
            )
        default:
            return LessonData(
                title: "Advanced Swift",
                explanation: "You're becoming a Swift master! Advanced concepts help you build amazing apps with smooth animations and smart architecture.",
                examples: [
                    CodeExample(
                        code: "// Advanced concepts coming soon!",
                        explanation: nil
                    )
                ],
                keyPoints: [
                    "Combine handles data flow",
                    "Animations bring apps to life",
                    "Good architecture keeps code organized"
                ],
                quizQuestions: [
                    QuizQuestion(
                        question: "What makes things move in apps?",
                        options: ["Variables", "Functions", "Animations", "Constants"],
                        correctAnswer: "Animations"
                    )
                ]
            )
        }
    }
}

struct CodeExample: Hashable {
    let code: String
    let explanation: String?
}

struct QuizQuestion {
    let question: String
    let options: [String]
    let correctAnswer: String
}

#Preview {
    NewLessonView(level: 1) { _ in }
}
