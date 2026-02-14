import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Stats Row
                    HStack(spacing: 12) {
                        StatCard(label: "Total", value: "\(viewModel.totalCount)", color: .blue)
                        StatCard(label: "Active", value: "\(viewModel.activeCount)", color: .green)
                        StatCard(label: "Concluded", value: "\(viewModel.concludedCount)", color: .orange)
                    }
                    .padding(.horizontal)
                    
                    // Active Sessions Header
                    HStack {
                        Text("🟢 Active Sessions")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    if viewModel.isLoading {
                        ProgressView()
                    } else if viewModel.activeSessions.isEmpty {
                        VStack {
                            Text("No active sessions")
                                .foregroundColor(.secondary)
                            Text("Tap + to create one") // Fab not implemented yet
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    } else {
                        ForEach(viewModel.activeSessions) { session in
                            NavigationLink(destination: SessionDetailView(session: session)) {
                                SessionCard(session: session)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Dashboard")
            .onAppear {
                viewModel.fetchSessions()
            }
        }
    }
}

struct StatCard: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct SessionCard: View {
    let session: Session
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(session.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(formatDate(session.startTime))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(session.type.capitalized)
                .font(.caption)
                .padding(6)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(4)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
    }
    
    func formatDate(_ isoString: String) -> String {
        // Simple formatter
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: isoString) {
            let display = DateFormatter()
            display.dateStyle = .medium
            display.timeStyle = .short
            return display.string(from: date)
        }
        return isoString
    }
}
