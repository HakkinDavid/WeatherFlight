//
//  AgendaItem.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 17/05/25.
//
import SwiftUI

struct AgendaItem: Identifiable, Codable, Hashable {
    let id: UUID
    let activity: Activity
    let date: DateRange
    
    init(activity: Activity, date: DateRange) {
        self.id = UUID()
        self.activity = activity
        self.date = date
    }
}
