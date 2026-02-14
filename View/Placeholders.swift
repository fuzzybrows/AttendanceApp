import SwiftUI









struct ProfileView: View {
    @ObservedObject var session = SessionManager.shared
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let member = session.currentUser {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                    
                    Text(member.fullName)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(member.email)
                        .foregroundColor(.secondary)
                    
                    List {
                        Section(header: Text("Account")) {
                             HStack {
                                Text("Member ID")
                                Spacer()
                                Text("\(member.id)")
                                    .foregroundColor(.secondary)
                            }
                            HStack {
                                Text("Roles")
                                Spacer()
                                Text(member.roles.joined(separator: ", ").capitalized)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                         Section {
                            Button(action: {
                                SessionManager.shared.clearSession()
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Log Out")
                                        .foregroundColor(.red)
                                    Spacer()
                                }
                            }
                        }
                    }
                } else {
                    Text("Not logged in")
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct MemberHomeView: View {
    @ObservedObject var session = SessionManager.shared
    @StateObject var viewModel: MemberHomeViewModel
    
    init() {
        // Initialize ViewModel with current user ID if available, else 0 (fallback)
        let memberId = SessionManager.shared.currentUser?.id ?? 0
        _viewModel = StateObject(wrappedValue: MemberHomeViewModel(memberId: memberId))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Welcome & QR Section
                    if let member = session.currentUser {
                        VStack(spacing: 8) {
                            Text("Welcome, \(member.firstName)!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            // QR Code Card
                            VStack {
                                Text("Scan to Check In")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                    .padding(.top)
                                
                                Image(uiImage: QRUtils.generateQRCode(from: "MEMBER_\(member.id)"))
                                    .interpolation(.none)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                                    .padding()
                                
                                Text("MEMBER ID: \(member.id)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.bottom)
                            }
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(16)
                            .shadow(radius: 2)
                        }
                        .padding(.top)
                    }
                    
                    // Attendance History Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Recent Attendance")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            if viewModel.isLoading {
                                ProgressView()
                            } else {
                                Button(action: { viewModel.fetchAttendance() }) {
                                    Image(systemName: "arrow.clockwise")
                                }
                            }
                        }
                        
                        if viewModel.attendanceHistory.isEmpty && !viewModel.isLoading {
                            Text("No attendance records found.")
                                .foregroundColor(.secondary)
                                .padding()
                                .frame(maxWidth: .infinity)
                        } else {
                            ForEach(viewModel.attendanceHistory) { record in
                                AttendanceRow(record: record)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Home")
            .onAppear {
                viewModel.fetchAttendance()
            }
        }
    }
}

struct AttendanceRow: View {
    let record: Attendance
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(record.session?.title ?? "Unknown Session")
                    .font(.headline)
                Text(formatDate(record.timestamp))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            Text(record.submissionType.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .padding(6)
                .background(record.submissionType == "nfc" ? Color.blue.opacity(0.1) : Color.orange.opacity(0.1))
                .foregroundColor(record.submissionType == "nfc" ? .blue : .orange)
                .cornerRadius(4)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    func formatDate(_ isoString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        // Simple fallback parsing for "yyyy-MM-dd'T'HH:mm:ss"
        // Since we know the server format might vary or have fractional seconds issues
        let fallbackFormatter = DateFormatter()
        fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        fallbackFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .short
        
        if let date = isoFormatter.date(from: isoString) ?? fallbackFormatter.date(from: isoString) ?? fallbackFormatter.date(from: String(isoString.prefix(19))) {
             return displayFormatter.string(from: date)
        }
        return isoString
    }
}
