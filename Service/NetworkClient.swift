import Foundation

class NetworkClient {
    static let shared = NetworkClient()
    
    // Default to the IP found in Android config, or localhost if testing on simulator
    // Note: iOS Simulator can access localhost, but physical device needs IP.
    // Using the IP found in Android config: 192.168.0.173:8001
    private let baseURL = "http://192.168.0.173:8001" 
    
    private var authToken: String?
    
    private init() {}
    
    func setAuthToken(_ token: String?) {
        self.authToken = token
    }
    
    enum NetworkError: Error {
        case invalidURL
        case requestFailed
        case decodingFailed
        case serverError(String)
        case unauthorized
    }
    
    func fetch<T: Decodable>(path: String, method: String = "GET", body: Encodable? = nil) async throws -> T {
        guard let url = URL(string: "\(baseURL)/\(path)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.requestFailed
        }
        
        if httpResponse.statusCode == 401 {
             DispatchQueue.main.async {
                 SessionManager.shared.clearSession()
             }
             throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError("Status code: \(httpResponse.statusCode)")
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
             if let str = String(data: data, encoding: .utf8) {
                 print("Response body: \(str)")
             }
            throw NetworkError.decodingFailed
        }
    }
    
    // Helper for calls that don't return a body
    func perform(path: String, method: String = "GET", body: Encodable? = nil) async throws {
         guard let url = URL(string: "\(baseURL)/\(path)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.requestFailed
        }
        
        if httpResponse.statusCode == 401 {
             DispatchQueue.main.async {
                 SessionManager.shared.clearSession()
             }
             throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
             throw NetworkError.serverError("Status code: \(httpResponse.statusCode)")
        }
    }
}
