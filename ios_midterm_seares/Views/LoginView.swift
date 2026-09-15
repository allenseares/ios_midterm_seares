import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authController: AuthController
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .leading) {
                LinearGradient(gradient: Gradient(colors: [.brandGreen, .green]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea(edges: .top)
                
                VStack(alignment: .leading, spacing: 10) {
                    Image(systemName: "cart.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding(12)
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(12)
                    
                    Text("FamList")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Your family, one shared list.")
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
            .frame(height: 250)
            
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("EMAIL")
                        .font(.caption)
                        .foregroundColor(.gray)
                    // Auto-capitalization disabled for emails
                    TextField("you@family.com", text: $email)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("PASSWORD")
                        .font(.caption)
                        .foregroundColor(.gray)
                    SecureField("••••••••", text: $password)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                }
                
                HStack {
                    Spacer()
                    Button("Forgot password?") { }
                    .font(.footnote)
                    .foregroundColor(.brandGreen)
                }
                
                Button(action: {
                    authController.signIn(email: email, password: password)
                }) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brandGreen)
                        .cornerRadius(12)
                }
                .padding(.top, 10)
            }
            .padding(30)
            .background(Color.white)
            
            Spacer()
        }
        .background(Color.white)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthController())
}
