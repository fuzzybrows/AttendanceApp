import Foundation

struct Attendance: Codable, Identifiable {
    let id: Int
    let memberId: Int
    let sessionId: Int
    let latitude: Double?
    let longitude: Double?
    let submissionType: String
    let timestamp: String
    let markedById: Int?
    let session: Session?
    
    enum CodingKeys: String, CodingKey {
        case id
        case memberId = "member_id"
        case sessionId = "session_id"
        case latitude, longitude
        case submissionType = "submission_type"
        case timestamp
        case markedById = "marked_by_id"
        case session
    }
}

struct AttendanceCreate: Codable {
    let memberId: Int
    let sessionId: Int
    let latitude: Double?
    let longitude: Double?
    let submissionType: String
    let markedById: Int?
    
    enum CodingKeys: String, CodingKey {
        case memberId = "member_id"
        case sessionId = "session_id"
        case latitude, longitude
        case submissionType = "submission_type"
        case markedById = "marked_by_id"
    }
}

struct BulkDeleteRequest: Codable {
    let ids: [Int]
}
