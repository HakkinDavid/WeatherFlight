//
//  DateRangeModel.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 19/05/25.
//

import SwiftUI

struct DateRange: Identifiable {
    let id: UUID
    let startDate: Date
    let endDate: Date
    let associate_id: UUID?
    
    init(startDate: Date, endDate: Date, associate_id: UUID? = nil) {
        self.id = UUID()
        self.startDate = startDate
        self.endDate = endDate
        self.associate_id = associate_id
    }
    
    func get_associate_id() -> UUID? {
        return self.associate_id
    }
    
    func get_start_date() -> Date {
        return self.startDate
    }
    
    func get_end_date() -> Date {
        return self.endDate
    }
    
    func get_duration() -> TimeInterval {
        return self.endDate.timeIntervalSince(self.startDate)
    }
}
