import SwiftUI

struct IntroductionView: View {

    // MARK: - Colors
    let codiColor = Color(hex: "232223")
    let swiftColor = Color(hex: "FF684B")
    let backgroundColor = Color(hex: "DDCEC4")

    // MARK: - State
    @State private var showLogo = false
    @State private var showTitle = false
    @State private var showSteps = false
    @State private var showCountdown = false

    @State private var countdown = 5
    @State private var navigateToHome = false

    // Slower countdown tick
    private let timer = Timer.publish(every: 1.3, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {

            backgroundLayer

            VStack(spacing: 22) {

                Spacer(minLength: 40)

                logoView

                titleView

                // Steps
                VStack(spacing: 14) {
                    stepRow("Learn new concepts", emoji: "🐱📚")
                        .animation(.easeOut(duration: 1.0).delay(0.1), value: showSteps)

                    stepRow("Answer fun questions", emoji: "🐭🧩")
                        .animation(.easeOut(duration: 1.0).delay(0.3), value: showSteps)

                    stepRow("Unlock new adventures", emoji: "🚀✨")
                        .animation(.easeOut(duration: 1.0).delay(0.5), value: showSteps)
                }
                .opacity(showSteps ? 1 : 0)
                .offset(y: showSteps ? 0 : 12)

                Spacer()

                if showCountdown {
                    countdownView
                        .transition(.opacity)
                }
            }
            .padding(.horizontal, 24)
        }
        .onAppear {
            startSequence()
        }
        .onReceive(timer) { _ in
            guard showCountdown else { return }

            if countdown > 0 {
                countdown -= 1
            } else {
                navigateToHome = true
            }
        }
        .fullScreenCover(isPresented: $navigateToHome) {
            HomeScreen()
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Background
    private var backgroundLayer: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            RadialGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.25),
                    Color.clear
                ]),
                center: .top,
                startRadius: 80,
                endRadius: 400
            )
            .ignoresSafeArea()
        }
    }

    // MARK: - Logo
    private var logoView: some View {
        HStack(spacing: 0) {
            Text("Codi")
                .foregroundColor(codiColor)
            Text("Swift")
                .foregroundColor(swiftColor)
        }
        .font(.system(size: 42, weight: .bold, design: .rounded))
        .opacity(showLogo ? 1 : 0)
        .offset(y: showLogo ? 0 : 14)
        .animation(.easeOut(duration: 1.2), value: showLogo)
    }

    // MARK: - Title
    private var titleView: some View {
        Text("Welcome to Codi’s World")
            .font(.system(size: 22, weight: .semibold))
            .foregroundColor(codiColor)
            .multilineTextAlignment(.center)
            .opacity(showTitle ? 1 : 0)
            .offset(y: showTitle ? 0 : 12)
            .animation(.easeOut(duration: 1.1), value: showTitle)
    }

    // MARK: - Step Row
    private func stepRow(_ text: String, emoji: String) -> some View {
        HStack(spacing: 12) {
            Text(emoji)
                .font(.title3)

            Text(text)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(codiColor.opacity(0.75))

            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.55))
        )
    }

    // MARK: - Countdown
    private var countdownView: some View {
        Text("Starting in \(countdown)…")
            .font(.footnote.weight(.medium))
            .foregroundColor(swiftColor)
            .padding(.bottom, 16)
    }

    // MARK: - Entrance Sequence (SLOWED)
    private func startSequence() {
        // Logo
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            showLogo = true
        }

        // Title
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            showTitle = true
        }

        // Steps
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            showSteps = true
        }

        // Countdown (after reading time)
        DispatchQueue.main.asyncAfter(deadline: .now() + 9.0) {
            showCountdown = true
        }
    }
}

//


#Preview {
    IntroductionView()
}
