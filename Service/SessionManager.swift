import Foundation
import Combine

class SessionManager: ObservableObject {
    static let shared = SessionManager()
    
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: Member?
    @Published var isAdmin: Bool = false
    
    private let tokenKey = "auth_token"
    private let memberKey = "member_data"
    
    private init() {
        if let token = UserDefaults.standard.string(forKey: tokenKey) {
            self.isLoggedIn = true
            NetworkClient.shared.setAuthToken(token)
        }
        
        if let data = UserDefaults.standard.data(forKey: memberKey),
           let member = try? JSONDecoder().decode(Member.self, from: data) {
            self.currentUser = member
            self.isAdmin = member.permissions.contains("admin")
        }
    }
    
    func saveSession(token: String, member: Member) {
        UserDefaults.standard.set(token, forKey: tokenKey)
        if let encoded = try? JSONEncoder().encode(member) {
            UserDefaults.standard.set(encoded, forKey: memberKey)
        }
        
        NetworkClient.shared.setAuthToken(token)
        DispatchQueue.main.async {
            self.isLoggedIn = true
            self.currentUser = member
            self.isAdmin = member.permissions.contains("admin")
        }
    }
    
    func updateMember(_ member: Member) {
        if let encoded = try? JSONEncoder().encode(member) {
            UserDefaults.standard.set(encoded, forKey: memberKey)
        }
        DispatchQueue.main.async {
            self.currentUser = member
            self.isAdmin = member.permissions.contains("admin")
        }
    }
    
    func clearSession() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: memberKey)
        NetworkClient.shared.setAuthToken(nil)
        
        DispatchQueue.main.async {
            self.isLoggedIn = false
            self.currentUser = nil
            self.isAdmin = false
        }
    }
}
