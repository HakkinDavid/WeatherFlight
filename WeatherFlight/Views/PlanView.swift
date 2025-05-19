//
//  PlanView.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 17/05/25.
//


import SwiftUI

struct PlanView: View {
    @EnvironmentObject var agendaManager: AgendaManager
    @State private var selectedDestination: Destination? = destinations.first
    @State private var selectedDate = Date()
    @State private var selectedActivities: [Activity] = []
    @State private var navigate = false

    let activities = sampleActivities

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Destino")) {
                    Picker("Selecciona una ciudad", selection: $selectedDestination) {
                        ForEach(destinations) { destination in
                            Text(destination.name + ", " + destination.location).tag(Optional(destination))
                        }
                    }
                }

                Section(header: Text("Fecha del viaje")) {
                    DatePicker("Selecciona una fecha", selection: $selectedDate, in: Date()...Calendar.current.date(byAdding: .year, value: 1, to: Date())!, displayedComponents: [.date])
                }

                Section {
                    NavigationLink(destination: WeatherView(destination: selectedDestination ?? destinations[0], date: selectedDate)) {
                            Text("Checar clima")
                    }
                    .disabled(selectedDestination == nil)
                }

                Section(header: Text("Actividades").foregroundColor(selectedDestination == nil ? .gray : .primary)) {
                    List {
                        ForEach(activities) { activity in
                            HStack {
                                if selectedDestination?.name == activity.destination {
                                    VStack(alignment: .leading) {
                                        Text(activity.name).font(.headline)
                                        Text(activity.description).font(.subheadline)
                                    }
                                    Spacer()
                                    Button(action: {
                                        toggleActivity(activity)
                                    }) {
                                        Image(systemName: agendaManager.items.contains(AgendaItem(activity: activity, date: selectedDate)) ? "checkmark.circle.fill" : "plus.circle")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Planificar viaje")
        }
    }

    func toggleActivity(_ activity: Activity) {
        if let index = agendaManager.items.firstIndex(where: { $0 == AgendaItem(activity: activity, date: selectedDate) }) {
            agendaManager.remove(agendaManager.items[index])
        } else {
            agendaManager.add(activity: activity, on: selectedDate)
        }
    }
}
