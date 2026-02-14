import Foundation

class SessionsViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var searchText: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var filteredSessions: [Session] {
        if searchText.isEmpty {
            return sessions
        } else {
            return sessions.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func fetchSessions() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let list = try await AttendanceApi.shared.getSessions()
                await MainActor.run {
                    self.sessions = list.sorted(by: { $0.startTime > $1.startTime })
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
    
    func createSession(title: String, type: String, startTime: Date) {
        isLoading = true
        errorMessage = nil
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let dateString = formatter.string(from: startTime)
        
        let request = SessionCreate(title: title, type: type, startTime: dateString)
        
        Task {
            do {
                _ = try await AttendanceApi.shared.createSession(request: request)
                await MainActor.run {
                    self.isLoading = false
                    self.fetchSessions()
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to create session"
                    self.isLoading = false
                }
            }
        }
    }
}
