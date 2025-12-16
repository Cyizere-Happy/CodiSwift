import SwiftUI
import SplineRuntime

struct HomeScreen: View {

    // MARK: - Levels & Splines
    @State private var currentLevel = 1
    private let levels: [Int: String] = [
        1: "Beginner: Learn Swift basics and simple exercises.",
        2: "Intermediate: Functions, loops, and SwiftUI views.",
        3: "Advanced: Combine, animations, and app architecture."
    ]
    
    private func splineURL(for level: Int) -> URL {
        switch level {
        case 1:
            return URL(string: "https://build.spline.design/ss3bhSleXBVYfeIqJNPO/scene.splineswift")!
        case 2:
            return URL(string: "https://build.spline.design/aJaptQp1Nuq4m4C7w8Du/scene.splineswift")!
        case 3:
            return URL(string: "https://build.spline.design/FVsJNvwkVCFlaBSLEuhJ/scene.splineswift")!
        default:
            return URL(string: "https://build.spline.design/ss3bhSleXBVYfeIqJNPO/scene.splineswift")!
        }
    }

    // MARK: - Colors
    private let codiColor = Color.white
    private let swiftColor = Color(hex: "FF684B")
    private let cardBackground = Color.white.opacity(0.92)

    var body: some View {
        ZStack {
            // 🔹 Dynamic Spline (id forces remount when level changes)
            SplineView(sceneFileURL: splineURL(for: currentLevel))
                .id(currentLevel)
                .ignoresSafeArea(.all)

            // 🔹 Overlay UI
            VStack(spacing: 18) {

                // Level Card (pushed higher)
                levelCard
                    .frame(maxWidth: .infinity)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                // Logo (bottom)
                HStack(spacing: 0) {
                    Text("Codi")
                        .foregroundColor(codiColor)
                    Text("Swift")
                        .foregroundColor(swiftColor)
                }
                .font(.largeTitle.bold())
                .shadow(radius: 10)

                Spacer()
                    .frame(height: 40)
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Level Card
    private var levelCard: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack {
                Text("Level \(currentLevel)")
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(swiftColor)
                    .cornerRadius(10)

                Spacer()

                Text("👋")
                    .font(.title2)
            }

            Text(levelName(for: currentLevel))
                .font(.headline.bold())
                .foregroundColor(.black)

            Text(levels[currentLevel] ?? "")
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.75))

            // Smaller Next Level Button
            Button(action: {
                goToNextLevel()
            }) {
                Text("Next Level")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(swiftColor)
                    .cornerRadius(12)
            }
            .padding(.top, 6)

        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(cardBackground)
                .shadow(color: .black.opacity(0.25), radius: 12, y: 6)
        )
        .padding(.top, 0) // 🔹 pushed higher to avoid hiding world
    }

    // MARK: - Level Name Helper
    private func levelName(for level: Int) -> String {
        switch level {
        case 1: return "Swift Basics"
        case 2: return "Intermediate Swift"
        case 3: return "Advanced Swift"
        default: return "Swift Journey"
        }
    }

    // MARK: - Next Level Action
    private func goToNextLevel() {
        if currentLevel < levels.count {
            currentLevel += 1
        } else {
            currentLevel = 1 // reset or add completion logic
        }
    }
}



#Preview {
    HomeScreen()
}
