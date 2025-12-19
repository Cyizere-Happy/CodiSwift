import SwiftUI
import SplineRuntime

struct HomeScreen: View {

    // MARK: - State
    @State private var currentLevel = 1
    @State private var showLesson = false
    @State private var lessonCompleted = false  // Tracks completion for current level

    // MARK: - Persistent Progress
    @AppStorage("completedLevel1") private var completedLevel1 = false
    @AppStorage("completedLevel2") private var completedLevel2 = false

    // MARK: - Level Data
    private let levels: [Int: String] = [
        1: "Beginner: Learn Swift basics and simple exercises.",
        2: "Intermediate: Functions, loops, and SwiftUI views.",
        3: "Advanced: Combine, animations, and app architecture."
    ]

    // MARK: - Spline URLs
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
            // 🔹 Background Spline
            SplineView(sceneFileURL: splineURL(for: currentLevel))
                .id(currentLevel)
                .ignoresSafeArea()

            VStack(spacing: 18) {

                levelCard

                Spacer()

                HStack(spacing: 0) {
                    Text("Codi")
                        .foregroundColor(codiColor)
                    Text("Swift")
                        .foregroundColor(swiftColor)
                }
                .font(.largeTitle.bold())
                .shadow(radius: 10)

                Spacer().frame(height: 40)
            }
            .padding(.horizontal, 20)
        }
        // 🔹 Lesson Sheet
        .sheet(isPresented: $showLesson) {
            LessonView(level: currentLevel) { didComplete in
                // Update current lesson completion immediately
                lessonCompleted = didComplete

                // Persist completion
                switch currentLevel {
                case 1: completedLevel1 = didComplete
                case 2: completedLevel2 = didComplete
                default: break
                }
            }
        }
        // 🔹 Reset lessonCompleted when changing levels
        .onChange(of: currentLevel) { newLevel in
            switch newLevel {
            case 1: lessonCompleted = completedLevel1
            case 2: lessonCompleted = completedLevel2
            case 3: lessonCompleted = false
            default: lessonCompleted = false
            }
        }
    }

    // MARK: - Level Card
    private var levelCard: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Text("Level \(currentLevel)")
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(swiftColor)
                    .cornerRadius(10)

                Spacer()
                Text("👋").font(.title2)
            }

            Text(levelName(for: currentLevel))
                .font(.headline.bold())
                .foregroundColor(.black)

            Text(levels[currentLevel] ?? "")
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.75))

            // Buttons Row
            HStack(spacing: 140) {

                // Learn Button
                Button {
                    showLesson = true
                } label: {
                    Text("Learn")
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 18)
                        .background(swiftColor)
                        .cornerRadius(12)
                }
                .disabled(!isLevelUnlocked(currentLevel))
                .opacity(isLevelUnlocked(currentLevel) ? 1 : 0.4)

                // Next Level Button
                Button {
                    goToNextLevel()
                } label: {
                    Text("Next Level")
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(swiftColor)
                        .cornerRadius(12)
                }
                .disabled(!lessonCompleted)
                .opacity(lessonCompleted ? 1 : 0.4)
            }
            .padding(.top, 6)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(cardBackground)
                .shadow(color: .black.opacity(0.25), radius: 12, y: 6)
        )
    }

    // MARK: - Helpers
    private func levelName(for level: Int) -> String {
        switch level {
        case 1: return "Swift Basics"
        case 2: return "Intermediate Swift"
        case 3: return "Advanced Swift"
        default: return "Swift Journey"
        }
    }

    private func isLevelUnlocked(_ level: Int) -> Bool {
        switch level {
        case 1: return true
        case 2: return completedLevel1
        case 3: return completedLevel2
        default: return false
        }
    }

    private func goToNextLevel() {
        if currentLevel == 1 && lessonCompleted { currentLevel = 2 }
        else if currentLevel == 2 && lessonCompleted { currentLevel = 3 }

        // lessonCompleted will be updated automatically via .onChange
    }
}

#Preview {
    HomeScreen()
}
