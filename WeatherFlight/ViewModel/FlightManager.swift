//
//  FlightManager.swift
//  WeatherFlight
//
//  Created by Mauricio Alcantar on 19/05/25.
//

import SwiftUI

class FlightManager: ObservableObject {
    @Published var flights: [Flight] = []

    func add(name: String, to destination: Destination, items: [AgendaItem]) {
        let newFlight = Flight(name: name, destination: destination, agendaItems: items)
        flights.append(newFlight)
    }

    func remove(_ flight: Flight) {
        flights.removeAll { $0.id == flight.id }
    }
}
