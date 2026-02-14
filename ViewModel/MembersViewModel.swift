import Foundation

class MembersViewModel: ObservableObject {
    @Published var members: [Member] = []
    @Published var searchText: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var filteredMembers: [Member] {
        if searchText.isEmpty {
             return members
        } else {
            return members.filter {
                $0.fullName.localizedCaseInsensitiveContains(searchText) ||
                $0.email.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func fetchMembers() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let list = try await AttendanceApi.shared.getMembers()
                await MainActor.run {
                    self.members = list.sorted(by: { $0.firstName < $1.firstName })
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to load members"
                    self.isLoading = false
                }
            }
        }
    }
}
