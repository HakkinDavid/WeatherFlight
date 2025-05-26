//
//  WeatherFlightApp.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 12/05/25.
//

import SwiftUI

@main
struct WeatherFlightApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            PermissionsView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(FlightManager(context: persistenceController.container.viewContext))
        }
    }
}
