import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>


    var body: some View {
        TabView {
            PlanView()
                .tabItem {
                    Label("Planear", systemImage: "map")
                }

            WeatherView(destination: destinations[0], date: Date())
                .tabItem {
                    Label("Clima", systemImage: "cloud.sun")
                }

            ActivitiesView()
                .tabItem {
                    Label("Actividades", systemImage: "star")
                }

            AgendaView()
                .tabItem {
                    Label("Agenda", systemImage: "calendar")
                }

            ProfileView()
                .tabItem {
                    Label("Perfil", systemImage: "person.crop.circle")
                }
        }
        .accentColor(.black)
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
