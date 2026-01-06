import SwiftUI
import SplineRuntime

struct HomeView: View {
    @ObservedObject var userManager = UserManager.shared
    
    let swiftColor = Color(hex: "FF684B")
    let darkColor = Color(hex: "232223")
    let cardBackground = Color(hex: "2a2a2a")
    
    var body: some View {
        ZStack {
            // Spline 3D Background
            SplineView(sceneFileURL: URL(string: "https://build.spline.design/oK3pQ3Db0QPisoxFPQUm/scene.splineswift")!)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome Header
                    welcomeHeader
                    
                    // Streak Card
                    streakCard
                    
                    // Stats Grid
                    statsGrid
                    
                    // Continue Learning Card
                    continueLearningCard
                    
                    // Recent Badges
                    if !userManager.currentUser.badges.isEmpty {
                        recentBadges
                    }
                    
                    Spacer().frame(height: 100) // Tab bar padding
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
    }
    
    // MARK: - Welcome Header
    private var welcomeHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back,")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                
                HStack(spacing: 8) {
                    Text(userManager.currentUser.emoji)
                        .font(.system(size: 28))
                    
                    Text(userManager.currentUser.name)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
            
            // Tier Badge
            VStack(spacing: 4) {
                Text(userManager.currentUser.tier.emoji)
                    .font(.system(size: 32))
                
                Text(userManager.currentUser.tier.rawValue)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(hex: userManager.currentUser.tier.color))
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(cardBackground)
            )
        }
    }
    
    // MARK: - Streak Card
    private var streakCard: some View {
        HStack(spacing: 16) {
            // Fire emoji with count
            ZStack {
                Circle()
                    .fill(swiftColor.opacity(0.2))
                    .frame(width: 70, height: 70)
                
                VStack(spacing: 4) {
                    Text("🔥")
                        .font(.system(size: 32))
                    
                    Text("\(userManager.currentUser.streak)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(swiftColor)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Day Streak!")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Keep learning every day to maintain your streak")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [swiftColor.opacity(0.3), swiftColor.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
    }
    
    // MARK: - Stats Grid
    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            StatCard(
                emoji: "⭐️",
                value: "\(userManager.currentUser.points)",
                label: "Total Points",
                color: swiftColor
            )
            
            StatCard(
                emoji: "🎯",
                value: String(format: "%.0f%%", userManager.currentUser.accuracy),
                label: "Accuracy",
                color: .green
            )
            
            StatCard(
                emoji: "📚",
                value: "\(userManager.currentUser.completedLessons.count)",
                label: "Lessons Done",
                color: .blue
            )
            
            StatCard(
                emoji: "🏆",
                value: "\(userManager.currentUser.liveGamesWon)",
                label: "Games Won",
                color: .yellow
            )
        }
    }
    
    // MARK: - Continue Learning Card
    private var continueLearningCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Continue Learning")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(swiftColor)
            }
            
            HStack(spacing: 12) {
                Text("📖")
                    .font(.system(size: 32))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Next: Level \(nextLevel)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(nextLevelTitle)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(cardBackground)
        )
    }
    
    // MARK: - Recent Badges
    private var recentBadges: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Achievements")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(userManager.currentUser.badges.prefix(5)) { badge in
                        BadgeCard(badge: badge)
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    private var nextLevel: Int {
        let completed = userManager.currentUser.completedLessons
        if completed.isEmpty { return 1 }
        return (completed.max() ?? 0) + 1
    }
    
    private var nextLevelTitle: String {
        switch nextLevel {
        case 1: return "Swift Basics"
        case 2: return "Intermediate Swift"
        case 3: return "Advanced Swift"
        default: return "Coming Soon"
        }
    }
}

// MARK: - Stat Card Component
struct StatCard: View {
    let emoji: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(emoji)
                .font(.system(size: 28))
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(color)
            
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "2a2a2a"))
        )
    }
}

// MARK: - Badge Card Component
struct BadgeCard: View {
    let badge: Badge
    
    var body: some View {
        VStack(spacing: 8) {
            Text(badge.emoji)
                .font(.system(size: 40))
            
            Text(badge.name)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .frame(width: 100, height: 100)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "2a2a2a"))
        )
    }
}

#Preview {
    HomeView()
}
