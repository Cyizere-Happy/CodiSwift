import Foundation
import SwiftUI

// MARK: - User Manager
class UserManager: ObservableObject {
    static let shared = UserManager()
    
    @Published var currentUser: User
    
    private let userKey = "currentUser"
    
    private init() {
        // Load user from UserDefaults or create new
        if let data = UserDefaults.standard.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            self.currentUser = user
            // Update streak on app launch
            self.updateStreak()
            // Refresh quests on app launch
            self.refreshQuestsIfNeeded()
        } else {
            // Create new user
            self.currentUser = User()
            self.saveUser()
        }
    }
    
    // MARK: - Save User
    func saveUser() {
        if let encoded = try? JSONEncoder().encode(currentUser) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }
    
    // MARK: - Update Streak
    func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastActive = calendar.startOfDay(for: currentUser.lastActiveDate)
        
        let daysDifference = calendar.dateComponents([.day], from: lastActive, to: today).day ?? 0
        
        if daysDifference == 0 {
            // Same day - no change
            return
        } else if daysDifference == 1 {
            // Consecutive day - increase streak
            currentUser.streak += 1
            currentUser.lastActiveDate = Date()
            
            // Check for streak badge
            if currentUser.streak == 7 {
                addBadge(.weekStreak)
            }
        } else {
            // Streak broken
            currentUser.streak = 1
            currentUser.lastActiveDate = Date()
        }
        
        saveUser()
    }
    
    // MARK: - Add Points
    func addPoints(_ points: Int) {
        currentUser.points += points
        saveUser()
    }
    
    // MARK: - Update Points (Handling deductions and additions)
    func updatePoints(_ points: Int) -> Int {
        currentUser.points = max(0, currentUser.points + points)
        saveUser()
        return currentUser.points
    }
    
    // MARK: - Quest Management
    func refreshQuestsIfNeeded() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastRefresh = currentUser.lastQuestRefreshDate {
            let lastRefreshDay = calendar.startOfDay(for: lastRefresh)
            if today > lastRefreshDay {
                resetQuests()
            }
        } else {
            resetQuests()
        }
    }
    
    private func resetQuests() {
        let questPool: [DailyQuest] = [
            DailyQuest(id: "lessons_3", title: "Complete 3 lessons", icon: "📚", type: .lessons, target: 3, progress: 0, isClaimed: false),
            DailyQuest(id: "lessons_1", title: "Finish 1 lesson", icon: "📖", type: .lessons, target: 1, progress: 0, isClaimed: false),
            DailyQuest(id: "challenges_2", title: "Solve 2 challenges", icon: "💻", type: .challenges, target: 2, progress: 0, isClaimed: false),
            DailyQuest(id: "challenges_1", title: "Solve 1 challenge", icon: "⚡", type: .challenges, target: 1, progress: 0, isClaimed: false),
            DailyQuest(id: "win_1", title: "Win 1 live game", icon: "🏆", type: .liveGames, target: 1, progress: 0, isClaimed: false),
            DailyQuest(id: "play_2", title: "Play 2 live games", icon: "🎮", type: .liveGames, target: 2, progress: 0, isClaimed: false)
        ]
        
        currentUser.dailyQuests = Array(questPool.shuffled().prefix(3))
        currentUser.lastQuestRefreshDate = Date()
        currentUser.hasClaimedDailyBonus = false
        saveUser()
    }
    
    func updateQuestProgress(action: QuestType, amount: Int = 1) {
        for i in 0..<currentUser.dailyQuests.count {
            if currentUser.dailyQuests[i].type == action {
                currentUser.dailyQuests[i].progress = min(currentUser.dailyQuests[i].target, currentUser.dailyQuests[i].progress + amount)
            }
        }
        saveUser()
    }
    
    func claimDailyBonus() -> Bool {
        let allDone = currentUser.dailyQuests.allSatisfy { $0.isCompleted }
        if allDone && !currentUser.hasClaimedDailyBonus {
            currentUser.points += 45
            currentUser.hasClaimedDailyBonus = true
            saveUser()
            return true
        }
        return false
    }
    
    // MARK: - Complete Challenge
    func completeChallenge(_ challengeId: String, points: Int) -> Bool {
        if !currentUser.completedChallenges.contains(challengeId) {
            currentUser.completedChallenges.append(challengeId)
            currentUser.points += points
            updateQuestProgress(action: .challenges)
            saveUser()
            return true // Points earned
        }
        return false // Already completed
    }
    
    // MARK: - Complete Lesson
    func completeLesson(_ level: Int, correctAnswers: Int, totalQuestions: Int) {
        if !currentUser.completedLessons.contains(level) {
            currentUser.completedLessons.append(level)
            updateQuestProgress(action: .lessons)
            
            // First lesson badge
            if currentUser.completedLessons.count == 1 {
                addBadge(.firstLesson)
            }
        }
        
        currentUser.totalQuestionsAnswered += totalQuestions
        currentUser.correctAnswers += correctAnswers
        
        // Century club badge
        if currentUser.totalQuestionsAnswered >= 100 {
            addBadge(.hundredQuestions)
        }
        
        saveUser()
    }
    
    // MARK: - Win Live Game
    func winLiveGame(pointsWon: Int) {
        currentUser.liveGamesWon += 1
        currentUser.points += pointsWon
        updateQuestProgress(action: .liveGames)
        
        // First win badge
        if currentUser.liveGamesWon == 1 {
            addBadge(.firstWin)
        }
        
        saveUser()
    }
    
    // MARK: - Lose Live Game
    func loseLiveGame(pointsLost: Int) {
        currentUser.points = max(0, currentUser.points - pointsLost)
        saveUser()
    }
    
    // MARK: - Play Live Game
    func playLiveGame() {
        currentUser.liveGamesPlayed += 1
        saveUser()
    }
    
    // MARK: - Add Badge
    private func addBadge(_ badge: Badge) {
        if !currentUser.badges.contains(where: { $0.id == badge.id }) {
            currentUser.badges.append(badge)
        }
    }
    
    // MARK: - Update Name
    func updateName(_ name: String) {
        currentUser.name = name
        saveUser()
    }
    
    // MARK: - Update Emoji
    func updateEmoji(_ emoji: String) {
        currentUser.emoji = emoji
        saveUser()
    }
}
