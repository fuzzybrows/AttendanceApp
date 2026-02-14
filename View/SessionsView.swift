import SwiftUI

struct SessionsView: View {
    @StateObject private var viewModel = SessionsViewModel()
    @State private var showingCreateSheet = false
    
    var body: some View {
        NavigationStack {
             List(viewModel.filteredSessions) { session in
                NavigationLink(destination: SessionDetailView(session: session)) {
                    SessionListRow(session: session)
                }
            }
            .navigationTitle("All Sessions")
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search sessions")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingCreateSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingCreateSheet) {
                CreateSessionView(viewModel: viewModel, isPresented: $showingCreateSheet)
            }
            .onAppear {
                viewModel.fetchSessions()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Text("Error loading sessions")
                            .font(.headline)
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Button("Retry") {
                            viewModel.fetchSessions()
                        }
                        .padding(.top)
                    }
                } else if viewModel.filteredSessions.isEmpty {
                    ContentUnavailableView("No Sessions", systemImage: "list.bullet.rectangle.portrait", description: Text("Try adjusting your search or create a new session."))
                }
            }
            .refreshable {
                viewModel.fetchSessions()
            }
        }
    }
}

struct CreateSessionView: View {
    @ObservedObject var viewModel: SessionsViewModel
    @Binding var isPresented: Bool
    
    @State private var title = ""
    @State private var type = "rehearsal"
    @State private var startTime = Date()
    
    let types = ["rehearsal", "service", "concert", "other"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Session Title", text: $title)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) { type in
                        Text(type.capitalized).tag(type)
                    }
                }
                
                DatePicker("Start Time", selection: $startTime)
                
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .navigationTitle("New Session")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        viewModel.createSession(title: title, type: type, startTime: startTime)
                        isPresented = false
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

struct SessionListRow: View {
    let session: Session
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(session.title)
                .font(.headline)
            HStack {
                Text(session.type.capitalized)
                    .font(.caption)
                    .padding(4)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(4)
                Spacer()
                Text(session.status.capitalized)
                    .font(.caption)
                    .foregroundColor(session.status == "active" ? .green : .secondary)
            }
        }
    }
}
