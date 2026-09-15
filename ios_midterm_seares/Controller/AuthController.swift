import SwiftUI
import Combine
import FirebaseAuth

class AuthController: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    
    init() {
        // Listen for changes in the authentication state
        _ = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.userSession = user
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Failed to sign in: \(error.localizedDescription)")
                return
            }
            print("Successfully signed in!")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Failed to sign out: \(error.localizedDescription)")
        }
    }
}
