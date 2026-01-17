import SwiftUI
import SplineRuntime

struct HomeView: View {
    @ObservedObject var userManager = UserManager.shared
    @AppStorage("selectedTab") var selectedTab = 0
    
    let swiftColor = Color(hex: "FF684B")
    let lightBlueBackground = Color(hex: "F7F9FF")
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                
                // MARK: - Background
                lightBlueBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    // MARK: - Hero Section
                    ZStack(alignment: .topLeading) {
                        // Spline Background
                        SplineView(sceneFileURL: URL(string: "https://build.spline.design/UV0ssx1eQx20WPscKfob/scene.splineswift")!)
                            .frame(height: geo.size.width > geo.size.height ? 400 : geo.size.height * 0.55)
                            .ignoresSafeArea(edges: .top)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            // Welcome Pill
                            HStack {
                                Text("👋 Welcome back!")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.black)
                                Spacer()
                                
                                // Points Display
                                HStack(spacing: 4) {
                                    Text("💰")
                                    Text("\(userManager.currentUser.points)")
                                        .font(.system(size: 14, weight: .bold))
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Capsule().fill(.white))
                                .shadow(radius: 2)
                                .padding(.trailing, 8)
                                
                                Text(userManager.currentUser.emoji)
                                    .font(.system(size: 20))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Capsule().fill(.white.opacity(0.85)))
                            .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
                            .padding(.top, geo.safeAreaInsets.top + 8)
                            .frame(maxWidth: 400) // Limit width on iPad
                            
                            // Learn & Compete Card (Half width)
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Learn & Compete")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text("Learn Swift through fun lessons\nor host live coding challenges!")
                                    .font(.system(size: 13))
                                    .foregroundColor(.black.opacity(0.7))
                                    .lineLimit(2)
                                
                                Button(action: {
                                    withAnimation {
                                        selectedTab = 1
                                    }
                                }) {
                                    Text("Start Learning")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 08)
                                        .padding(.horizontal, 16)
                                        .background(swiftColor)
                                        .cornerRadius(12)
                                }
                                .padding(.top, 4)
                            }
                            .padding(18)
                            .frame(width: min(geo.size.width * 0.5, 300), alignment: .leading) // Cap width
                            .background(
                                LinearGradient(
                                    colors: [.white.opacity(0.95), .white.opacity(0.8), .white.opacity(0.0)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(24)
                            .shadow(radius: 8)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10) // Changed from -60 to 10 for visibility
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // MARK: - Bottom Section
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            // Bottom content cards
                            VStack(spacing: 16) {
                                // Daily Quest
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Daily Quest")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.black)
                                        
                                        if userManager.currentUser.dailyQuests.isEmpty {
                                            Text("No quests available today. Come back tomorrow! 😴")
                                                .font(.system(size: 13))
                                                .foregroundColor(.gray)
                                                .frame(maxWidth: .infinity, alignment: .center)
                                                .padding(.vertical, 20)
                                        } else {
                                            VStack(alignment: .leading, spacing: 8) {
                                                ForEach(userManager.currentUser.dailyQuests) { quest in
                                                    QuestRefinedRow(
                                                        icon: quest.icon,
                                                        title: quest.title,
                                                        progress: quest.progress,
                                                        target: quest.target
                                                    )
                                                }
                                            }
                                            .foregroundColor(.black)
                                        }
                                    }
                                    .padding(14)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .shadow(color: .black.opacity(0.03), radius: 10, y: 5)
                                    
                                    let hasQuests = !userManager.currentUser.dailyQuests.isEmpty
                                    let allDone = hasQuests && userManager.currentUser.dailyQuests.allSatisfy { $0.isCompleted }
                                    let isClaimed = userManager.currentUser.hasClaimedDailyBonus
                                    
                                    Button(action: { 
                                        _ = userManager.claimDailyBonus()
                                    }) {
                                        VStack(spacing: 4) {
                                            Text(isClaimed ? "DONE" : "CLAIM")
                                                .font(.system(size: 10, weight: .black))
                                            Text(isClaimed ? "✅" : "45")
                                                .font(.system(size: 20, weight: .black))
                                            if !isClaimed {
                                                Text("PTS")
                                                    .font(.system(size: 8, weight: .bold))
                                            }
                                        }
                                        .foregroundColor(allDone && !isClaimed ? .white : .gray)
                                        .frame(width: 72, height: 72)
                                        .background(
                                            ZStack {
                                                if isClaimed {
                                                    Circle().fill(Color.green.opacity(0.1))
                                                    Circle().stroke(Color.green, lineWidth: 2)
                                                } else if allDone {
                                                    Circle().fill(swiftColor)
                                                } else {
                                                    Circle().fill(Color.gray.opacity(0.1))
                                                }
                                            }
                                        )
                                        .shadow(color: (allDone && !isClaimed) ? swiftColor.opacity(0.3) : .clear, radius: 8, y: 4)
                                    }
                                    .disabled(!allDone || isClaimed)
                                }
                                
                                // Your Progress
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text("Your Progress")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text("🔥 Streak: \(userManager.currentUser.streak) Days")
                                            .font(.system(size: 11, weight: .bold))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(swiftColor.opacity(0.1))
                                            .foregroundColor(swiftColor)
                                            .cornerRadius(8)
                                    }
                                    
                                    HStack(spacing: 12) {
                                        HStack(spacing: 12) {
                                            Text("\(userManager.currentUser.completedLessons.count + 1)")
                                                .font(.system(size: 20, weight: .black))
                                                .foregroundColor(.white)
                                                .frame(width: 44, height: 44)
                                                .background(Circle().fill(swiftColor))
                                            
                                            VStack(alignment: .leading, spacing: 6) {
                                                Text("Level \(userManager.currentUser.completedLessons.count + 1)")
                                                    .font(.system(size: 14, weight: .bold))
                                                    .foregroundColor(.black)
                                                Capsule()
                                                    .fill(Color.black.opacity(0.05))
                                                    .frame(height: 5)
                                                    .overlay(alignment: .leading) {
                                                        let progress = CGFloat(userManager.currentUser.completedLessons.count) / 4.0
                                                        GeometryReader { geo in
                                                            Capsule()
                                                                .fill(swiftColor)
                                                                .frame(width: geo.size.width * progress)
                                                        }
                                                    }
                                            }
                                        }
                                        .padding(14)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.white)
                                        .cornerRadius(20)
                                        
                                        HStack(spacing: 8) {
                                            VStack(spacing: 4) {
                                                Image(systemName: "calendar")
                                                    .font(.system(size: 16))
                                                    .frame(width: 44, height: 44)
                                                    .background(Color.white)
                                                    .cornerRadius(12)
                                                Text("Calendar")
                                                    .font(.system(size: 8, weight: .medium))
                                                    .foregroundColor(.gray)
                                            }
                                            VStack(spacing: 4) {
                                                Image(systemName: "cube.fill")
                                                    .font(.system(size: 16))
                                                    .frame(width: 44, height: 44)
                                                    .background(Color.white)
                                                    .cornerRadius(12)
                                                Text("Assets")
                                                    .font(.system(size: 8, weight: .medium))
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .foregroundColor(swiftColor)
                                    }
                                }
                            }
                            .frame(maxWidth: 800) // Limit width on iPad
                            .padding(.horizontal, 20)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 20)
                        .zIndex(45)
                    }
                }
                .padding(.top, 0)
            }
            .colorScheme(.light) // Force light mode for entire HomeView dashboard
        }
    }
}

// MARK: - Refined Components
struct QuestRefinedRow: View {
    let icon: String
    let title: String
    let progress: Int
    let target: Int
    
    var isDone: Bool {
        progress >= target
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Text(icon).font(.system(size: 18))
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.system(size: 13, weight: .bold))
                
                // Mini Progress Bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.black.opacity(0.05))
                            .frame(height: 3)
                        
                        Capsule()
                            .fill(isDone ? Color.green : Color.swiftColor)
                            .frame(width: geo.size.width * CGFloat(progress) / CGFloat(target), height: 3)
                    }
                }
                .frame(height: 3)
            }
            
            Spacer()
            
            Text("\(progress)/\(target)")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(isDone ? .green : .gray)
            
            Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isDone ? .green : .gray.opacity(0.3))
        }
        .foregroundColor(.black)
        .padding(.vertical, 2)
    }
}

struct CustomCorner: Shape {
    var cornerRadius: CGFloat
    var corners: UIRectCorner
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}
