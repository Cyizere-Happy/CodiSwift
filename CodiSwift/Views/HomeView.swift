import SwiftUI
import SplineRuntime

struct HomeView: View {
    @ObservedObject var userManager = UserManager.shared
    
    let swiftColor = Color(hex: "FF684B")
    let lightBlueBackground = Color(hex: "F7F9FF")
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Hero Section (Spline) - ~65% height
            ZStack(alignment: .topLeading) {
                // Spline Scene Background - Edge to Edge
                SplineView(sceneFileURL: URL(string: "https://build.spline.design/UV0ssx1eQx20WPscKfob/scene.splineswift")!)
                    .frame(height: UIScreen.main.bounds.height * 0.65)
                
                VStack(alignment: .leading, spacing: 12) {
                    // Welcome Pill - Smaller
                    HStack {
                        Text("👋 Welcome back!")
                            .font(.system(size: 13, weight: .semibold))
                        Spacer()
                        Text(userManager.currentUser.emoji)
                            .font(.system(size: 18))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(.white.opacity(0.8)))
                    .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
                    .padding(.top, 50)
                    
                    // Compact Transparent Card
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Learn & Compete")
                            .font(.system(size: 16, weight: .bold))
                        
                        Text("Swift lessons & challenges")
                            .font(.system(size: 11))
                            .foregroundColor(.black.opacity(0.7))
                        
                        Button(action: {}) {
                            Text("Start")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 12)
                                .background(swiftColor)
                                .cornerRadius(10)
                        }
                        .padding(.top, 2)
                    }
                    .padding(14)
                    .frame(width: 180)
                    .background(
                        LinearGradient(
                            colors: [.white.opacity(0.85), .white.opacity(0.0)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(16)
                }
                .padding(.horizontal, 20)
            }
            
            // MARK: - Compact Bottom Sections (Non-scrollable fitting)
            VStack(spacing: 12) {
                // Daily Quest - Very Compact
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Daily Quest")
                            .font(.system(size: 15, weight: .bold))
                        
                        VStack(alignment: .leading, spacing: 6) {
                            MiniQuestRow(icon: "🎁", title: "3 lessons", isDone: true)
                            MiniQuestRow(icon: "🎙️", title: "Host live", isDone: true)
                            MiniQuestRow(icon: "🔥", title: "Streak", isDone: true)
                        }
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(14)
                    
                    VStack {
                        Button(action: {}) {
                            VStack(spacing: 2) {
                                Text("Claim")
                                    .font(.system(size: 10, weight: .bold))
                                Text("45")
                                    .font(.system(size: 14, weight: .black))
                            }
                            .foregroundColor(.white)
                            .frame(width: 55, height: 55)
                            .background(swiftColor)
                            .clipShape(Circle())
                        }
                        .padding(.top, 15)
                    }
                }
                
                // Your Progress - Very Compact
                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Progress")
                                .font(.system(size: 15, weight: .bold))
                            Spacer()
                            Text("🔥 4D")
                                .font(.system(size: 9, weight: .bold))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.orange.opacity(0.1))
                                .foregroundColor(.orange)
                                .cornerRadius(5)
                        }
                        
                        HStack(spacing: 8) {
                            Text("3")
                                .font(.system(size: 18, weight: .black))
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                                .background(Circle().fill(LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom)))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Lvl 3")
                                    .font(.system(size: 11, weight: .bold))
                                Capsule()
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(height: 4)
                                    .overlay(alignment: .leading) {
                                        Capsule()
                                            .fill(LinearGradient(colors: [.cyan, .blue], startPoint: .leading, endPoint: .trailing))
                                            .frame(width: 30)
                                    }
                            }
                        }
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(14)
                    
                    HStack(spacing: 4) {
                        MiniBadge(icon: "📅")
                        MiniBadge(icon: "🧊")
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 20)
            .background(lightBlueBackground)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .offset(y: -30)
            
            Spacer()
        }
        .background(lightBlueBackground.ignoresSafeArea())
    }
}

// MARK: - Super Mini Components
struct MiniQuestRow: View {
    let icon: String
    let title: String
    let isDone: Bool
    
    var body: some View {
        HStack(spacing: 6) {
            Text(icon).font(.system(size: 11))
            Text(title).font(.system(size: 10, weight: .medium))
            Spacer()
            Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 9))
                .foregroundColor(isDone ? .green : .gray.opacity(0.3))
        }
    }
}

struct MiniBadge: View {
    let icon: String
    
    var body: some View {
        Text(icon)
            .font(.system(size: 14))
            .frame(width: 32, height: 32)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
}

#Preview {
    HomeView()
}
