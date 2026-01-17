import SwiftUI

struct MainTabView: View {
    @AppStorage("selectedTab") var selectedTab = 0
    
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.verticalSizeClass) var vSizeClass
    
    let swiftColor = Color(hex: "FF684B")
    
    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height && sizeClass == .regular
            
            if isLandscape {
                // iPad Landscape: Custom Aesthetic Sidebar
                HStack(spacing: 0) {
                    CustomSidebar(selectedTab: $selectedTab)
                    
                    tabContent
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .background(Color(hex: "1a1a1a"))
                .ignoresSafeArea()
            } else {
                // iPhone or iPad Portrait: Original Bottom Tab Bar
                ZStack {
                    tabContent
                    
                    VStack {
                        Spacer()
                        CustomTabBar(selectedTab: $selectedTab)
                    }
                    .ignoresSafeArea(.keyboard)
                }
                .edgesIgnoringSafeArea(.bottom)
                .toolbar(.hidden, for: .navigationBar)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    @ViewBuilder
    private var tabContent: some View {
        Group {
            switch selectedTab {
            case 0: HomeView()
            case 1: HomeScreen()
            case 2: PracticeView()
            case 3: LiveView()
            case 4: RankView()
            default: HomeView()
            }
        }
    }
}

// MARK: - Custom Aesthetic Sidebar
struct CustomSidebar: View {
    @Binding var selectedTab: Int
    let swiftColor = Color(hex: "FF684B")
    
    var body: some View {
        VStack(spacing: 30) {
            // Logo
            HStack(spacing: 0) {
                Text("Codi")
                    .foregroundColor(.white)
                Text("Swift")
                    .foregroundColor(swiftColor)
            }
            .font(.title2.bold())
            .padding(.top, 40)
            
            // Menu Items
            VStack(spacing: 12) {
                SidebarItem(title: "Home", icon: "house.fill", tag: 0, selectedTab: $selectedTab)
                SidebarItem(title: "Lessons", icon: "book.fill", tag: 1, selectedTab: $selectedTab)
                SidebarItem(title: "Practice", icon: "pencil.circle.fill", tag: 2, selectedTab: $selectedTab)
                SidebarItem(title: "Live", icon: "person.2.fill", tag: 3, selectedTab: $selectedTab)
                SidebarItem(title: "Rank", icon: "trophy.fill", tag: 4, selectedTab: $selectedTab)
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .frame(width: 240)
        .background(
            ZStack {
                Color.black.opacity(0.3)
                VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialDark))
            }
        )
        .clipShape(CustomSidebarCorner(radius: 40, corners: [.topRight, .bottomRight]))
        .shadow(color: .black.opacity(0.3), radius: 20, x: 10, y: 0)
    }
}

struct SidebarItem: View {
    let title: String
    let icon: String
    let tag: Int
    @Binding var selectedTab: Int
    
    let swiftColor = Color(hex: "FF684B")
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                selectedTab = tag
            }
        } label: {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .frame(width: 25)
                
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                
                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                ZStack {
                    if selectedTab == tag {
                        Capsule()
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    } else {
                        Capsule()
                            .fill(Color.white.opacity(0.1))
                    }
                }
            )
            .foregroundColor(selectedTab == tag ? .black : .white)
            .scaleEffect(selectedTab == tag ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<VisualEffectView>) -> UIVisualEffectView {
        UIVisualEffectView(effect: effect)
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<VisualEffectView>) {
        uiView.effect = effect
    }
}

struct CustomSidebarCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
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
                .padding(.bottom, 0)
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
