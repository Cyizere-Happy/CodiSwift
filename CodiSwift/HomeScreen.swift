import SwiftUI
import SplineRuntime

struct HomeScreen: View {

    // MARK: - State
    @State private var currentLevel = 1
    @State private var showLesson = false
    @State private var lessonCompleted = false
    @State private var isExploring = false

    // MARK: - Persistent Progress
    @AppStorage("completedLevel1") private var completedLevel1 = false
    @AppStorage("completedLevel2") private var completedLevel2 = false
    @AppStorage("completedLevel3") private var completedLevel3 = false
    @AppStorage("completedLevel4") private var completedLevel4 = false
    @AppStorage("completedLevel5") private var completedLevel5 = false
    @AppStorage("completedLevel6") private var completedLevel6 = false

    // MARK: - Level Data
    private let levels: [Int: String] = [
        1: "Beginner: Learn Swift basics and simple exercises.",
        2: "Intermediate: Functions, loops, and SwiftUI views.",
        3: "Advanced: Combine, animations, and app architecture.",
        4: "Mastery: Arrays and Dictionaries for data management.",
        5: "Expert: Structs, Classes, and Reference Types.",
        6: "Master: Discover Optionals and safely handling nil values."
    ]

    // MARK: - Spline URLs
    private func splineURL(for level: Int) -> URL {
        switch level {
        case 1: return URL(string: "https://build.spline.design/ss3bhSleXBVYfeIqJNPO/scene.splineswift")!
        case 2: return URL(string: "https://build.spline.design/aJaptQp1Nuq4m4C7w8Du/scene.splineswift")!
        case 3: return URL(string: "https://build.spline.design/FVsJNvwkVCFlaBSLEuhJ/scene.splineswift")!
        case 4: return URL(string: "https://build.spline.design/EKPmjXqonYXCpuwbsZe4/scene.splineswift")!
        case 5: return URL(string: "https://build.spline.design/ECXA7Tr-GbGO3T7eEiSr/scene.splineswift")!
        case 6: return URL(string: "https://build.spline.design/KXEJJvHsFTPiKduFt0W9/scene.splineswift")!
        default: return URL(string: "https://build.spline.design/ss3bhSleXBVYfeIqJNPO/scene.splineswift")!
        }
    }

    // MARK: - Colors
    private let codiColor = Color.white
    private let swiftColor = Color(hex: "FF684B")
    private let cardBackground = Color.white.opacity(0.92)

    var body: some View {
        ZStack {
            // Background
            Color.black.ignoresSafeArea()
            SplineView(sceneFileURL: splineURL(for: currentLevel))
                .ignoresSafeArea()
                .id("spline-bg-id-\(currentLevel)")
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.6), value: currentLevel)

            // MARK: - Level Card (Top)
            if !isExploring {
                VStack {
                    TabView(selection: $currentLevel) {
                        ForEach(1...6, id: \.self) { level in
                            levelCard(for: level)
                                .padding(.horizontal, 20)
                                .frame(maxWidth: 600) // Center and limit width
                                .tag(level)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .frame(height: 300) // Slightly taller for iPad
                    .padding(.top, 40) // Lower the card from the top edge
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            // MARK: - Logo (Bottom)
            if !isExploring {
                VStack {
                    Spacer()
                    HStack(spacing: 0) {
                        Text("Codi").foregroundColor(codiColor)
                        Text("Swift").foregroundColor(swiftColor)
                    }
                    .font(.largeTitle.bold())
                    .shadow(radius: 10)
                    .padding(.bottom, 100)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }

            // MARK: - Explore Button (Floating)
            if !isExploring {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation(.easeInOut(duration: 0.6)) { isExploring = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                withAnimation(.easeInOut(duration: 0.6)) { isExploring = false }
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
                        .padding(.top, 330) // Adjusted for new card height/position
                    }
                    Spacer()
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .colorScheme(.light) // Force light scheme for the entire view to ensure visibility on iPad
        // Lesson Sheet
        .sheet(isPresented: $showLesson) {
            NewLessonView(level: currentLevel) { didComplete in
                lessonCompleted = didComplete
                switch currentLevel {
                case 1: completedLevel1 = didComplete
                case 2: completedLevel2 = didComplete
                case 3: completedLevel3 = didComplete
                case 4: completedLevel4 = didComplete
                case 5: completedLevel5 = didComplete
                case 6: completedLevel6 = didComplete
                default: break
                }
            }
        }
        .onChange(of: currentLevel) { _, newLevel in
            switch newLevel {
            case 1: lessonCompleted = completedLevel1
            case 2: lessonCompleted = completedLevel2
            case 3: lessonCompleted = completedLevel3
            case 4: lessonCompleted = completedLevel4
            case 5: lessonCompleted = completedLevel5
            case 6: lessonCompleted = completedLevel6
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
                    Image(systemName: "lock.fill").foregroundColor(.gray)
                } else {
                    Text("👋").font(.title2)
                }
            }

            Text(levelName(for: level))
                .font(.headline.bold())
                .foregroundColor(.black) // Explicitly black

            Text(levels[level] ?? "")
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.75)) // Explicitly dark

            HStack {
                Button {
                    showLesson = true
                } label: {
                    HStack {
                        if !isLevelUnlocked(level) { Image(systemName: "lock.fill") }
                        Text(isLevelUnlocked(level) ? "Learn Now" : "Locked")
                            .foregroundColor(.white) // Enforce white on orange/gray button
                    }
                    .font(.subheadline.bold())
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(isLevelUnlocked(level) ? swiftColor : Color.gray.opacity(0.5))
                    .cornerRadius(12)
                }
                .disabled(!isLevelUnlocked(level))

                Spacer()

                if isLevelUnlocked(level) && level < 5 && (
                    (level == 1 && completedLevel1) ||
                    (level == 2 && completedLevel2) ||
                    (level == 3 && completedLevel3) ||
                    (level == 4 && completedLevel4) ||
                    (level == 5 && completedLevel5)
                ) {
                    Button {
                        withAnimation(.spring()) { currentLevel = level + 1 }
                    } label: {
                        HStack(spacing: 4) {
                            Text("Next Level")
                                .foregroundColor(swiftColor)
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(swiftColor)
                        }
                        .font(.subheadline.bold())
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(swiftColor.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
            }
            .padding(.top, 8)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(cardBackground)
                .shadow(color: .black.opacity(0.2), radius: 15, y: 8)
        )
        .colorScheme(.light) // Force light scheme for the card content
    }

    // MARK: - Helpers
    private func levelName(for level: Int) -> String {
        switch level {
        case 1: return "Swift Basics"
        case 2: return "Intermediate Swift"
        case 3: return "Advanced Swift"
        case 4: return "Data Mastery"
        case 5: return "Structs & Classes"
        case 6: return "Swift Optionals"
        default: return "Swift Journey"
        }
    }

    private func isLevelUnlocked(_ level: Int) -> Bool {
        switch level {
        case 1: return true
        case 2: return completedLevel1
        case 3: return completedLevel2
        case 4: return completedLevel3
        case 5: return completedLevel4
        case 6: return completedLevel5
        default: return false
        }
    }
}

#Preview {
    HomeScreen()
}
