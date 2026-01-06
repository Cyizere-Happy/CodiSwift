import SwiftUI
import ConfettiSwiftUI

struct LessonView: View {
    let level: Int
    var onComplete: (Bool) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var isCompleted = false
    @State private var selectedAnswer: String?
    @State private var confettiTrigger = 0
    
    // Brand Colors
    let codiColor = Color(hex: "232223")   // dark base for text
    let swiftColor = Color(hex: "FF684B")  // main orange accent
    
    var body: some View {
        ZStack {
            // Light background
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Title
                Text("Lesson \(level) 🚀")
                    .font(.largeTitle.bold())
                    .foregroundColor(swiftColor)
                
                // Lesson Content
                ScrollView {
                    Text(lessonContent)
                        .font(.title3.bold())
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(swiftColor.opacity(0.15))
                        .foregroundColor(codiColor)
                        .cornerRadius(20)
                        .shadow(color: swiftColor.opacity(0.3), radius: 5, x: 0, y: 3)
                        .padding(.horizontal)
                }
                .frame(maxHeight: 220)
                
                // Quiz
                if !isCompleted {
                    Text(quizQuestion)
                        .font(.title2.bold())
                        .foregroundColor(codiColor)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    VStack(spacing: 14) {
                        ForEach(answers, id: \.self) { answer in
                            Button {
                                selectedAnswer = answer
                                if answer == correctAnswer {
                                    withAnimation {
                                        isCompleted = true
                                        confettiTrigger += 1
                                    }
                                } else {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        selectedAnswer = nil
                                    }
                                }
                            } label: {
                                Text(answer)
                                    .font(.headline)
                                    .foregroundColor(selectedAnswer == answer ? .white : swiftColor)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(buttonColor(for: answer))
                                    .cornerRadius(15)
                                    .scaleEffect(selectedAnswer == answer ? 0.95 : 1)
                                    .animation(.spring(), value: selectedAnswer)
                            }
                        }
                    }
                    .padding(.horizontal)
                } else {
                    // Celebration
                    VStack(spacing: 20) {
                        Text("You did it! 🎉🏆")
                            .font(.title.bold())
                            .foregroundColor(swiftColor)
                        
                        Image(systemName: "star.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.yellow)
                            .rotationEffect(.degrees(isCompleted ? 360 : 0))
                            .animation(
                                .linear(duration: 1.2)
                                    .repeatForever(autoreverses: false),
                                value: isCompleted
                            )
                    }
                }
                
                Spacer()
                
                // Complete Button
                Button {
                    onComplete(true)
                    dismiss()
                } label: {
                    Text("Mark as Completed ✅")
                        .font(.headline.bold())
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isCompleted ? swiftColor : swiftColor.opacity(0.6))
                        .cornerRadius(18)
                }
                .disabled(!isCompleted)
                .padding(.horizontal)
            }
            .padding()
            .confettiCannon(
                trigger: $confettiTrigger,
                confettis: [.text("🎉"), .text("⭐️"), .text("🎈"), .text("✨")],
                repetitions: 3,
                repetitionInterval: 0.7
            )
        }
    }
    
    // Helpers
    private func buttonColor(for answer: String) -> Color {
        if let selected = selectedAnswer, selected == answer {
            return answer == correctAnswer ? swiftColor : .red
        }
        return swiftColor.opacity(0.2)
    }
    
    private var lessonContent: String {
        switch level {
        case 1:
            return """
            Welcome Super Coder! 😄
            • var → changeable box 🧸
            • let → locked box 🔒
            • String, Int, Bool → labels 📦
            """
        case 2:
            return """
            Level 2 unlocked! 🥳
            • Functions = magic 🪄
            • Loops = repeat 🔄
            • Conditionals = choices ❓
            """
        case 3:
            return """
            Level 3 hero! 🌟
            • Combine = messenger 📡
            • Animations = movement 💃
            • Architecture = castle 🏰
            """
        case 4:
            return """
            Mastery level! 🧠
            • Arrays = lists 📋
            • Dictionaries = pairs 🔑
            • Index = positions 📍
            """
        default:
            return "Coming soon! 🚧"
        }
    }
    
    private var quizQuestion: String {
        switch level {
        case 1: return "Which keyword creates a variable?"
        case 2: return "What repeats code?"
        case 3: return "What makes things move?"
        case 4: return "What do Arrays use to find items?"
        default: return ""
        }
    }
    
    private var correctAnswer: String {
        switch level {
        case 1: return "var"
        case 2: return "Loop"
        case 3: return "Animation"
        case 4: return "Index"
        default: return ""
        }
    }
    
    private var answers: [String] {
        switch level {
        case 1: return ["let", "var", "box"]
        case 2: return ["Function", "Loop", "Choice"]
        case 3: return ["Messenger", "Animation", "Castle"]
        case 4: return ["Index", "Keys", "Names"]
        default: return []
        }
    }
}

#Preview {
    LessonView(level: 1) { _ in }
}
