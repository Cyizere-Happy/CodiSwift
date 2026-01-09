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
                            .frame(height: geo.size.height * 0.58)
                            .ignoresSafeArea(edges: .top)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            // Welcome Pill
                            HStack {
                                Text("👋 Welcome back!")
                                    .font(.system(size: 14, weight: .semibold))
                                Spacer()
                                Text(userManager.currentUser.emoji)
                                    .font(.system(size: 20))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Capsule().fill(.white.opacity(0.85)))
                            .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
                            .padding(.top, geo.safeAreaInsets.top + 8)
                            
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
                            .frame(width: geo.size.width * 0.5, alignment: .leading) // half width
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
                        .padding(.top, -60)
                    }
                    
                    // MARK: - Bottom Section
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            
                            // Daily Quest
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Daily Quest")
                                        .font(.system(size: 18, weight: .bold))
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        QuestRefinedRow(icon: "🎁", title: "3 lessons joined", isDone: true)
                                        QuestRefinedRow(icon: "🎙️", title: "Host challenge", isDone: true)
                                        QuestRefinedRow(icon: "🔥", title: "Keep streak", isDone: true)
                                    }
                                }
                                .padding(14)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.03), radius: 10, y: 5)
                                
                                Button(action: { userManager.addPoints(45) }) {
                                    VStack(spacing: 2) {
                                        Text("Claim").font(.system(size: 12, weight: .bold))
                                        Text("45").font(.system(size: 18, weight: .black))
                                    }
                                    .foregroundColor(.white)
                                    .frame(width: 70, height: 70)
                                    .background(
                                        LinearGradient(colors: [Color(hex: "FF8C4B"), Color(hex: "FF684B")], startPoint: .top, endPoint: .bottom)
                                    )
                                    .clipShape(Circle())
                                    .shadow(color: swiftColor.opacity(0.3), radius: 8, y: 4)
                                }
                            }
                            
                            // Your Progress
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Your Progress")
                                        .font(.system(size: 18, weight: .bold))
                                    Spacer()
                                    Text("🔥 Streak: \(userManager.currentUser.streak) Days")
                                        .font(.system(size: 11, weight: .bold))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color.orange.opacity(0.1))
                                        .foregroundColor(.orange)
                                        .cornerRadius(8)
                                }
                                
                                HStack(spacing: 12) {
                                    HStack(spacing: 12) {
                                        Text("\(userManager.currentUser.completedLessons.count + 1)")
                                            .font(.system(size: 24, weight: .black))
                                            .foregroundColor(.white)
                                            .frame(width: 48, height: 48)
                                            .background(Circle().fill(LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom)))
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Level \(userManager.currentUser.completedLessons.count + 1)")
                                                .font(.system(size: 14, weight: .bold))
                                            Capsule()
                                                .fill(Color.gray.opacity(0.1))
                                                .frame(height: 6)
                                                .overlay(alignment: .leading) {
                                                    let progress = CGFloat(userManager.currentUser.completedLessons.count) / 4.0
                                                    GeometryReader { geo in
                                                        Capsule()
                                                            .fill(LinearGradient(colors: [.cyan, .blue], startPoint: .leading, endPoint: .trailing))
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
                                        Image(systemName: "calendar")
                                            .font(.system(size: 18))
                                            .frame(width: 44, height: 44)
                                            .background(Color.white)
                                            .cornerRadius(12)
                                        Image(systemName: "cube.fill")
                                            .font(.system(size: 18))
                                            .frame(width: 44, height: 44)
                                            .background(Color.white)
                                            .cornerRadius(12)
                                    }
                                    .foregroundColor(swiftColor)
                                }
                            }
                        }
                        .padding(.horizontal, 19.0)
//                        .padding(.top, -23.0)
                        .padding(.bottom, 20)
                        .zIndex(45)// just inner padding, no extra white space
                    }
                }
            }
        }
    }
}

// MARK: - Refined Components
struct QuestRefinedRow: View {
    let icon: String
    let title: String
    let isDone: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Text(icon).font(.system(size: 14))
            Text(title).font(.system(size: 12, weight: .medium))
            Spacer()
            Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isDone ? .green : .gray.opacity(0.3))
        }
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
