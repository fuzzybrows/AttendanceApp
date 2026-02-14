import Foundation

class DashboardViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var activeSessions: [Session] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Stats
    @Published var totalCount = 0
    @Published var activeCount = 0
    @Published var concludedCount = 0
    
    func fetchSessions() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let allSessions = try await AttendanceApi.shared.getSessions()
                await MainActor.run {
                    self.sessions = allSessions
                    self.activeSessions = allSessions.filter { $0.status == "active" }
                    
                    self.totalCount = allSessions.count
                    self.activeCount = self.activeSessions.count
                    self.concludedCount = allSessions.filter { $0.status == "concluded" }.count
                    
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to load sessions"
                    self.isLoading = false
                }
            }
        }
    }
}
