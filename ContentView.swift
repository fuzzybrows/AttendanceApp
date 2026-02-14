import SwiftUI

struct ContentView: View {
    @ObservedObject var session = SessionManager.shared
    
    var body: some View {
        if session.isLoggedIn {
            MainTabView()
        } else {
            LoginView()
        }
    }
}
