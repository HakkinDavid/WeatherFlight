//
//  DateRangeModel.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 19/05/25.
//

import SwiftUI

struct DateRange: Identifiable, Hashable, Codable, Comparable {
    
    let id: UUID
    let startDate: Date
    let endDate: Date
    
    init(startDate: Date, endDate: Date) {
        self.id = UUID()
        self.startDate = startDate
        self.endDate = endDate
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
    
    static func < (lhs: DateRange, rhs: DateRange) -> Bool {
        return lhs.startDate < rhs.startDate
    }
}
