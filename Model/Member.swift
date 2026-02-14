import Foundation

struct Member: Codable, Identifiable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String?
    let nfcId: String?
    let fullName: String
    let roles: [String]
    let permissions: [String]
    let emailVerified: Bool
    let phoneNumberVerified: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneNumber = "phone_number"
        case nfcId = "nfc_id"
        case fullName = "full_name"
        case roles
        case permissions
        case emailVerified = "email_verified"
        case phoneNumberVerified = "phone_number_verified"
    }
}

struct MemberCreate: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String?
    let nfcId: String?
    let roles: [String]
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneNumber = "phone_number"
        case nfcId = "nfc_id"
        case roles
    }
}
