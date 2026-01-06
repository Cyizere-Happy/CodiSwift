import SwiftUI

struct PracticeView: View {
    @ObservedObject var userManager = UserManager.shared
    @State private var selectedCategory: ChallengeCategory? = nil
    
    let swiftColor = Color(hex: "FF684B")
    let darkColor = Color(hex: "232223")
    let cardBackground = Color(hex: "2a2a2a")
    
    let categories: [ChallengeCategory] = [
        ChallengeCategory(
            id: "variables",
            name: "Variables",
            emoji: "📦",
            color: "FF684B",
            challengeCount: 5
        ),
        ChallengeCategory(
            id: "functions",
            name: "Functions",
            emoji: "⚡️",
            color: "4A90E2",
            challengeCount: 5
        ),
        ChallengeCategory(
            id: "loops",
            name: "Loops",
            emoji: "🔄",
            color: "7ED321",
            challengeCount: 5
        ),
        ChallengeCategory(
            id: "conditionals",
            name: "Conditionals",
            emoji: "🤔",
            color: "F5A623",
            challengeCount: 5
        )
    ]
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "1a1a1a"), Color(hex: "232223")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    header
                    
                    // Practice Streak
                    practiceStreakCard
                    
                    // Categories Grid
                    categoriesSection
                    
                    Spacer().frame(height: 100) // Tab bar padding
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .sheet(item: $selectedCategory) { category in
            ChallengeListView(category: category)
        }
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Practice")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
            
            Text("Master Swift through coding challenges")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Practice Streak Card
    private var practiceStreakCard: some View {
        HStack(spacing: 16) {
            // Trophy icon
            ZStack {
                Circle()
                    .fill(Color.yellow.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Text("🏆")
                    .font(.system(size: 32))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Daily Practice")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Complete 3 challenges today!")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            // Progress circle
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 4)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .trim(from: 0, to: 0.33) // Example: 1/3 complete
                    .stroke(swiftColor, lineWidth: 4)
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))
                
                Text("1/3")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(cardBackground)
        )
    }
    
    // MARK: - Categories Section
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose a Topic")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(categories) { category in
                    CategoryCard(category: category) {
                        selectedCategory = category
                    }
                }
            }
        }
    }
}

// MARK: - Category Card
struct CategoryCard: View {
    let category: ChallengeCategory
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Text(category.emoji)
                    .font(.system(size: 48))
                
                Text(category.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Text("\(category.challengeCount) challenges")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: category.color).opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: category.color), lineWidth: 2)
                    )
            )
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
}

// MARK: - Challenge List View
struct ChallengeListView: View {
    let category: ChallengeCategory
    @Environment(\.dismiss) private var dismiss
    @State private var selectedChallenge: Challenge? = nil
    
    let swiftColor = Color(hex: "FF684B")
    let cardBackground = Color(hex: "2a2a2a")
    
    var challenges: [Challenge] {
        Challenge.getChallenges(for: category.id)
    }
    
    var body: some View {
        ZStack {
            Color(hex: "1a1a1a")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Back")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 12)
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Category Header
                        HStack(spacing: 12) {
                            Text(category.emoji)
                                .font(.system(size: 40))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(category.name)
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("\(challenges.count) challenges")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        
                        // Challenges List
                        ForEach(challenges) { challenge in
                            ChallengeRow(challenge: challenge) {
                                selectedChallenge = challenge
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer().frame(height: 20)
                    }
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
    
    let swiftColor = Color(hex: "FF684B")
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Difficulty indicator
                ZStack {
                    Circle()
                        .fill(difficultyColor.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Text(difficultyEmoji)
                        .font(.system(size: 24))
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(challenge.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 12) {
                        Label("\(challenge.points) pts", systemImage: "star.fill")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(swiftColor)
                        
                        Text(challenge.difficulty.rawValue)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(difficultyColor)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "2a2a2a"))
            )
        }
    }
    
    private var difficultyColor: Color {
        switch challenge.difficulty {
        case .easy: return .green
        case .medium: return .yellow
        case .hard: return .red
        }
    }
    
    private var difficultyEmoji: String {
        switch challenge.difficulty {
        case .easy: return "😊"
        case .medium: return "🤔"
        case .hard: return "🔥"
        }
    }
}

// MARK: - Challenge Model
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
                    title: "Create a Variable",
                    description: "Create a variable called 'score' with value 100",
                    difficulty: .easy,
                    category: "variables",
                    starterCode: "// Create your variable here\n",
                    solution: "var score = 100",
                    testCases: [
                        TestCase(input: "", expectedOutput: "score = 100", description: "Variable should equal 100")
                    ],
                    points: 50
                ),
                Challenge(
                    id: "var2",
                    title: "Create a Constant",
                    description: "Create a constant called 'name' with your name",
                    difficulty: .easy,
                    category: "variables",
                    starterCode: "// Create your constant here\n",
                    solution: "let name = \"Alex\"",
                    testCases: [
                        TestCase(input: "", expectedOutput: "name is constant", description: "Should use 'let' keyword")
                    ],
                    points: 50
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

// MARK: - Challenge Detail View (Placeholder)
struct ChallengeDetailView: View {
    let challenge: Challenge
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color(hex: "1a1a1a")
                .ignoresSafeArea()
            
            VStack {
                Text("Challenge: \(challenge.title)")
                    .font(.title)
                    .foregroundColor(.white)
                
                Text("Coming soon: Code editor!")
                    .foregroundColor(.white.opacity(0.7))
                
                Button("Close") {
                    dismiss()
                }
                .padding()
            }
        }
    }
}

#Preview {
    PracticeView()
}
