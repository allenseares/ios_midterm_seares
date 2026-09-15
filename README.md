# FamList

A shared family shopping list built with SwiftUI and Firebase.

Every family member joins a group with an invite code, adds items to buy,
and taps **Bought!** once an item has been purchased. Changes sync to all
members in real time via Cloud Firestore.

## Project structure (MVC)

```
ios_midterm_seares/
├── ios_midterm_searesApp.swift   App entry point; configures Firebase and injects controllers
├── Model/                        Plain data types mirrored in Firestore
│   ├── FamilyGroup.swift         groups/{groupId}
│   ├── FamilyMember.swift        users/{uid}
│   └── ShoppingItem.swift        groups/{groupId}/items/{itemId}
├── Controller/                   Business logic + Firebase access (ObservableObject)
│   ├── AuthController.swift      Sign in / sign out, auth state
│   └── FamilyController.swift    Create/join/leave group, add items, mark bought
└── Views/                        SwiftUI screens
    ├── ContentView.swift         Routes to Login or Main tabs based on auth state
    ├── LoginView.swift
    ├── MainTabView.swift         List · History · Family · Settings
    ├── ListView.swift            Items still to buy, + button, Bought! action
    ├── HistoryView.swift         Items already bought
    ├── FamilyView.swift          Create / join group, members, invite code
    ├── SettingsView.swift
    └── Components/               Reusable view pieces
        ├── ItemRowCard.swift
        ├── AddItemSheet.swift
        ├── MemberAvatar.swift
        ├── NoGroupPlaceholder.swift
        └── Color+Extensions.swift
```

Views never talk to Firebase directly - they read state from and call
methods on the controllers, which are injected with `.environmentObject`.

## Firebase setup

1. Enable **Authentication → Email/Password**.
2. Enable **Cloud Firestore** and use these rules:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```
