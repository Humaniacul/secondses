import SwiftUI

struct ContentView: View {
    @State private var appState = AppState()
    @State private var hasCheckedAuth = false
    @State private var selectedTab = 0
    @State private var showCheckedIn = true

    var body: some View {
        Group {
            if !hasCheckedAuth {
                ZStack {
                    AppTheme.charcoal.ignoresSafeArea()
                    ProgressView()
                        .tint(AppTheme.terracotta)
                }
            } else if !appState.isAuthenticated {
                SplashView(appState: appState)
            } else if appState.needsOnboarding {
                OnboardingView(appState: appState)
            } else if !appState.hasCheckedInToday {
                UrgeTrackerView(appState: appState)
            } else if showCheckedIn && !appState.navigateToAIFromUrge {
                CheckedInView(appState: appState) {
                    showCheckedIn = false
                }
            } else {
                MainTabView(appState: appState, selectedTab: $selectedTab)
            }
        }
        .preferredColorScheme(.dark)
        .task {
            await appState.checkAuth()
            hasCheckedAuth = true
        }
        .onChange(of: appState.hasCheckedInToday) { _, newValue in
            if newValue && appState.navigateToAIFromUrge {
                showCheckedIn = false
                selectedTab = 2
                appState.navigateToAIFromUrge = false
            }
        }
        .onChange(of: appState.isAuthenticated) { _, newValue in
            if !newValue {
                showCheckedIn = true
                selectedTab = 0
            }
        }
    }
}

struct MainTabView: View {
    let appState: AppState
    @Binding var selectedTab: Int

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: 0) {
                HomeView(appState: appState, selectedTab: $selectedTab)
            }

            Tab("Community", systemImage: "person.3.fill", value: 1) {
                CommunityListView(appState: appState)
            }

            Tab("Companion", systemImage: "message.fill", value: 2) {
                AICompanionView(appState: appState)
            }

            Tab("Profile", systemImage: "person.fill", value: 3) {
                ProfileView(appState: appState)
            }
        }
        .tint(AppTheme.terracotta)
    }
}
