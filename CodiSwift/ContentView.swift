import SwiftUI
import SplineRuntime

struct ContentView: View {
    // Phase control
    @State private var showSplashPhase = true
    @State private var showButton = false
    @State private var goToHome = false

    // Brand Colors
    let codiColor = Color(hex: "232223")
    let swiftColor = Color(hex: "FF684B")

    var body: some View {
        NavigationStack {
            ZStack {
                // 🔹 SECTION 1: Initial Splash (First 5s)
                if showSplashPhase {
                    ZStack {
                        Color.black.ignoresSafeArea() // Ensure dark background
                        
                        // New Spline Scene
                        SplashSplineView()
                            .ignoresSafeArea()
                        
                        // CodiSwift Logo - Bottom
                        VStack {
                            Spacer()
                            logoView
                                .padding(.bottom, 60)
                        }
                        .allowsHitTesting(false) // Let touches pass through to Spline
                    }
                    .transition(.opacity) // Fade out when switching
                }
                
                // 🔹 SECTION 2: Main Onboarding (After 5s)
                else {
                    ZStack {
                    
                        OnBoard3DView()
                            .ignoresSafeArea()

                        // Content Overlay
                        ZStack {
                            // No Logo on this page

                            // Get Started Button
                            if showButton {
                                VStack {
                                    Spacer()
                                    
                                    Button {
                                        goToHome = true
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
                    }
                    .transition(.opacity) // Fade in
                }
            }
            .onAppear {
                // Sequence Logic
                if showSplashPhase {
                    // Wait 10 seconds, then switch phases
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            showSplashPhase = false
                        }
                        
                        // Show button slightly after the transition completes
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            withAnimation(.easeOut) {
                                showButton = true
                            }
                        }
                    }
                }
            }
            // 🔹 Navigation to Main Home Screen
            .navigationDestination(isPresented: $goToHome) {
                MainTabView()
                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true) // Fix: Hide nav bar to prevent layout push
            }
            .navigationBarHidden(true)
        }
    }
    
    // Shared Logo Component
    var logoView: some View {
        HStack(spacing: 0) {
            Text("Codi")
                .foregroundColor(.white)
            Text("Swift")
                .foregroundColor(swiftColor)
        }
        .font(.largeTitle.bold())
    }
}

//
// MARK: - Scene 1: New Splash Spline (First 5s)
//
struct SplashSplineView: View {
    var body: some View {
        let url = URL(
            string: "https://build.spline.design/vXWr72AJ9pN1f1LOXqRJ/scene.splineswift"
        )!
        SplineView(sceneFileURL: url)
    }
}

//
// MARK: - Scene 2: Original/Onboarding Spline (After 5s)
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
