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
    
    // Paleta de colores
    private let backgroundColor = Color(red: 0.98, green: 0.96, blue: 0.92)
    private let cardColor = Color(red: 0.95, green: 0.92, blue: 0.85)
    private let accentColor = Color(red: 0.8, green: 0.7, blue: 0.6)
    private let textColor = Color(red: 0.3, green: 0.25, blue: 0.2)
    private let shadowColor = Color(red: 0.7, green: 0.65, blue: 0.6).opacity(0.3)
    
    @State private var selectedFlight = 0
    
    var groupedItems: [String: [AgendaItem]] {
        if flightManager.flights.isEmpty || flightManager.flights[selectedFlight].agendaItems.isEmpty {
            return [:]
        }
        return Dictionary(grouping: flightManager.flights[selectedFlight].agendaItems) { $0.activity.destination }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                    backgroundColor
                        .edgesIgnoringSafeArea(.all)
                Image(systemName: "leaf.fill")
                    .foregroundColor(accentColor.opacity(0.05))
                    .font(.system(size: 100))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .offset(x: 30, y: 30)
                VStack {
                    if !flightManager.flights.isEmpty {
                        Picker("Selecciona un viaje", selection: $selectedFlight) {
                            ForEach(Array(0..<flightManager.flights.count), id: \.self) { flightIdx in
                                let flightName = flightManager.flights[flightIdx].name
                                Text(flightName)
                                    .foregroundColor(.white)
                            }
                        }
                        .colorScheme(.dark)
                        .disabled(flightManager.flights.isEmpty)
                        .previewDisplayName(flightManager.flights.isEmpty ? "No hay vuelos agendados" : "")
                        .listRowBackground(Color.gray.opacity(0.3))
                    }
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            if groupedItems.isEmpty {
                                emptyStateView
                            } else {
                                ForEach(groupedItems.keys.sorted(), id: \.self) { city in
                                    citySection(city: city)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 30)
                    }
                }
            }
            .navigationTitle("Bitácora de Viaje")
            .toolbar {
                if !flightManager.flights.isEmpty {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {deleteItem(at: $selectedFlight.wrappedValue)}) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Eliminar")
                            }
                            .font(.subheadline)
                            .padding(8)
                            .background($selectedFlight.wrappedValue >= flightManager.flights.count ? .gray : .red.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .disabled($selectedFlight.wrappedValue >= flightManager.flights.count)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: exportToCalendar) {
                            HStack {
                                Image(systemName: "calendar.badge.plus")
                                Text("Exportar")
                            }
                            .font(.subheadline)
                            .padding(8)
                            .background($selectedFlight.wrappedValue >= flightManager.flights.count ? .gray : accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .disabled($selectedFlight.wrappedValue >= flightManager.flights.count)
                    }
                }
            }
            .alert("Exportado a Calendario", isPresented: $showingExportAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Image(systemName: "book.closed.fill")
                .font(.system(size: 50))
                .foregroundColor(accentColor)
                .padding(.bottom, 20)
            
            Text("Tu bitácora está vacía")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(textColor)
            
            Text("Agrega viajes para comenzar a llenar tu bitácora")
                .font(.subheadline)
                .foregroundColor(textColor.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.top, 5)
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .background(cardColor)
        .cornerRadius(15)
        .shadow(color: shadowColor, radius: 10, x: 0, y: 5)
    }
    
    private func citySection(city: String) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(accentColor)
                Text(city)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(textColor)
            }
            .padding(.horizontal, 15)
            .padding(.top, 15)
            
            ForEach(groupedItems[city]!.sorted(by: { $0.date < $1.date })) { item in
                activityCard(item: item)
            }
        }
        .background(cardColor)
        .cornerRadius(15)
        .shadow(color: shadowColor, radius: 5, x: 0, y: 3)
    }
    
    private func activityCard(item: AgendaItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(accentColor)
                    .frame(width: 10, height: 10)
                
                Text(item.activity.name)
                    .font(.headline)
                    .foregroundColor(textColor)
                    .padding(.leading, 5)
            }
            
            Text(item.activity.description)
                .font(.subheadline)
                .foregroundColor(textColor.opacity(0.8))
                .padding(.leading, 15)
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(accentColor)
                Text(formattedDate(item.date.startDate))
                    .font(.caption)
                    .foregroundColor(textColor.opacity(0.7))
            }
            .padding(.leading, 15)
            .padding(.top, 5)
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.3))
        .cornerRadius(10)
        .padding(.horizontal, 15)
        .padding(.bottom, 15)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: date)
    }
    
    func deleteItem(at index: Int) {
        $selectedFlight.wrappedValue = 0
        flightManager.remove(at: index)
    }
    
    func exportToCalendar() {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { granted, error in
            guard granted, error == nil else {
                return
            }
            
            let selected = selectedFlight
            guard selected < flightManager.flights.count else { return }
            
            let flight = flightManager.flights[selected]
            let calendar = eventStore.defaultCalendarForNewEvents
            
            for item in flight.agendaItems {
                let event = EKEvent(eventStore: eventStore)
                event.title = item.activity.name
                event.notes = """
                \(item.activity.description)
                
                Categoría: \(item.activity.category)
                Recomendado para: \(item.activity.recommendedFor.joined(separator: ", "))
                """
                event.startDate = item.date.startDate
                event.endDate = item.date.endDate
                event.calendar = calendar
                event.location = flight.destination.location
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch {
                    print("Error al guardar el evento: \(error.localizedDescription)")
                }
            }
            
            DispatchQueue.main.async {
                showingExportAlert = true
            }
        }
    }
}
