//
//  PlanView.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 17/05/25.
//

import SwiftUI

struct PlanView: View {
    @EnvironmentObject var flightManager: FlightManager
    @State private var selectedDestination: Destination? = destinations.first
    @State private var selectedSeason: String? = "Verano"
    @State private var selectedDate = Date()
    @State private var selectedActivities: [Activity] = []
    @State private var showActivityPopup = false
    @State private var showSuccessAlert = false

    let activities = sampleActivities
    
    let textColor = Color(red: 1.0, green: 0.95, blue: 0.7) // Light Yellow
    
    let beachGradient = LinearGradient(
        gradient: Gradient(colors: [ Color(red: 0.1, green: 0.5, blue: 0.8), Color(red: 0.2, green: 0.7, blue: 0.9), Color(red: 0.4, green: 0.65, blue: 0.85), Color(red: 0.8, green: 0.9, blue: 0.55), Color(red: 0.9, green: 0.8, blue: 0.4)]), startPoint: .top, endPoint: .bottom)
    

    var body: some View {
        NavigationView {
            ZStack {
                
                beachGradient
                    .edgesIgnoringSafeArea(.all)
                
                Form {
                    // Destiny awaits
                    Section(header: Text("Destino").foregroundColor(textColor).bold()) {
                        Picker("Selecciona una ciudad", selection: $selectedDestination) {
                            ForEach(destinations) { destination in
                                Text(destination.name + ", " + destination.location)
                                    .tag(Optional(destination))
                                    .foregroundColor(.white)
                            }
                        }
                        .colorScheme(.dark) // Para mejor visibilidad del picker
                    }
                    .listRowBackground(Color.white.opacity(0.3))
                    
                    // Sección de fecha
                    Section(header: Text("Temporada de viaje").foregroundColor(textColor).bold()) {
                        Picker("Selecciona una temporada", selection: $selectedSeason) {
                            Text("Verano").tag(Optional("Verano"))
                            Text("Invierno").tag(Optional("Invierno"))
                        }
                        .colorScheme(.dark)
                    }
                    .listRowBackground(Color.white.opacity(0.3))
                    
                    
                    // Weather check
                    Section {
                        NavigationLink(
                            destination: WeatherView(
                                destination: selectedDestination ?? destinations[0],
                                date: selectedDate
                            )
                        ) {
                            Text("Checar clima")
                                .foregroundColor(textColor)
                                .bold()
                        }
                        .disabled(selectedDestination == nil)
                    }
                    .listRowBackground(Color.blue.opacity(0.4))
                    
                    // Activity list
                    // Does not show if there are no activities
                    if !filteredActivities.isEmpty {
                        Section(
                            header: Text("Actividades").foregroundColor(textColor).bold()
                                .font(.title2)
                        ) {
                            activityListView.frame(minHeight: 150)
                        }
                        .disabled(selectedDestination == nil)
                        .listRowBackground(Color.blue.opacity(0.4))
                        .sheet(isPresented: $showActivityPopup) {}
                        .alert("Actividad añadida para \(formattedDate(selectedDate))", isPresented: $showSuccessAlert) {
                            Button("Cerrar", role: .cancel) {}
                        }
                    }
                    
                }
                .scrollContentBackground(.hidden) // No Form Background
                .background(Color.clear)
            }
            .navigationTitle("Planificar viaje")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.blue.opacity(0.5), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    // Extraer la lista de actividades a una propiedad computada
    private var activityListView: some View {
        List {
            ForEach(filteredActivities) { activity in
                ActivityRow(
                    activity: activity,
                    onTap: { toggleSheet() }
                )
                .listRowBackground(Color.blue.opacity(0.2))
            }
        }
        .frame(minHeight: 300)
        .listStyle(.plain)
        .background(Color.clear)
    }
    
    private var calendarSheet: some View {
        VStack {
            Text("Selecciona una fecha")
            
            
            
            Button("Aceptar") {
                showSuccessAlert = true
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
    
    // Filtrar actividades por destino seleccionado
    private var filteredActivities: [Activity] {
        guard let destination = selectedDestination else {
            return []
        }
        return activities.filter { $0.destination == destination.name }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale.autoupdatingCurrent
        return formatter.string(from: date)
    }
    
    func toggleSheet() {
        showActivityPopup = true
    }
}

// Componente separado para la fila de actividad
struct ActivityRow: View {
    let activity: Activity
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(activity.name).font(.headline)
                Text(activity.description).font(.subheadline)
            }
            Spacer()
            Button(action: onTap) {
                Image(systemName: "plus.circle")
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
    }
}

/*struct CalendarLogic: View {
    let activity: Activity
    
    var body: some View {
        VStack {
            Section(header: Text("Fecha del viaje").foregroundColor(textColor).bold()) {
                DatePicker(
                    "Selecciona una fecha",
                    selection: $selectedDate,
                    in: Date()...Calendar.current.date(byAdding: .year, value: 1, to: Date())!,
                    displayedComponents: [.date]
                )
                .colorScheme(.dark)
            }
            .listRowBackground(Color.blue.opacity(0.3))
        }
    }
}*/
