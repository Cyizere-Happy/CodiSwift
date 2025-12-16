import SwiftUI
import SplineRuntime

struct ContentView: View {
    @State private var showSplash = true
    @State private var dotIndex = 0
    @State private var timer: Timer?
    @State private var showButton = false
    @State private var goToIntro = false

    // Brand Colors
    let codiColor = Color(hex: "232223")
    let swiftColor = Color(hex: "FF684B")

    var body: some View {
        NavigationStack {
            ZStack {
                // 🔹 Persistent Spline 3D background
                OnBoard3DView()
                    .ignoresSafeArea()

                // 🔹 Splash Overlay
                if showSplash {
                    Color.white
                        .ignoresSafeArea()

                    VStack(spacing: 40) {
                        HStack(spacing: 0) {
                            Text("Codi")
                                .foregroundColor(codiColor)
                            Text("Swift")
                                .foregroundColor(swiftColor)
                        }
                        .font(.largeTitle.bold())

                        // Loading dots
                        HStack(spacing: 8) {
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .fill(index == dotIndex ? swiftColor : swiftColor.opacity(0.3))
                                    .frame(width: 12, height: 12)
                            }
                        }
                    }
                    .onAppear {
                        startLoadingDots()

                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            showSplash = false
                            timer?.invalidate()

                            withAnimation(.easeOut(duration: 0.8)) {
                                showButton = true
                            }
                        }
                    }
                }

                // 🔹 Get Started Button
                if showButton && !showSplash {
                    VStack {
                        Spacer()

                        Button {
                            goToIntro = true
                        } label: {
                            Text("Get Started")
                                .font(.headline.bold())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 40)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            // 🔹 Navigation to IntroductionView
            .navigationDestination(isPresented: $goToIntro) {
                IntroductionView()
            }
            .navigationBarHidden(true)
        }
    }

    // Loading dots animation
    func startLoadingDots() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            dotIndex = (dotIndex + 1) % 3
        }
    }
}

//
// MARK: - Spline 3D View
//
struct OnBoard3DView: View {
    var body: some View {
        let url = URL(
            string: "https://build.spline.design/oK3pQ3Db0QPisoxFPQUm/scene.splineswift"
        )!
        SplineView(sceneFileURL: url)
    }
}


//
// MARK: - HEX Color Helper
//
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}

//
// MARK: - Preview
//
#Preview {
    ContentView()
}
