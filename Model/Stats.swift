import Foundation

struct MemberStat: Codable, Identifiable {
    var id: Int { memberId }
    let memberId: Int
    let name: String
    let totalSessions: Int
    let promptCount: Int
    let lateCount: Int
    let promptRate: Double
    
    enum CodingKeys: String, CodingKey {
        case memberId = "member_id"
        case name
        case totalSessions = "total_sessions"
        case promptCount = "prompt_count"
        case lateCount = "late_count"
        case promptRate = "prompt_rate"
    }
}
