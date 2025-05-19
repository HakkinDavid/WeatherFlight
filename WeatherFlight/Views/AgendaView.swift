//
//  AgendaView.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 14/05/25.
//

import SwiftUI
import EventKit

struct AgendaView: View {
    @EnvironmentObject var agendaManager: AgendaManager
    @State private var showingExportAlert = false

    var groupedItems: [String: [AgendaItem]] {
        Dictionary(grouping: agendaManager.items) { $0.activity.destination }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(groupedItems.keys.sorted(), id: \.self) { city in
                    Section(header: Text(city)) {
                        ForEach(groupedItems[city]!.sorted(by: { $0.date < $1.date })) { item in
                            VStack(alignment: .leading) {
                                Text(item.activity.name).font(.headline)
                                Text(item.activity.description).font(.subheadline)
                                Text("📅 \(formattedDate(item.date))").font(.caption)
                            }
                        }
                    }
                }
            }
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

            for item in agendaManager.items {
                let event = EKEvent(eventStore: eventStore)
                event.title = item.activity.name
                event.startDate = item.date
                event.endDate = Calendar.current.date(byAdding: .hour, value: 1, to: item.date)
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
