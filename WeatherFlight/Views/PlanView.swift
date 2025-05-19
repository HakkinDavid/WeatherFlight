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
                // Sección de destino
                Section(header: Text("Destino")) {
                    Picker("Selecciona una ciudad", selection: $selectedDestination) {
                        ForEach(destinations) { destination in
                            Text(destination.name + ", " + destination.location).tag(Optional(destination))
                        }
                    }
                }

                // Sección de fecha
                Section(header: Text("Fecha del viaje")) {
                    DatePicker(
                        "Selecciona una fecha",
                        selection: $selectedDate,
                        in: Date()...Calendar.current.date(byAdding: .year, value: 1, to: Date())!,
                        displayedComponents: [.date]
                    )
                }

                // Sección del clima
                Section {
                    NavigationLink(
                        destination: WeatherView(
                            destination: selectedDestination ?? destinations[0],
                            date: selectedDate
                        )
                    ) {
                        Text("Checar clima")
                    }
                    .disabled(selectedDestination == nil)
                }

                // Sección de actividades
                Section(
                    header: Text("Actividades")
                        .foregroundColor(selectedDestination == nil ? .gray : .primary)
                ) {
                    activityListView
                }
            }
            .navigationTitle("Planificar viaje")
        }
    }
    
    // Extraer la lista de actividades a una propiedad computada
    private var activityListView: some View {
        List {
            ForEach(filteredActivities) { activity in
                ActivityRow(
                    activity: activity,
                    isSelected: isActivitySelected(activity),
                    onTap: { toggleActivity(activity) }
                )
            }
        }
    }
    
    // Filtrar actividades por destino seleccionado
    private var filteredActivities: [Activity] {
        guard let destination = selectedDestination else {
            return []
        }
        return activities.filter { $0.destination == destination.name }
    }
    
    // Verificar si una actividad está seleccionada
    private func isActivitySelected(_ activity: Activity) -> Bool {
        agendaManager.items.contains { item in
            item.activity.id == activity.id && item.date == selectedDate
        }
    }

    func toggleActivity(_ activity: Activity) {
        if let index = agendaManager.items.firstIndex(where: { $0.activity.id == activity.id && $0.date == selectedDate }) {
            agendaManager.remove(agendaManager.items[index])
        } else {
            agendaManager.add(activity: activity, on: selectedDate)
        }
    }
}

// Componente separado para la fila de actividad
struct ActivityRow: View {
    let activity: Activity
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(activity.name).font(.headline)
                Text(activity.description).font(.subheadline)
            }
            Spacer()
            Button(action: onTap) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "plus.circle")
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
    }
}
