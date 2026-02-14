import Foundation

class InsightsViewModel: ObservableObject {
    @Published var stats: [MemberStat] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchStats() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let list = try await AttendanceApi.shared.getOverallStats()
                await MainActor.run {
                    // Sort by prompt rate descending
                    self.stats = list.sorted(by: { $0.promptRate > $1.promptRate })
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to load stats"
                    self.isLoading = false
                }
            }
        }
    }
}
