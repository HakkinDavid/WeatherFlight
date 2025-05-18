//
//  AgendaManager.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 17/05/25.
//
import SwiftUI

class AgendaManager: ObservableObject {
    @Published var items: [AgendaItem] = []

    func add(activity: Activity, on date: Date, at destination: Destination) {
        let newItem = AgendaItem(id: UUID(), activity: activity, date: date, destination: destination)
        items.append(newItem)
    }

    func remove(_ item: AgendaItem) {
        items.removeAll { $0.id == item.id }
    }
}
