import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var login = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var navigateToOtp: Bool = false
    @Published var otpMethod: String?
    
    // OTP State
    @Published var otpCode = ""
    
    func loginUser() {
        guard !login.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter login and password"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let credentials = MemberLogin(login: login, password: password)
                let tokenResponse = try await AttendanceApi.shared.login(credentials: credentials)
                
                await MainActor.run {
                    isLoading = false
                    if let method = tokenResponse.method {
                        self.otpMethod = method
                        self.navigateToOtp = true
                    } else {
                        // Direct login
                        SessionManager.shared.saveSession(token: tokenResponse.accessToken, member: tokenResponse.member)
                    }
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "Login failed. Please check credentials."
                    print("Login Error: \(error)")
                }
            }
        }
    }
    
    func verifyOtp() {
        guard !otpCode.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let request = OTPVerification(login: login, otp: otpCode)
                let tokenResponse = try await AttendanceApi.shared.verifyOtp(request: request)
                
                await MainActor.run {
                    isLoading = false
                    SessionManager.shared.saveSession(token: tokenResponse.accessToken, member: tokenResponse.member)
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "Invalid OTP"
                }
            }
        }
    }
}
