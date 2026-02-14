import SwiftUI

struct MembersView: View {
    @StateObject private var viewModel = MembersViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.filteredMembers) { member in
                NavigationLink(destination: MemberDetailView(member: member)) {
                    VStack(alignment: .leading) {
                        Text(member.fullName)
                            .font(.headline)
                        Text(member.email)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Members")
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search members")
            .onAppear {
                viewModel.fetchMembers()
            }
            .refreshable {
                viewModel.fetchMembers()
            }
        }
    }
}

struct MemberDetailView: View {
    let member: Member
    
    var body: some View {
        Form {
            Section(header: Text("Personal Info")) {
                LabeledContent("First Name", value: member.firstName)
                LabeledContent("Last Name", value: member.lastName)
                LabeledContent("Email", value: member.email)
                LabeledContent("Phone", value: member.phoneNumber ?? "N/A")
            }
            
            Section(header: Text("Roles")) {
                if member.roles.isEmpty {
                    Text("No roles assigned")
                } else {
                    ForEach(member.roles, id: \.self) { role in
                        Text(role.capitalized)
                    }
                }
            }
            
            Section(header: Text("System")) {
                LabeledContent("NFC ID", value: member.nfcId ?? "Not set")
                LabeledContent("ID", value: "\(member.id)")
            }
            
            Section {
                 // Placeholder for Edit logic
                 Button("Edit Member (Coming Soon)") {
                     
                 }
                 .disabled(true)
            }
        }
        .navigationTitle(member.fullName)
    }
}
