import Foundation

struct Session: Codable, Identifiable {
    let id: Int
    let title: String
    let type: String
    let status: String
    let startTime: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, type, status
        case startTime = "start_time"
    }
}

struct SessionCreate: Codable {
    let title: String
    let type: String
    let startTime: String
    
    enum CodingKeys: String, CodingKey {
        case title, type
        case startTime = "start_time"
    }
}
