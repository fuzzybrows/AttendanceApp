import SwiftUI

struct SessionDetailView: View {
    let session: Session
    @StateObject var viewModel: SessionDetailViewModel
    
    @State private var showingNFCAlert = false
    @State private var showingQRScanner = false
    
    init(session: Session) {
        self.session = session
        _viewModel = StateObject(wrappedValue: SessionDetailViewModel(session: session))
    }
    
    var body: some View {
        VStack {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text(session.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                HStack {
                    Label(session.status.capitalized, systemImage: "clock")
                        .font(.subheadline)
                        .foregroundColor(session.status == "active" ? .green : .secondary)
                    
                    Spacer()
                    
                    Text(session.type.capitalized)
                        .padding(6)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(4)
                }
            }
            .padding()
            
            // Actions
            HStack(spacing: 20) {
                Button(action: { showingNFCAlert = true }) {
                    VStack {
                        Image(systemName: "wave.3.right")
                            .font(.title)
                        Text("NFC Scan")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                }
                
                Button(action: { showingQRScanner = true }) {
                    VStack {
                        Image(systemName: "qrcode.viewfinder")
                            .font(.title)
                        Text("QR Scan")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            
            // List
            List {
                Section(header: Text("Attendance (\(viewModel.attendanceList.count))")) {
                    ForEach(viewModel.attendanceList) { attendance in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Member #\(attendance.memberId)") // Ideally we map ID to Name using a Member repository
                                    .font(.headline)
                                Text(attendance.timestamp)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(attendance.submissionType.uppercased())
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteAttendance(id: attendance.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            
        }
        .navigationTitle("Session Detail")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchAttendance()
        }
        .alert("NFC Scanning", isPresented: $showingNFCAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Simulate Tag") {
                // Simulate scanning a member (e.g. Member ID 1)
                viewModel.markAttendance(memberId: 1, type: "nfc")
            }
        } message: {
            Text("NFC Scanning requires a physical device. Tap 'Simulate' to test logic.")
        }
        .sheet(isPresented: $showingQRScanner) {
            // Placeholder for QR Scanner View
            VStack {
                Text("QR Scanner Placeholder")
                Button("Simulate QR Scan (Member 2)") {
                    viewModel.markAttendance(memberId: 2, type: "qr")
                    showingQRScanner = false
                }
                .padding()
                Button("Close") {
                    showingQRScanner = false
                }
            }
        }
    }
}
