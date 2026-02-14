import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Choir Attendance")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer().frame(height: 20)
                    
                    TextField("Email or Username", text: $viewModel.login)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button(action: {
                        viewModel.loginUser()
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("Log In")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .disabled(viewModel.isLoading)
                }
                .padding()
            }
            .navigationDestination(isPresented: $viewModel.navigateToOtp) {
                OtpView(viewModel: viewModel)
            }
        }
    }
}

struct OtpView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Enter OTP")
                    .font(.title)
                
                Text("A code was sent via \(viewModel.otpMethod ?? "your preferred method")")
                    .font(.body)
                    .multilineTextAlignment(.center)
                
                TextField("OTP Code", text: $viewModel.otpCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
                Button(action: {
                    viewModel.verifyOtp()
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Verify")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .disabled(viewModel.isLoading)
            }
            .padding()
        }
    }
}
