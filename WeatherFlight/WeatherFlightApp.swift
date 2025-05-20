//
//  WeatherFlightApp.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 12/05/25.
//

import SwiftUI

@main
struct WeatherFlightApp: App {
    @StateObject private var flightManager = FlightManager()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            PermissionsView().environmentObject(flightManager)
        }
    }
}
