import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authController: AuthController
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button(action: {
                        authController.signOut()
                    }) {
                        HStack {
                            Text("Sign Out")
                                .foregroundColor(.red)
                            Spacer()
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthController())
}
