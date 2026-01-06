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
    
    // MARK: - Complete Lesson
    func completeLesson(_ level: Int, correctAnswers: Int, totalQuestions: Int) {
        if !currentUser.completedLessons.contains(level) {
            currentUser.completedLessons.append(level)
            
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
