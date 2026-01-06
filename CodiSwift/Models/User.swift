import Foundation

// MARK: - User Model
struct User: Codable, Identifiable {
    let id: String
    var name: String
    var emoji: String // User's avatar emoji
    var points: Int
    var streak: Int
    var lastActiveDate: Date
    var rank: Int
    var completedLessons: [Int]
    var badges: [Badge]
    var totalQuestionsAnswered: Int
    var correctAnswers: Int
    var liveGamesPlayed: Int
    var liveGamesWon: Int
    
    init(
        id: String = UUID().uuidString,
        name: String = "Coder",
        emoji: String = "🧑‍💻",
        points: Int = 0,
        streak: Int = 0,
        lastActiveDate: Date = Date(),
        rank: Int = 0,
        completedLessons: [Int] = [],
        badges: [Badge] = [],
        totalQuestionsAnswered: Int = 0,
        correctAnswers: Int = 0,
        liveGamesPlayed: Int = 0,
        liveGamesWon: Int = 0
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.points = points
        self.streak = streak
        self.lastActiveDate = lastActiveDate
        self.rank = rank
        self.completedLessons = completedLessons
        self.badges = badges
        self.totalQuestionsAnswered = totalQuestionsAnswered
        self.correctAnswers = correctAnswers
        self.liveGamesPlayed = liveGamesPlayed
        self.liveGamesWon = liveGamesWon
    }
    
    var accuracy: Double {
        guard totalQuestionsAnswered > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalQuestionsAnswered) * 100
    }
    
    var tier: RankTier {
        switch points {
        case 0..<500: return .bronze
        case 500..<1500: return .silver
        case 1500..<3000: return .gold
        default: return .diamond
        }
    }
}

// MARK: - Badge
struct Badge: Codable, Identifiable {
    let id: String
    let name: String
    let emoji: String
    let description: String
    let earnedDate: Date
    
    static let firstLesson = Badge(
        id: "first_lesson",
        name: "First Steps",
        emoji: "👶",
        description: "Completed your first lesson",
        earnedDate: Date()
    )
    
    static let weekStreak = Badge(
        id: "week_streak",
        name: "Week Warrior",
        emoji: "🔥",
        description: "7-day learning streak",
        earnedDate: Date()
    )
    
    static let hundredQuestions = Badge(
        id: "hundred_questions",
        name: "Century Club",
        emoji: "💯",
        description: "Answered 100 questions",
        earnedDate: Date()
    )
    
    static let firstWin = Badge(
        id: "first_win",
        name: "Victory!",
        emoji: "🏆",
        description: "Won your first live game",
        earnedDate: Date()
    )
}

// MARK: - Rank Tier
enum RankTier: String, Codable {
    case bronze = "Bronze"
    case silver = "Silver"
    case gold = "Gold"
    case diamond = "Diamond"
    
    var color: String {
        switch self {
        case .bronze: return "CD7F32"
        case .silver: return "C0C0C0"
        case .gold: return "FFD700"
        case .diamond: return "B9F2FF"
        }
    }
    
    var emoji: String {
        switch self {
        case .bronze: return "🥉"
        case .silver: return "🥈"
        case .gold: return "🥇"
        case .diamond: return "💎"
        }
    }
}
