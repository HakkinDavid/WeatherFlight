//
//  AgendaManager.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 17/05/25.
//
import SwiftUI

class AgendaManager: ObservableObject {
    @Published var items: [AgendaItem] = []

    func add(activity: Activity, on date: DateRange) {
        let newItem = AgendaItem(activity: activity, date: date)
        items.append(newItem)
    }

    func remove(_ item: AgendaItem) {
        items.removeAll { $0.id == item.id }
    }
}
