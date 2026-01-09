import SwiftUI
import SplineRuntime

struct PracticeView: View {
    @ObservedObject var userManager = UserManager.shared
    @State private var selectedCategory: ChallengeCategory? = nil
    
    // Theme Colors
    let swiftColor = Color(hex: "FF684B") // The main brand orange from HomeScreen
    let backgroundColor = Color(red: 248/255, green: 249/255, blue: 253/255)
    let cardBackgroundColor = Color.white
    
    // Category Data
    var categories: [ChallengeCategory] {
        [
            ChallengeCategory(
                id: "variables",
                name: "Variables",
                emoji: "📦", 
                color: "FF684B", // Updated to match Brand Orange
                challengeCount: 5,
                iconSystemName: "cube.box.fill"
            ),
            ChallengeCategory(
                id: "functions",
                name: "Functions",
                emoji: "⚡️",
                color: "3B7AD9", // Blue
                challengeCount: 5,
                iconSystemName: "bolt.fill"
            ),
            ChallengeCategory(
                id: "loops",
                name: "Loops",
                emoji: "🔄",
                color: "58B043", // Green
                challengeCount: 5,
                iconSystemName: "arrow.triangle.2.circlepath"
            ),
            ChallengeCategory(
                id: "conditionals",
                name: "Conditionals",
                emoji: "🤔",
                color: "E8A62A", // Yellow/Gold
                challengeCount: 5,
                iconSystemName: "questionmark.circle.fill"
            )
        ]
    }
    
    var body: some View {
        ZStack {
            // Light Background
            backgroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Header Area
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Practice")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(swiftColor) // Updated to Brand Orange
                        
                        Text("Master Swift through coding challenges")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Daily Practice Card (with Spline)
                    dailyPracticeCard
                        .padding(.horizontal, 20)
                    
                    // Categories Grid
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Choose a Topic")
                            .font(.title2.bold())
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                        
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                            ForEach(categories) { category in
                                CategoryCard(category: category) {
                                    selectedCategory = category
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer().frame(height: 120)
                }
            }
        }
        .sheet(item: $selectedCategory) { category in
            ChallengeListView(category: category)
        }
    }
    
    // MARK: - Daily Practice Card
    private var dailyPracticeCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "trophy.fill")
                    .foregroundColor(swiftColor) // Updated to Brand Orange
                Text("Daily Practice")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.black.opacity(0.6))
            .cornerRadius(10)
            
            Text("Complete 3 challenges today!")
                .font(.subheadline)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
            
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.4), lineWidth: 4)
                        .frame(width: 36, height: 36)
                    
                    Circle()
                        .trim(from: 0, to: 1/3)
                        .stroke(swiftColor, style: StrokeStyle(lineWidth: 4, lineCap: .round)) // Updated to Brand Orange
                        .frame(width: 36, height: 36)
                        .rotationEffect(.degrees(-90))
                }
                
                Text("1/3")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ZStack {
                Color(hex: "222322").opacity(0.8)
                try? SplineView(sceneFileURL: URL(string: "https://build.spline.design/7EKuO-pVexGZEPme4WHy/scene.splineswift")!)
            }
        )
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 5)
    }
}

// MARK: - Category Card
struct CategoryCard: View {
    let category: ChallengeCategory
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                // Icon
                Image(systemName: category.iconSystemName)
                    .font(.system(size: 32))
                    .foregroundColor(Color(hex: category.color))
                    .frame(width: 64, height: 64)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(hex: category.color).opacity(0.1))
                    )
                
                VStack(spacing: 4) {
                    Text(category.name)
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Text("\(category.challengeCount) challenges")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .background(Color.white)
            .cornerRadius(24)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        }
    }
}

// MARK: - Challenge Category Model
struct ChallengeCategory: Identifiable {
    let id: String
    let name: String
    let emoji: String
    let color: String
    let challengeCount: Int
    let iconSystemName: String
}

// MARK: - Challenge List View
struct ChallengeListView: View {
    let category: ChallengeCategory
    @Environment(\.dismiss) private var dismiss
    @State private var selectedChallenge: Challenge? = nil
    
    var challenges: [Challenge] {
        Challenge.getChallenges(for: category.id)
    }
    
    var body: some View {
        ZStack {
            Color(red: 248/255, green: 249/255, blue: 253/255).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding()
                            .background(Circle().fill(Color.white))
                            .shadow(color: .black.opacity(0.05), radius: 5)
                    }
                    
                    Spacer()
                    
                    Text(category.name)
                        .font(.title3.bold())
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.clear)
                            .padding()
                    }.disabled(true)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Hero
                        VStack(spacing: 16) {
                            Image(systemName: category.iconSystemName)
                                .font(.system(size: 48))
                                .foregroundColor(Color(hex: category.color))
                                .padding(30)
                                .background(
                                    Circle()
                                        .fill(Color(hex: category.color).opacity(0.1))
                                )
                            
                            Text("Master \(category.name)")
                                .font(.title2.bold())
                                .foregroundColor(.black)
                        }
                        .padding(.vertical, 20)
                        
                        // Lis
                        ForEach(challenges) { challenge in
                            ChallengeRow(challenge: challenge) {
                                selectedChallenge = challenge
                            }
                        }
                    }
                    .padding(50)
                }
            }
        }
        .sheet(item: $selectedChallenge) { challenge in
            ChallengeDetailView(challenge: challenge)
        }
    }
}

// MARK: - Challenge Row
struct ChallengeRow: View {
    let challenge: Challenge
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(difficultyColor.opacity(0.15))
                        .frame(width: 48, height: 48)
                    Text(difficultyEmoji)
                        .font(.system(size: 20))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(challenge.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black) // Fixed to black for light mode
                    
                    HStack {
                        Text("\(challenge.points) pts")
                            .font(.caption.bold())
                            .foregroundColor(Color(hex: "FF684B")) // Matches Brand Orange
                        
                        Text("•")
                            .foregroundColor(.gray)
                        
                        Text(challenge.difficulty.rawValue)
                            .font(.caption)
                            .foregroundColor(difficultyColor)
                    }
                }
                
                Spacer()
                
                Image(systemName: "play.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color(hex: "FF684B")) // Play button also brand orange
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
        }
    }
    
    private var difficultyColor: Color {
        switch challenge.difficulty {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
    
    private var difficultyEmoji: String {
        switch challenge.difficulty {
        case .easy: return "⚡️"
        case .medium: return "🔥"
        case .hard: return "☠️"
        }
    }
}

// MARK: - Challenge Model & Data
struct Challenge: Identifiable {
    let id: String
    let title: String
    let description: String
    let difficulty: Difficulty
    let category: String
    let starterCode: String
    let solution: String
    let testCases: [TestCase]
    let points: Int
    
    enum Difficulty: String {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
    
    static func getChallenges(for category: String) -> [Challenge] {
        switch category {
        case "variables":
            return [
                Challenge(
                    id: "var1",
                    title: "Hello World",
                    description: "Create a variable called message with 'Hello World'",
                    difficulty: .easy,
                    category: "variables",
                    starterCode: "var message = ",
                    solution: "var message = \"Hello World\"",
                    testCases: [],
                    points: 50
                ),
                 Challenge(
                    id: "var2",
                    title: "Scorekeeper",
                    description: "Update the score variable to 50",
                    difficulty: .easy,
                    category: "variables",
                    starterCode: "var score = 10\n// Update score below\n",
                    solution: "score = 50",
                    testCases: [],
                    points: 50
                ),
                Challenge(
                    id: "var3",
                    title: "Constant Truths",
                    description: "Declare a constant named pi with value 3.14",
                    difficulty: .medium,
                    category: "variables",
                    starterCode: "",
                    solution: "let pi = 3.14",
                    testCases: [],
                    points: 100
                ),
                Challenge(
                    id: "var4",
                    title: "Type Inference",
                    description: "Create a String variable without specifying the type",
                    difficulty: .easy,
                    category: "variables",
                    starterCode: "",
                    solution: "var str = \"text\"",
                    testCases: [],
                    points: 50
                ),
                Challenge(
                    id: "var5",
                    title: "User Profile",
                    description: "Create variables for firstName, lastName, and age",
                    difficulty: .medium,
                    category: "variables",
                    starterCode: "",
                    solution: "var firstName = \"\"\nvar lastName = \"\"\nvar age = 0",
                    testCases: [],
                    points: 100
                )
            ]
        case "functions":
             return [
                Challenge(
                    id: "func1",
                    title: "Simple Greeting",
                    description: "Write a function greet() that prints 'Hi'",
                    difficulty: .easy,
                    category: "functions",
                    starterCode: "",
                    solution: "func greet() { print(\"Hi\") }",
                    testCases: [],
                    points: 50
                ),
                Challenge(
                    id: "func2",
                    title: "Add Numbers",
                    description: "Write function add(a: Int, b: Int) -> Int",
                    difficulty: .medium,
                    category: "functions",
                    starterCode: "",
                    solution: "func add(a: Int, b: Int) -> Int { return a + b }",
                    testCases: [],
                    points: 100
                ),
                Challenge(
                    id: "func3",
                    title: "Squarer",
                    description: "Return the square of a number",
                    difficulty: .medium,
                    category: "functions",
                    starterCode: "",
                    solution: "func square(_ x: Int) -> Int { return x * x }",
                    testCases: [],
                    points: 100
                ),
                Challenge(
                    id: "func4",
                    title: "Say My Name",
                    description: "Function expecting a name parameter",
                    difficulty: .easy,
                    category: "functions",
                    starterCode: "",
                    solution: "func say(name: String) { print(name) }",
                    testCases: [],
                    points: 50
                ),
                Challenge(
                    id: "func5",
                    title: "Complex Calc",
                    description: "Perform multiple operations",
                    difficulty: .hard,
                    category: "functions",
                    starterCode: "",
                    solution: "func calculate(a: Int, b: Int) -> Int { (a + b) * 2 }",
                    testCases: [],
                    points: 150
                )
            ]
        case "loops":
            return [
                Challenge(
                    id: "loop1",
                    title: "Count to Ten",
                    description: "Print numbers 1 through 10",
                    difficulty: .easy,
                    category: "loops",
                    starterCode: "",
                    solution: "for i in 1...10 { print(i) }",
                    testCases: [],
                    points: 50
                ),
                Challenge(
                    id: "loop2",
                    title: "Even Numbers",
                    description: "Print even numbers up to 20",
                    difficulty: .medium,
                    category: "loops",
                    starterCode: "",
                    solution: "for i in 1...20 where i % 2 == 0 { print(i) }",
                    testCases: [],
                    points: 100
                ),
                Challenge(
                    id: "loop3",
                    title: "Array Loop",
                    description: "Iterate over an array of names",
                    difficulty: .easy,
                    category: "loops",
                    starterCode: "let names = [\"A\", \"B\"]\n",
                    solution: "for name in names { print(name) }",
                    testCases: [],
                    points: 50
                ),
                Challenge(
                    id: "loop4",
                    title: "While Input",
                    description: "Loop while condition is true",
                    difficulty: .medium,
                    category: "loops",
                    starterCode: "",
                    solution: "while true { break }",
                    testCases: [],
                    points: 100
                ),
                Challenge(
                    id: "loop5",
                    title: "Grid Printer",
                    description: "Nested loops to print a grid",
                    difficulty: .hard,
                    category: "loops",
                    starterCode: "",
                    solution: "for i in 1...3 { for j in 1...3 { print(i, j) } }",
                    testCases: [],
                    points: 150
                )
            ]
        case "conditionals":
            return [
                Challenge(
                    id: "cond1",
                    title: "Age Check",
                    description: "Check if age is >= 18",
                    difficulty: .easy,
                    category: "conditionals",
                    starterCode: "var age = 20\n",
                    solution: "if age >= 18 { print(\"Adult\") }",
                    testCases: [],
                    points: 50
                ),
                 Challenge(
                    id: "cond2",
                    title: "Temperature",
                    description: "Print 'Cold' if temp < 10",
                    difficulty: .easy,
                    category: "conditionals",
                    starterCode: "var temp = 5\n",
                    solution: "if temp < 10 { print(\"Cold\") }",
                    testCases: [],
                    points: 50
                ),
                 Challenge(
                    id: "cond3",
                    title: "Grade Calculator",
                    description: "Convert score to letter grade",
                    difficulty: .medium,
                    category: "conditionals",
                    starterCode: "",
                    solution: "if score >= 90 { grade = \"A\" }",
                    testCases: [],
                    points: 100
                ),
                 Challenge(
                    id: "cond4",
                    title: "Login Check",
                    description: "Check username and password",
                    difficulty: .medium,
                    category: "conditionals",
                    starterCode: "",
                    solution: "if user == \"admin\" && pass == \"1234\" { loggedIn = true }",
                    testCases: [],
                    points: 100
                ),
                 Challenge(
                    id: "cond5",
                    title: "Switch It Up",
                    description: "Use a switch statement",
                    difficulty: .hard,
                    category: "conditionals",
                    starterCode: "",
                    solution: "switch color { case \"red\": print(\"stop\") default: print(\"go\") }",
                    testCases: [],
                    points: 150
                )
            ]
        default:
            return []
        }
    }
}

struct TestCase {
    let input: String
    let expectedOutput: String
    let description: String
}

// MARK: - Code Editor Component
struct CodeEditorView: View {
    @Binding var code: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Background for the editor
            Color(hex: "1E1E1E") // VS Code dark background
                .cornerRadius(12)
            
            // Syntax Highlighting Overlay
            Text(applyHighlighting(to: code))
                .font(.system(.body, design: .monospaced))
                .padding(12)
                .foregroundColor(.white)
                .opacity(1)
            
            // Transparent TextEditor for user input
            TextEditor(text: $code)
                .font(.system(.body, design: .monospaced))
                .padding(12)
                .scrollContentBackground(.hidden)
                .foregroundColor(.clear)
                .accentColor(.blue)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
        }
    }
    
    private func applyHighlighting(to text: String) -> AttributedString {
        var attributedString = AttributedString(text)
        
        let keywords = ["var", "let", "func", "class", "if", "else", "return", "print", "true", "false", "for", "in", "while", "break", "import"]
        let types = ["Int", "String", "Double", "Bool", "View", "some"]
        
        // Default text color
        attributedString.foregroundColor = .white
        
        let characters = attributedString.characters
        
        // Highlight keywords (Purple)
        for keyword in keywords {
            var searchRange = attributedString.startIndex..<attributedString.endIndex
            while let r = attributedString[searchRange].range(of: keyword) {
                // Ensure it's a whole word
                let isStart = r.lowerBound == attributedString.startIndex || 
                              characters[characters.index(before: r.lowerBound)].isWhitespace ||
                              "()[]{}:.;,".contains(characters[characters.index(before: r.lowerBound)])
                
                let isEnd = r.upperBound == attributedString.endIndex ||
                            characters[r.upperBound].isWhitespace ||
                            "()[]{}:.;,".contains(characters[r.upperBound])
                
                if isStart && isEnd {
                    attributedString[r].foregroundColor = Color(hex: "C586C0") // VS Code Magenta
                }
                
                searchRange = r.upperBound..<attributedString.endIndex
            }
        }
        
        // Highlight types (Teal/Blue)
        for type in types {
            var searchRange = attributedString.startIndex..<attributedString.endIndex
            while let r = attributedString[searchRange].range(of: type) {
                attributedString[r].foregroundColor = Color(hex: "4EC9B0") // VS Code Teal
                searchRange = r.upperBound..<attributedString.endIndex
            }
        }
        
        // Highlight Strings (Orange/Coral)
        var searchRange = attributedString.startIndex..<attributedString.endIndex
        while let start = attributedString[searchRange].range(of: "\"") {
            let restRange = start.upperBound..<attributedString.endIndex
            if let end = attributedString[restRange].range(of: "\"") {
                attributedString[start.lowerBound...end.upperBound].foregroundColor = Color(hex: "CE9178") // VS Code String orange
                searchRange = end.upperBound..<attributedString.endIndex
            } else {
                break
            }
        }
        
        return attributedString
    }
}

// MARK: - Challenge Detail View
struct ChallengeDetailView: View {
    let challenge: Challenge
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var userManager = UserManager.shared
    
    @State private var code: String = ""
    @State private var executionResult: String = ""
    @State private var isSuccess: Bool = false
    @State private var hasValidated: Bool = false
    @State private var showingConfetti: Bool = false
    
    init(challenge: Challenge) {
        self.challenge = challenge
        self._code = State(initialValue: challenge.starterCode)
    }
    
    var body: some View {
        ZStack {
            Color(red: 248/255, green: 249/255, blue: 253/255).ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(challenge.title)
                            .font(.title2.bold())
                            .foregroundColor(.black)
                        
                        Text(challenge.difficulty.rawValue)
                            .font(.caption.bold())
                            .foregroundColor(difficultyColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(difficultyColor.opacity(0.1))
                            .cornerRadius(6)
                    }
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding(8)
                            .background(Circle().fill(Color.white))
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Instructions
                VStack(alignment: .leading, spacing: 8) {
                    Text("Instruction")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Text(challenge.description)
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Editor
                CodeEditorView(code: $code)
                    .frame(maxHeight: .infinity)
                    .padding(.horizontal)
                
                // Result Panel
                if hasValidated {
                    HStack {
                        Image(systemName: isSuccess ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                            .foregroundColor(isSuccess ? .green : .red)
                        
                        Text(executionResult)
                            .font(.subheadline)
                            .foregroundColor(isSuccess ? .green : .red)
                        
                        Spacer()
                        
                        if isSuccess && !showingConfetti {
                            Button("Submit & Earn \(challenge.points) pts") {
                                submitChallenge()
                            }
                            .font(.headline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color(hex: "FF684B"))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background((isSuccess ? Color.green : Color.red).opacity(0.1))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                
                // Action Buttons
                HStack(spacing: 16) {
                    Button(action: { runCode() }) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Run Code")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            
            if showingConfetti {
                successOverlay
            }
        }
    }
    
    private var difficultyColor: Color {
        switch challenge.difficulty {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
    
    private var successOverlay: some View {
        ZStack {
            Color.white.opacity(0.8).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("🎉")
                    .font(.system(size: 80))
                
                Text("Excellent!")
                    .font(.title.bold())
                    .foregroundColor(.black)
                
                Text("You've earned \(challenge.points) points!")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Button("Keep Practicing") {
                    dismiss()
                }
                .font(.headline)
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .background(Color(hex: "FF684B"))
                .foregroundColor(.white)
                .cornerRadius(20)
            }
        }
    }
    
    private func runCode() {
        // Normalize both strings to handle smart quotes, spaces, and case
        let normalizedUserCode = code.normalizedForComparison()
        let normalizedSolution = challenge.solution.normalizedForComparison()
        
        // Only accept if the user code contains the full normalized solution
        // and is not just a substring of the solution (which caused early false positives)
        if !normalizedSolution.isEmpty && normalizedUserCode.contains(normalizedSolution) {
            isSuccess = true
            executionResult = "Great job! Your code works perfectly."
        } else {
            isSuccess = false
            executionResult = "Not quite right yet. Keep coding!"
        }
        hasValidated = true
    }
    
    private func submitChallenge() {
        userManager.addPoints(challenge.points)
        withAnimation {
            showingConfetti = true
        }
    }
}

extension String {
    func normalizedForComparison() -> String {
        return self.lowercased()
            .replacingOccurrences(of: "“", with: "\"")
            .replacingOccurrences(of: "”", with: "\"")
            .replacingOccurrences(of: "‘", with: "'")
            .replacingOccurrences(of: "’", with: "'")
            .components(separatedBy: .whitespacesAndNewlines)
            .joined()
    }
    
    // Kept for backward compatibility if used elsewhere, but marked as deprecated-ish
    func removingWhitespacesAndNewlines() -> String {
        return self.components(separatedBy: .whitespacesAndNewlines).joined()
    }
}

#Preview {
    PracticeView()
}
