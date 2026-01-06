import SwiftUI

struct RankView: View {
    @ObservedObject var userManager = UserManager.shared
    @State private var selectedTab = 0
    
    let swiftColor = Color(hex: "FF684B")
    let darkColor = Color(hex: "232223")
    let cardBackground = Color(hex: "2a2a2a")
    
    // Mock leaderboard data
    let globalPlayers: [LeaderboardPlayer] = [
        LeaderboardPlayer(rank: 1, name: "CodeMaster", emoji: "👑", points: 5000, streak: 45),
        LeaderboardPlayer(rank: 2, name: "SwiftNinja", emoji: "🥷", points: 4500, streak: 30),
        LeaderboardPlayer(rank: 3, name: "DevQueen", emoji: "👸", points: 4200, streak: 28),
        LeaderboardPlayer(rank: 4, name: "BugHunter", emoji: "🐛", points: 3800, streak: 25),
        LeaderboardPlayer(rank: 5, name: "LoopLegend", emoji: "🔄", points: 3500, streak: 22),
        LeaderboardPlayer(rank: 6, name: "FuncWizard", emoji: "🧙", points: 3200, streak: 20),
        LeaderboardPlayer(rank: 7, name: "ArrayAce", emoji: "🎯", points: 2900, streak: 18),
        LeaderboardPlayer(rank: 8, name: "ClassicCoder", emoji: "💻", points: 2600, streak: 15)
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
            
            VStack(spacing: 0) {
                // Header
                header
                
                // Segmented Control
                segmentedControl
                
                // Top 3 Podium
                podiumView
                
                // Leaderboard List
                leaderboardList
            }
        }
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Leaderboard")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
            
            Text("Compete with coders worldwide")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 16)
    }
    
    // MARK: - Segmented Control
    private var segmentedControl: some View {
        HStack(spacing: 0) {
            Button {
                selectedTab = 0
            } label: {
                Text("Global")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(selectedTab == 0 ? .white : .white.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(selectedTab == 0 ? swiftColor : Color.clear)
                    )
            }
            
            Button {
                selectedTab = 1
            } label: {
                Text("Friends")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(selectedTab == 1 ? .white : .white.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(selectedTab == 1 ? swiftColor : Color.clear)
                    )
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(cardBackground)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    // MARK: - Podium View
    private var podiumView: some View {
        HStack(alignment: .bottom, spacing: 12) {
            // 2nd Place
            if globalPlayers.count > 1 {
                PodiumCard(
                    player: globalPlayers[1],
                    height: 100,
                    color: Color(hex: "C0C0C0") // Silver
                )
            }
            
            // 1st Place
            if globalPlayers.count > 0 {
                PodiumCard(
                    player: globalPlayers[0],
                    height: 130,
                    color: Color(hex: "FFD700") // Gold
                )
            }
            
            // 3rd Place
            if globalPlayers.count > 2 {
                PodiumCard(
                    player: globalPlayers[2],
                    height: 80,
                    color: Color(hex: "CD7F32") // Bronze
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }
    
    // MARK: - Leaderboard List
    private var leaderboardList: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Show players from rank 4 onwards
                ForEach(globalPlayers.dropFirst(3)) { player in
                    LeaderboardRow(
                        player: player,
                        isCurrentUser: player.name == userManager.currentUser.name
                    )
                }
                
                // Current User (if not in top)
                if !globalPlayers.contains(where: { $0.name == userManager.currentUser.name }) {
                    LeaderboardRow(
                        player: LeaderboardPlayer(
                            rank: 42,
                            name: userManager.currentUser.name,
                            emoji: userManager.currentUser.emoji,
                            points: userManager.currentUser.points,
                            streak: userManager.currentUser.streak
                        ),
                        isCurrentUser: true
                    )
                }
                
                Spacer().frame(height: 100)
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Podium Card
struct PodiumCard: View {
    let player: LeaderboardPlayer
    let height: CGFloat
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            // Crown for 1st place
            if player.rank == 1 {
                Text("👑")
                    .font(.system(size: 32))
            }
            
            // Player emoji
            Text(player.emoji)
                .font(.system(size: 40))
                .padding(12)
                .background(
                    Circle()
                        .fill(Color(hex: "2a2a2a"))
                )
            
            // Rank badge
            Text("#\(player.rank)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(color)
                )
            
            // Name
            Text(player.name)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)
            
            // Points
            Text("\(player.points)")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(hex: "FF684B"))
            
            // Podium base
            Rectangle()
                .fill(color.opacity(0.3))
                .frame(height: height)
                .overlay(
                    Rectangle()
                        .stroke(color, lineWidth: 2)
                )
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Leaderboard Row
struct LeaderboardRow: View {
    let player: LeaderboardPlayer
    let isCurrentUser: Bool
    
    let swiftColor = Color(hex: "FF684B")
    
    var body: some View {
        HStack(spacing: 16) {
            // Rank
            Text("#\(player.rank)")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(isCurrentUser ? swiftColor : .white.opacity(0.6))
                .frame(width: 40, alignment: .leading)
            
            // Emoji
            Text(player.emoji)
                .font(.system(size: 28))
            
            // Name and streak
            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                HStack(spacing: 4) {
                    Text("🔥")
                        .font(.system(size: 12))
                    Text("\(player.streak) day streak")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            
            Spacer()
            
            // Points
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(player.points)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(swiftColor)
                
                Text("points")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isCurrentUser ? swiftColor.opacity(0.2) : Color(hex: "2a2a2a"))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isCurrentUser ? swiftColor : Color.clear, lineWidth: 2)
                )
        )
    }
}

// MARK: - Leaderboard Player Model
struct LeaderboardPlayer: Identifiable {
    let id = UUID()
    let rank: Int
    let name: String
    let emoji: String
    let points: Int
    let streak: Int
}

#Preview {
    RankView()
}
