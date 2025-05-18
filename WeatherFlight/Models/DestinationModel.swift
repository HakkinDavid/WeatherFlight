//
//  Destination.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 17/05/25.
//
import SwiftUI

struct Destination: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let location: String
    let latitude: Double
    let longitude: Double
    
    init(id: UUID = UUID(), name: String, location: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
    }
}

let destinations: [Destination] = [
    Destination(name: "Salsipuedes", location: "B.C., México", latitude: 28.72611, longitude: -112.95527),
    Destination(name: "Válgame Dios", location: "Sinaloa, México", latitude: 25.54621, longitude: -107.38681),
    Destination(name: "Xbox", location: "Yucatán, México", latitude: 20.20388, longitude: -107.38681),
    Destination(name: "Naco", location: "Sonora, México", latitude: 31.33166, longitude: -109.94805),
    Destination(name: "Berga", location: "Cataluña, España", latitude: 42.10000, longitude: 1.84555)
]
