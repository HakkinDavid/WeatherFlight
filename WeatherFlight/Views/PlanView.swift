//
//  PlanView.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 17/05/25.
//

import SwiftUI

struct PlanView: View {
    @EnvironmentObject var flightManager: FlightManager
    @State private var weatherAdjective: String? = nil
    private let weatherService = WeatherPredictionService()
    @State private var selectedDestination: Destination? = destinations.first
    @State private var selectedActivities: [Activity] = []
    @State private var agendaItems: [AgendaItem] = []
    @State private var showAddAlert = false
    @State private var showRemoveAlert = false
    @State private var showSaveAlert = false
    @State private var tripName: String = ""
    @State private var date: Date = Calendar.current.startOfDay(for: Date())
    @State private var selectedDate: Date = Calendar.current.startOfDay(for: Date())

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
                                    .tag(destination)
                            }
                        }
                    }
                    .listRowBackground(Color.white.opacity(0.3))
                    
                    // Date select
                    Section(header: Text("Fecha del viaje").foregroundColor(textColor).bold()) {
                        DatePicker(
                            "Selecciona una fecha",
                            selection: $selectedDate,
                            in: date...Calendar.current.date(byAdding: .year, value: 1, to: date)!,
                            displayedComponents: [.date]
                        )
                        .colorScheme(.dark)
                    }
                    .listRowBackground(Color.white.opacity(0.3))
                    
                    // Weather check
                    Section(header: Text("Clima: \(weatherAdjective ?? "Cargando...")").foregroundColor(textColor).bold()) {
                        NavigationLink(
                            destination: WeatherView(
                                destination: selectedDestination ?? destinations[0],
                                date: selectedDate
                            )
                        ) {
                            Text("Revisar clima para la fecha seleccionada")
                                .foregroundColor(textColor)
                                .bold()
                        }
                        .disabled(selectedDestination == nil)
                    }
                    .listRowBackground(Color.white.opacity(0.3))
                    
                    // Activity list
                    // Does not show if there are no activities
                    if !filteredActivities.isEmpty {
                        Section(
                            header: Text("Actividades").foregroundColor(textColor).bold()
                                .font(.title2)
                        ) {
                            activityListView
                        }
                        .disabled(selectedDestination == nil)
                        .listRowBackground(Color.white.opacity(0.5))
                        /*
                        .alert("Actividad añadida al plan para \(formattedDate(selectedDate))", isPresented: $showAddAlert) {
                            Button("Cerrar", role: .cancel) {}
                        }
                         */
                    }
                    
                    if !agendaItems.isEmpty {
                        Section (header: Text("Plan actual").foregroundColor(textColor).bold().font(.title2)) {
                            agendaItemsListView
                        }
                        .listRowBackground(Color.white.opacity(0.5))
                        Section(header: Text("Guardar viaje").foregroundColor(textColor).bold().font(.title2)) {
                            VStack {
                                TextField("Nombre del viaje", text: $tripName) {}
                                Button("Guardar", action: {
                                    saveFlight()
                                })
                                .disabled(tripName.isEmpty)
                                .font(.subheadline)
                                .padding(8)
                                .background(.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .alert("Viaje guardado", isPresented: $showSaveAlert) {
                                    Button("Aceptar", role: .cancel, action: { resetPlan() })
                                }
                            }
                        }
                        .listRowBackground(Color.white.opacity(0.5))
                    }
                    
                }
                .scrollContentBackground(.hidden) // No Form Background
                .background(Color.clear)
            }
            .navigationTitle("Planificar viaje")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.purple.opacity(0.1), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onChange(of: selectedDate) { _ in
            updateWeatherAdjective()
        }
        .onChange(of: selectedDestination) { _ in
            updateWeatherAdjective()
        }
        .onAppear {
            updateWeatherAdjective()
        }
        .alert("Actividad removida del plan", isPresented: $showRemoveAlert) {
            Button("Cerrar", role: .cancel) {}
        }
    }
    
    // Extraer la lista de actividades a una propiedad computada
    private var activityListView: some View {
        List {
            ForEach(filteredActivities) { activity in
                ActivityRow(
                    activity: activity,
                    isRecommended: (weatherAdjective != nil) ? activity.recommendedFor.contains(weatherAdjective!) : false,
                    isSelected: isActivitySelected(activity),
                    onTap: { toggleActivity(activity) }
                )
                .listRowBackground(Color.clear.opacity(0.2))
            }
        }
        .frame(minHeight: 300)
        .listStyle(.plain)
        .background(Color.clear)
    }
    
    private var agendaItemsListView: some View {
        List {
            ForEach(agendaItems.sorted(by: {$0.date < $1.date}), id: \.id) { agendaItem in
                AgendaItemRow(
                    agendaItem: agendaItem,
                    onTap: {
                        agendaItems.removeAll(where: {$0.id == agendaItem.id})
                        showRemoveAlert = true
                    }
                )
                .listRowBackground(Color.clear.opacity(0.2))
            }
        }
        .frame(minHeight: 300)
        .listStyle(.plain)
        .background(Color.clear)
    }
    
    // Filtrar actividades por destino seleccionado y aplicar recomendación según clima
    private var filteredActivities: [Activity] {
        guard let destination = selectedDestination else {
            return []
        }

        return activities
            .filter { $0.destination == destination.name }
    }
    
    // Verificar si una actividad está seleccionada
    private func isActivitySelected(_ activity: Activity) -> Bool {
        agendaItems.contains(where: { $0.activity.name == activity.name && ($0.date.startDate == selectedDate || $0.date.endDate == selectedDate) })
    }
    
    func toggleActivity(_ activity: Activity) {
        if isActivitySelected(activity){
            agendaItems.removeAll(where: { $0.activity.name == activity.name && $0.date.startDate == selectedDate })
            showRemoveAlert = true
        } else {
            agendaItems.append(AgendaItem(activity: activity, date: DateRange(startDate: selectedDate, endDate: selectedDate)))
            showAddAlert = true
        }
    }
    
    func saveFlight() {
        flightManager.add(name: tripName.isEmpty ? "Viaje a \(selectedDestination?.name ?? "") - \(formattedDate(selectedDate))" : tripName, to: selectedDestination!, items: agendaItems)
        showSaveAlert = true
    }
    
    func resetPlan() {
        agendaItems.removeAll(keepingCapacity: false)
        selectedDestination = destinations.first
        date = Calendar.current.startOfDay(for: Date())
        selectedDate = date
        selectedActivities.removeAll(keepingCapacity: false)
        tripName = ""
        weatherAdjective = ""
    }
    
    private func updateWeatherAdjective() {
        guard let destination = selectedDestination else {
            weatherAdjective = nil
            return
        }

        weatherService.fetchWeatherData(for: destination, date: selectedDate) { data, adjective, error in
            if let adjective {
                weatherAdjective = adjective
            } else {
                weatherAdjective = nil
                print("Error al obtener el adjetivo del clima: \(error ?? "No hay error especificado")")
            }
        }
    }
}

// Componente separado para la fila de actividad
struct ActivityRow: View {
    let activity: Activity
    let isRecommended: Bool
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(activity.name).font(.headline)
                Text(activity.description).font(.subheadline)
                if isRecommended {
                    Text("Recomendada")
                        .font(.caption)
                        .foregroundColor(.green)
                        .padding(4)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(6)
                }
                else {
                    Text("No recomendada")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(4)
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(6)
                }
            }
            Spacer()
            Button(action: onTap) {
                Image(systemName: isSelected ? "checkmark.circle.fill" :  "plus.circle")
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 2)
    }
}

struct AgendaItemRow: View {
    let agendaItem: AgendaItem
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(agendaItem.activity.name).font(.headline)
                Text(formattedDate(agendaItem.date.startDate)).font(.subheadline)
            }
            Spacer()
            Button(action: onTap) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 2)
    }
}

func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.locale = Locale.autoupdatingCurrent
    return formatter.string(from: date)
}
