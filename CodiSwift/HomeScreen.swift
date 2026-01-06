import SwiftUI
import SplineRuntime

struct HomeScreen: View {

    // MARK: - State
    @State private var currentLevel = 1
    @State private var showLesson = false
    @State private var lessonCompleted = false  // Tracks completion for current level
    @State private var isExploring = false  // Tracks explore mode

    // MARK: - Persistent Progress
    @AppStorage("completedLevel1") private var completedLevel1 = false
    @AppStorage("completedLevel2") private var completedLevel2 = false
    @AppStorage("completedLevel3") private var completedLevel3 = false

    // MARK: - Level Data
    private let levels: [Int: String] = [
        1: "Beginner: Learn Swift basics and simple exercises.",
        2: "Intermediate: Functions, loops, and SwiftUI views.",
        3: "Advanced: Combine, animations, and app architecture.",
        4: "Mastery: Arrays and Dictionaries for data management."
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
        case 4:
            return URL(string: "https://build.spline.design/BpNFhExzB2HK5bOGlafg/scene.splineswift")!
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
            // 🔹 Background Layer
            GeometryReader { geo in
                ZStack {
                    Color.black // Fallback
                    
                    SplineView(sceneFileURL: splineURL(for: currentLevel))
                        .id("spline-bg-\(currentLevel)")
                        .opacity(1.0)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top spacing
                Spacer().frame(height: 20)
                
                // Level selector/viewer
                if !isExploring {
                    TabView(selection: $currentLevel) {
                        ForEach(1...4, id: \.self) { level in
                            levelCard(for: level)
                                .padding(.horizontal, 20)
                                .tag(level)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .frame(height: 250)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }

                Spacer()

                // CodiSwift logo - animated
                if !isExploring {
                    HStack(spacing: 0) {
                        Text("Codi")
                            .foregroundColor(codiColor)
                        Text("Swift")
                            .foregroundColor(swiftColor)
                    }
                    .font(.largeTitle.bold())
                    .shadow(radius: 10)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Spacer().frame(height: isExploring ? 0 : 120) // Adjust for tab bar
            }
            
            // Small floating explore button - top right corner
            if !isExploring {
                VStack {
                    HStack {
                        Spacer()
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                isExploring = true
                            }
                            
                            // Auto return after 5 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                withAnimation(.easeInOut(duration: 0.6)) {
                                    isExploring = false
                                }
                            }
                        } label: {
                            Image(systemName: "sparkles")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                                .padding(12)
                                .background(
                                    Circle()
                                        .fill(swiftColor.opacity(0.9))
                                        .shadow(color: swiftColor.opacity(0.3), radius: 6, y: 3)
                                )
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 280)
                    }
                    
                    Spacer()
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        // 🔹 Lesson Sheet
        .sheet(isPresented: $showLesson) {
            NewLessonView(level: currentLevel) { didComplete in
                // Update current lesson completion immediately
                lessonCompleted = didComplete

                // Persist completion
                switch currentLevel {
                case 1: completedLevel1 = didComplete
                case 2: completedLevel2 = didComplete
                case 3: completedLevel3 = didComplete
                default: break
                }
            }
        }
        // 🔹 Reset lessonCompleted when changing levels
        .onChange(of: currentLevel) { newLevel in
            switch newLevel {
            case 1: lessonCompleted = completedLevel1
            case 2: lessonCompleted = completedLevel2
            case 3: lessonCompleted = completedLevel3
            case 4: lessonCompleted = false
            default: lessonCompleted = false
            }
        }
    }

    // MARK: - Level Card
    private func levelCard(for level: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Text("Level \(level)")
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(isLevelUnlocked(level) ? swiftColor : Color.gray)
                    .cornerRadius(10)

                Spacer()
                if !isLevelUnlocked(level) {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                } else {
                    Text("👋").font(.title2)
                }
            }

            Text(levelName(for: level))
                .font(.headline.bold())
                .foregroundColor(.black)

            Text(levels[level] ?? "")
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.75))

            // Buttons Row
            HStack {
                // Learn Button
                Button {
                    showLesson = true
                } label: {
                    HStack {
                        if !isLevelUnlocked(level) {
                            Image(systemName: "lock.fill")
                        }
                        Text(isLevelUnlocked(level) ? "Learn Now" : "Locked")
                    }
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(isLevelUnlocked(level) ? swiftColor : Color.gray.opacity(0.5))
                    .cornerRadius(12)
                }
                .disabled(!isLevelUnlocked(level))
                
                Spacer()
                
                if isLevelUnlocked(level) && level < 4 && (
                    (level == 1 && completedLevel1) ||
                    (level == 2 && completedLevel2) ||
                    (level == 3 && completedLevel3)
                ) {
                    Button {
                        withAnimation(.spring()) {
                            currentLevel = level + 1
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text("Next Level")
                            Image(systemName: "arrow.right.circle.fill")
                        }
                        .font(.subheadline.bold())
                        .foregroundColor(swiftColor)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(swiftColor.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
            }
            .padding(.top, 6)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(cardBackground)
                .shadow(color: .black.opacity(0.2), radius: 15, y: 8)
        )
    }

    // MARK: - Helpers
    private func levelName(for level: Int) -> String {
        switch level {
        case 1: return "Swift Basics"
        case 2: return "Intermediate Swift"
        case 3: return "Advanced Swift"
        case 4: return "Data Mastery"
        default: return "Swift Journey"
        }
    }

    private func isLevelUnlocked(_ level: Int) -> Bool {
        switch level {
        case 1: return true
        case 2: return completedLevel1
        case 3: return completedLevel2
        case 4: return completedLevel3
        default: return false
        }
    }

    private func goToNextLevel() {
        if currentLevel == 1 && lessonCompleted { currentLevel = 2 }
        else if currentLevel == 2 && lessonCompleted { currentLevel = 3 }
        else if currentLevel == 3 && lessonCompleted { currentLevel = 4 }

        // lessonCompleted will be updated automatically via .onChange
    }
}

#Preview {
    HomeScreen()
}
