import Foundation

class AttendanceApi {
    static let shared = AttendanceApi()
    private let client = NetworkClient.shared
    
    // MARK: - Auth
    
    func login(credentials: MemberLogin) async throws -> Token {
        return try await client.fetch(path: "auth/login", method: "POST", body: credentials)
    }
    
    func verifyOtp(request: OTPVerification) async throws -> Token {
        return try await client.fetch(path: "auth/verify-otp", method: "POST", body: request)
    }
    
    // MARK: - Members
    
    func getMembers() async throws -> [Member] {
        return try await client.fetch(path: "members/")
    }
    
    func getMember(id: Int) async throws -> Member {
        return try await client.fetch(path: "members/\(id)")
    }
    
    // MARK: - Sessions
    
    func getSessions() async throws -> [Session] {
        return try await client.fetch(path: "sessions/")
    }
    
    func createSession(request: SessionCreate) async throws -> Session {
        return try await client.fetch(path: "sessions/", method: "POST", body: request)
    }
    
    // MARK: - Attendance
    
    func getAttendance(sessionId: Int) async throws -> [Attendance] {
        return try await client.fetch(path: "attendance/session/\(sessionId)")
    }
    
    func markAttendance(request: AttendanceCreate) async throws -> Attendance {
        // AttendanceCreate response might be different or same. Android expects Attendance.
        return try await client.fetch(path: "attendance/", method: "POST", body: request)
    }
    
    func getMemberAttendance(memberId: Int) async throws -> [Attendance] {
        return try await client.fetch(path: "attendance/member/\(memberId)")
    }
    
    func deleteAttendance(attendanceId: Int) async throws {
        try await client.perform(path: "attendance/\(attendanceId)", method: "DELETE")
    }
    
    func bulkDeleteAttendance(request: BulkDeleteRequest) async throws {
        try await client.perform(path: "attendance/bulk-delete", method: "POST", body: request)
    }
    
    // MARK: - Stats
    
    func getOverallStats() async throws -> [MemberStat] {
        return try await client.fetch(path: "attendance/stats")
    }
}
