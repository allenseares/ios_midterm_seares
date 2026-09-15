import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore

class AuthController: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var errorMessage: String?
    @Published var isLoading = false

    init() {
        // Listen for changes in the authentication state
        _ = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.userSession = user
        }
    }

    func signIn(email: String, password: String) {
        errorMessage = nil
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            self?.isLoading = false
            if let error = error {
                print("Failed to sign in: \(error.localizedDescription)")
                self?.errorMessage = error.localizedDescription
                return
            }
            print("Successfully signed in!")
        }
    }

    func signUp(name: String, email: String, password: String) {
        errorMessage = nil
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self else { return }
            if let error = error {
                print("Failed to sign up: \(error.localizedDescription)")
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                return
            }
            guard let user = result?.user else {
                self.isLoading = false
                return
            }

            // Store the chosen name on the Firebase user profile.
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { _ in }

            // Write the user document directly so the chosen name wins over the
            // email-prefix fallback FamilyController writes when the doc is missing.
            let member = FamilyMember(displayName: name, email: email, groupId: nil)
            try? Firestore.firestore().collection("users").document(user.uid)
                .setData(from: member, merge: true)

            self.isLoading = false
            print("Successfully signed up!")
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
