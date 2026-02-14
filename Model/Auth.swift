import Foundation

struct MemberLogin: Codable {
    let login: String
    let password: String
}

struct Token: Codable {
    let accessToken: String
    let tokenType: String
    let member: Member
    let status: String?
    let method: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case member, status, method
    }
}

struct OTPVerification: Codable {
    let login: String
    let otp: String
}
