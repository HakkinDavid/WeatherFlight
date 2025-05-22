//
//  AgendaView.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 14/05/25.
//

import SwiftUI
import EventKit

struct AgendaView: View {
    @EnvironmentObject var flightManager: FlightManager
    @State private var showingExportAlert = false

    var groupedItems: [String: [AgendaItem]] {
        if (flightManager.flights.isEmpty) {
            return [:]
        }
        return Dictionary(grouping: flightManager.flights[0].agendaItems) { $0.activity.destination }
    }

    var body: some View {
            
            NavigationView {
                AgendaListView(groupedItems: groupedItems, formattedDate: formattedDate)
                .navigationTitle("Agenda")
                .toolbar {
                    Button("Exportar 📆") {
                        exportToCalendar()
                    }
                }
                .alert("Exportado a Calendario", isPresented: $showingExportAlert) {
                    Button("OK", role: .cancel) { }
                }
            }
        }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }

    func exportToCalendar() {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { granted, _ in
            guard granted else { return }

            for item in flightManager.flights[0].agendaItems {
                let event = EKEvent(eventStore: eventStore)
                event.title = item.activity.name
                event.startDate = item.date.startDate
                event.endDate = item.date.startDate
                event.notes = "\(item.activity.description) en \(item.activity.destination)"
                event.calendar = eventStore.defaultCalendarForNewEvents

                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch {
                    print("Error al guardar evento: \(error)")
                }
            }

            DispatchQueue.main.async {
                showingExportAlert = true
            }
        }
    }
}

struct AgendaListView: View {
    let groupedItems: [String: [AgendaItem]]
    let formattedDate: (Date) -> String

    var body: some View {
        List {
            ForEach(groupedItems.keys.sorted(), id: \.self) { city in
                Section(header: Text(city)) {
                    ForEach(groupedItems[city]!.sorted(by: { $0.date < $1.date })) { item in
                        VStack(alignment: .leading) {
                            Text(item.activity.name).font(.headline)
                            Text(item.activity.description).font(.subheadline)
                            Text("📅 \(formattedDate(item.date.startDate))").font(.caption)
                        }
                    }
                }
            }
        }
    }
}
