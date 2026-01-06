import SwiftUI

struct MainTabView: View {
    @AppStorage("selectedTab") var selectedTab = 0
    
    var body: some View {
        ZStack {
            // Content based on selected tab
            Group {
                switch selectedTab {
                case 0:
                    TabContentWrapper {
                        HomeView() // New Home dashboard
                    }
                case 1:
                    TabContentWrapper {
                        HomeScreen() // Lessons view shows HomeScreen
                    }
                case 2:
                    TabContentWrapper {
                        PracticeView() // Practice challenges
                    }
                case 3:
                    TabContentWrapper {
                        LiveView() // Live competiti
                    }
                case 4:
                    TabContentWrapper {
                        RankView()
                    }
                default:
                    TabContentWrapper {
                        HomeView()
                    }
                }
            }
            
            // Custom Tab Bar at b
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

// Wrapper to add bottom padding for tab bar
struct TabContentWrapper<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(.bottom, 0) // No extra padding needed since
    }
}

// Placeholder view for tabs that aren't implemented yet
struct PlaceholderView: View {
    let title: String
    let icon: String
    
    let swiftColor = Color(hex: "FF684B")
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [Color(hex: "232223"), Color(hex: "1a1a1a")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: icon)
                    .font(.system(size: 80))
                    .foregroundColor(swiftColor)
                
                Text(title)
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                Text("Coming Soon!")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
    }
}

#Preview {
    MainTabView()
}
