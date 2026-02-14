import Foundation
import Combine

class MemberHomeViewModel: ObservableObject {
    @Published var attendanceHistory: [Attendance] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let memberId: Int
    
    init(memberId: Int) {
        self.memberId = memberId
    }
    
    func fetchAttendance() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let history = try await AttendanceApi.shared.getMemberAttendance(memberId: memberId)
                await MainActor.run {
                    self.attendanceHistory = history.sorted(by: { $0.timestamp > $1.timestamp }) // Show recent first
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to load history"
                    self.isLoading = false
                    print("Attendance Fetch Error: \(error)")
                }
            }
        }
    }
}
