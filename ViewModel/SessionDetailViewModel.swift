import Foundation

class SessionDetailViewModel: ObservableObject {
    @Published var attendanceList: [Attendance] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var message: String? // For success messages
    
    let session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    func fetchAttendance() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let list = try await AttendanceApi.shared.getAttendance(sessionId: session.id)
                await MainActor.run {
                    self.attendanceList = list.sorted(by: { $0.timestamp > $1.timestamp })
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to load attendance"
                    self.isLoading = false
                }
            }
        }
    }
    
    func markAttendance(memberId: Int, type: String = "manual") {
        isLoading = true
        
        Task {
            do {
                let request = AttendanceCreate(
                    memberId: memberId,
                    sessionId: session.id,
                    latitude: nil,
                    longitude: nil,
                    submissionType: type,
                    markedById: SessionManager.shared.currentUser?.id
                )
                
                _ = try await AttendanceApi.shared.markAttendance(request: request)
                
                await MainActor.run {
                    self.message = "Marked attendance for Member #\(memberId)"
                    self.fetchAttendance() // Refresh list
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to mark attendance"
                    self.isLoading = false
                }
            }
        }
    }
    
    func deleteAttendance(id: Int) {
        Task {
            do {
                try await AttendanceApi.shared.deleteAttendance(attendanceId: id)
                await MainActor.run {
                     self.message = "Attendance removed"
                     self.fetchAttendance()
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to delete"
                }
            }
        }
    }
}
