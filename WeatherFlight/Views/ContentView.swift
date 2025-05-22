import SwiftUI
import CoreLocation

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var flightManager: FlightManager
    @Environment(\.colorScheme) var colorScheme
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    var currentLatLong = CLLocationManager().location?.coordinate


    var body: some View {
        TabView {
            PlanView()
                .tabItem {
                    Label("Planear", systemImage: "map")
                }

            WeatherView(destination: Destination(name: "Ubicación actual", location: "México", latitude: currentLatLong?.latitude ?? 32.5027, longitude: currentLatLong?.longitude ?? -117.00371), date: Date())
                .tabItem {
                    Label("Clima", systemImage: "cloud.sun")
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
        .accentColor(colorScheme == .dark ? .white : .black)
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
