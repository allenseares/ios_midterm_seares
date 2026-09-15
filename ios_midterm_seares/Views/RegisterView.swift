import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authController: AuthController
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var validationMessage: String?

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .leading) {
                LinearGradient(gradient: Gradient(colors: [.brandGreen, .green]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea(edges: .top)

                VStack(alignment: .leading, spacing: 10) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(12)
                    }

                    Text("Create account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Join your family's shared list.")
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
            .frame(height: 250)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("NAME")
                            .font(.caption)
                            .foregroundColor(.gray)
                        TextField("Your name", text: $name)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("EMAIL")
                            .font(.caption)
                            .foregroundColor(.gray)
                        // Auto-capitalization disabled for emails
                        TextField("you@family.com", text: $email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("PASSWORD")
                            .font(.caption)
                            .foregroundColor(.gray)
                        SecureField("At least 6 characters", text: $password)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("CONFIRM PASSWORD")
                            .font(.caption)
                            .foregroundColor(.gray)
                        SecureField("••••••••", text: $confirmPassword)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                    }

                    if let message = validationMessage ?? authController.errorMessage {
                        Text(message)
                            .font(.footnote)
                            .foregroundColor(.red)
                    }

                    Button(action: register) {
                        Group {
                            if authController.isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Text("Create Account")
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brandGreen)
                        .cornerRadius(12)
                    }
                    .disabled(authController.isLoading)
                    .padding(.top, 10)

                    HStack {
                        Spacer()
                        Text("Already have an account?")
                            .foregroundColor(.gray)
                        Button("Sign in") { dismiss() }
                            .foregroundColor(.brandGreen)
                        Spacer()
                    }
                    .font(.footnote)
                }
                .padding(30)
            }
            .background(Color.white)
        }
        .background(Color.white)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear { authController.errorMessage = nil }
    }

    private func register() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        if trimmedName.isEmpty {
            validationMessage = "Please enter your name."
        } else if email.isEmpty {
            validationMessage = "Please enter your email."
        } else if password.count < 6 {
            validationMessage = "Password must be at least 6 characters."
        } else if password != confirmPassword {
            validationMessage = "Passwords do not match."
        } else {
            validationMessage = nil
            authController.signUp(name: trimmedName, email: email, password: password)
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
    .environmentObject(AuthController())
}
