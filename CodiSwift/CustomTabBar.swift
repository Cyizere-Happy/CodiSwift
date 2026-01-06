import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    let swiftColor = Color(hex: "FF684B")
    let darkColor = Color(hex: "232223")
    
    var body: some View {
        HStack(spacing: 0) {
            // Home Tab
            TabBarButton(
                icon: "house.fill",
                title: "Home",
                isSelected: selectedTab == 0,
                swiftColor: swiftColor,
                darkColor: darkColor
            ) {
                selectedTab = 0
            }
            
            // Lessons Tab
            TabBarButton(
                icon: "book.fill",
                title: "Lessons",
                isSelected: selectedTab == 1,
                swiftColor: swiftColor,
                darkColor: darkColor
            ) {
                selectedTab = 1
            }
            
            // Practice Tab
            TabBarButton(
                icon: "pencil.circle.fill",
                title: "Practice",
                isSelected: selectedTab == 2,
                swiftColor: swiftColor,
                darkColor: darkColor
            ) {
                selectedTab = 2
            }
            
            // Live Tab
            TabBarButton(
                icon: "person.2.fill",
                title: "Live",
                isSelected: selectedTab == 3,
                swiftColor: swiftColor,
                darkColor: darkColor
            ) {
                selectedTab = 3
            }
            
            // Rank Tab
            TabBarButton(
                icon: "trophy.fill",
                title: "Rank",
                isSelected: selectedTab == 4,
                swiftColor: swiftColor,
                darkColor: darkColor
            ) {
                selectedTab = 4
            }
        }
        .padding(.vertical, 12)
        .padding(.bottom, 8)
        .background(
            ZStack {
                // Light blur background
                Color(hex: "4A4A4A")
                    .opacity(0.85)
                
                // Subtle gradient overlay
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.1),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .blur(radius: 20)
        )
        .overlay(
            Rectangle()
                .fill(Color.white.opacity(0.15))
                .frame(height: 0.5),
            alignment: .top
        )
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let swiftColor: Color
    let darkColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? swiftColor : .white.opacity(0.6))
                
                Text(title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(isSelected ? swiftColor : .white.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack {
            Spacer()
            CustomTabBar(selectedTab: .constant(1))
        }
    }
}
