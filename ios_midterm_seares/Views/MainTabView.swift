import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ListView()
                .tabItem {
                    Image(systemName: "list.clipboard")
                    Text("List")
                }
            Text("History")
                .tabItem {
                    Image(systemName: "clock")
                    Text("History")
                }
            Text("Family")
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
}
