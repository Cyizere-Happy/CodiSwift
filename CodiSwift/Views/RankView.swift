import SwiftUI

struct RankView: View {
    @ObservedObject var userManager = UserManager.shared
    @State private var selectedTab = 0
    
    let swiftColor = Color(hex: "FF684B")
    let darkColor = Color(hex: "232223")
    
    // MARK: - Data
    private var allGlobalPlayers: [LeaderboardPlayer] {
        [
            LeaderboardPlayer(name: "CodeMaster", emoji: "👑", points: 5000, streak: 45),
            LeaderboardPlayer(name: "SwiftNinja", emoji: "🥷", points: 4500, streak: 30),
            LeaderboardPlayer(name: "DevQueen", emoji: "👸", points: 4200, streak: 28),
            LeaderboardPlayer(name: "BugHunter", emoji: "🐛", points: 3800, streak: 25),
            LeaderboardPlayer(name: "LoopLegend", emoji: "🔄", points: 3500, streak: 22),
            LeaderboardPlayer(name: "FuncWizard", emoji: "🧙", points: 3200, streak: 20),
            LeaderboardPlayer(name: "ArrayAce", emoji: "🎯", points: 2900, streak: 18),
            LeaderboardPlayer(name: "ClassicCoder", emoji: "💻", points: 2600, streak: 15)
        ]
    }
    
    private var allFriendPlayers: [LeaderboardPlayer] {
        [
            LeaderboardPlayer(name: "Alex Swift", emoji: "🦊", points: 1200, streak: 5),
            LeaderboardPlayer(name: "Sarah Coder", emoji: "🦄", points: 3100, streak: 12),
            LeaderboardPlayer(name: "John Dev", emoji: "🦁", points: 800, streak: 3),
            LeaderboardPlayer(name: "Zoe Tech", emoji: "🦋", points: 4500, streak: 15)
        ]
    }
    
    // Computed property to get ranked players for the selected tab
    private var currentRankedPlayers: [LeaderboardPlayer] {
        let basePlayers = selectedTab == 0 ? allGlobalPlayers : allFriendPlayers
        
        // Add current user
        let currentUser = LeaderboardPlayer(
            name: userManager.currentUser.name,
            emoji: userManager.currentUser.emoji,
            points: userManager.currentUser.points,
            streak: userManager.currentUser.streak
        )
        
        var combined = basePlayers
        if !combined.contains(where: { $0.name == currentUser.name }) {
            combined.append(currentUser)
        }
        
        // Sort by points descending
        let sorted = combined.sorted { $0.points > $1.points }
        
        // Assign ranks
        return sorted.enumerated().map { index, player in
            var p = player
            p.rank = index + 1
            return p
        }
    }
    
    var body: some View {
        ZStack {
            // Light background
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                segmentedControl
                podiumView
                leaderboardList
            }
        }
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Leaderboard")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(darkColor)
            
            Text(selectedTab == 0 ? "Compete with coders worldwide" : "See how you rank among friends")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(darkColor.opacity(0.7))
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
                withAnimation { selectedTab = 0 }
            } label: {
                Text("Global")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(selectedTab == 0 ? .white : darkColor.opacity(0.8))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(selectedTab == 0 ? swiftColor : Color.clear)
                    )
            }
            
            Button {
                withAnimation { selectedTab = 1 }
            } label: {
                Text("Friends")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(selectedTab == 1 ? .white : darkColor.opacity(0.8))
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
                .fill(Color(hex: "F5F5F5"))
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    // MARK: - Podium View
    private var podiumView: some View {
        let players = currentRankedPlayers
        return HStack(alignment: .bottom, spacing: 12) {
            if players.count > 1 {
                PodiumCard(player: players[1], height: 100, color: Color(hex: "C0C0C0"))
            }
            if players.count > 0 {
                PodiumCard(player: players[0], height: 130, color: Color(hex: "FFD700"))
            }
            if players.count > 2 {
                PodiumCard(player: players[2], height: 80, color: Color(hex: "CD7F32"))
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
        .animation(.spring(), value: selectedTab)
    }
    
    // MARK: - Leaderboard List
    private var leaderboardList: some View {
        let players = currentRankedPlayers
        return ScrollView {
            VStack(spacing: 12) {
                if players.count > 3 {
                    ForEach(players.dropFirst(3)) { player in
                        LeaderboardRow(player: player, isCurrentUser: player.name == userManager.currentUser.name)
                    }
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
    
    let darkColor = Color(hex: "232223")
    let lightOrange = Color(hex: "FFB88D") // lighter orange for emoji circle
    
    var body: some View {
        VStack(spacing: 8) {
            if player.rank == 1 { Text("👑").font(.system(size: 32)) }
            
            // Emoji with light orange circle
            Text(player.emoji)
                .font(.system(size: 40))
                .padding(16)
                .background(
                    Circle()
                        .fill(lightOrange)
                        .frame(width: 72, height: 72)
                )
            
            Text("#\(player.rank)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Capsule().fill(color))
            
            Text(player.name)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(darkColor)
            
            Text("\(player.points)")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(hex: "FF684B"))
            
            Rectangle()
                .fill(color.opacity(0.2))
                .frame(height: height)
                .overlay(Rectangle().stroke(color, lineWidth: 2))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Leaderboard Row
struct LeaderboardRow: View {
    let player: LeaderboardPlayer
    let isCurrentUser: Bool
    
    let swiftColor = Color(hex: "FF684B")
    let darkColor = Color(hex: "232223")
    
    var body: some View {
        HStack(spacing: 16) {
            Text("#\(player.rank)")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(isCurrentUser ? swiftColor : darkColor.opacity(0.8))
                .frame(width: 40, alignment: .leading)
            
            Text(player.emoji).font(.system(size: 28))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(darkColor)
                
                HStack(spacing: 4) {
                    Text("🔥").font(.system(size: 12))
                    Text("\(player.streak) day streak")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(darkColor.opacity(0.6))
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(player.points)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(swiftColor)
                
                Text("points")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(darkColor.opacity(0.5))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isCurrentUser ? swiftColor.opacity(0.2) : Color(hex: "F5F5F5"))
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
    var rank: Int = 0
    let name: String
    let emoji: String
    let points: Int
    let streak: Int
}

#Preview {
    RankView()
}
