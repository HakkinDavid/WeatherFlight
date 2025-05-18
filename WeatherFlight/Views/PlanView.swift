//
//  PlanView.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 17/05/25.
//


import SwiftUI

struct PlanView: View {
    @State private var selectedDestination: Destination? = nil
    @State private var selectedDate = Date()
    @State private var navigate = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Destino")) {
                    Picker("Selecciona una ciudad", selection: $selectedDestination) {
                        ForEach(destinations) { destination in
                            Text(destination.name).tag(Optional(destination))
                        }
                    }
                }

                Section(header: Text("Fecha del viaje")) {
                    DatePicker("Selecciona una fecha", selection: $selectedDate, in: Date()...Calendar.current.date(byAdding: .year, value: 1, to: Date())!, displayedComponents: [.date])
                }

                Section {
                    Button("Buscar clima y actividades") {
                        navigate = true
                    }
                    .disabled(selectedDestination == nil)
                }

                NavigationLink(destination: WeatherView(destination: selectedDestination ?? destinations[0], date: selectedDate), isActive: $navigate) {
                    EmptyView()
                }
                .hidden()
            }
            .navigationTitle("Planificar viaje")
        }
    }
}
