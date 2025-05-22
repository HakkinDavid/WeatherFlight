//
//  FlightModel.swift
//  WeatherFlight
//
//  Created by Mauricio Alcantar on 19/05/25.
//
import SwiftUI

struct Flight: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let destination: Destination
    let agendaItems: [AgendaItem]
    
    init(id: UUID = UUID(), name: String, destination: Destination, agendaItems: [AgendaItem]) {
        self.id = id
        self.name = name
        self.destination = destination
        self.agendaItems = agendaItems
    }
}
