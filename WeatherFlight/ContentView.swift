import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>


    var body: some View {
        TabView {
            SearchView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            SearchView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Category")
                }
            SearchView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Add")
                }
        }
        .accentColor(.purple)
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
