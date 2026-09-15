import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ListView()
                .tabItem {
                    Image(systemName: "list.clipboard")
                    Text("List")
                }
            HistoryView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("History")
                }
            FamilyView()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Family")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
        .accentColor(.brandGreen)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthController())
        .environmentObject(FamilyController())
}
