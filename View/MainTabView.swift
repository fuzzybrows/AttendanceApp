import SwiftUI

struct MainTabView: View {
    @ObservedObject var session = SessionManager.shared
    
    var body: some View {
        TabView {
            if session.isAdmin {
                DashboardView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                SessionsView()
                    .tabItem {
                        Label("Sessions", systemImage: "list.bullet")
                    }
                
                MembersView()
                    .tabItem {
                        Label("Members", systemImage: "person.2")
                    }
                
                InsightsView()
                    .tabItem {
                        Label("Insights", systemImage: "chart.bar")
                    }
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
            } else {
                MemberHomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
            }
        }
    }
}
