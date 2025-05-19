//
//  Activity.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 17/05/25.
//
import SwiftUI

struct Activity: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let description: String
    let category: String
    let destination: String
    let recommendedFor: [String] // e.g., ["soleado", "nublado", "lluvia"]
    
    init(id: UUID = UUID(), name: String, description: String, category: String, destination: String, recommendedFor: [String] = []) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.destination = destination
        self.recommendedFor = recommendedFor
    }
}

let sampleActivities = [
    Activity(name: "Caminata por el malecón", description: "Explora la costa a pie.", category: "Al aire libre", destination: "Berga", recommendedFor: ["soleado", "nublado"]),
    Activity(name: "Museo local", description: "Arte e historia regional.", category: "Cultural", destination: "Berga", recommendedFor: ["lluvia", "nublado"]),
    Activity(name: "Tour gastronómico", description: "Degusta platos típicos.", category: "Gastronomía", destination: "Berga", recommendedFor: ["soleado", "lluvia"]),
]
