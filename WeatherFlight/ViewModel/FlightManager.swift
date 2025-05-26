//
//  FlightManager.swift
//  WeatherFlight
//
//  Created by Mauricio Alcantar on 19/05/25.
//

import SwiftUI
import CoreData

class FlightManager: ObservableObject {
    @Published var flights: [Flight] = []

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        loadFlights()
    }

    func add(name: String, to destination: Destination, items: [AgendaItem]) {
        let newFlight = Flight(name: name, destination: destination, agendaItems: items)
        flights.append(newFlight)
        saveFlightToCoreData(newFlight)
    }

    func remove(at index: Int) {
        guard index < flights.count else { return }

        let flight = flights[index]

        if let entity = fetchFlightEntity(by: flight.id) {
            print("Entidad borrada con id: \(entity.id)")
            context.delete(entity)
            saveContext()
        } else {
            print("No se encontró la entidad en Core Data con id: \(flight.id)")
        }

        flights.remove(at: index)
    }

    private func loadFlights() {
        let request: NSFetchRequest<FlightEntity> = FlightEntity.fetchRequest()

        do {
            let results = try context.fetch(request)
            self.flights = results.compactMap { entity in
                let destination = destinations.first(where: { $0.name == entity.destination_name })
                let decodedItems = try? JSONDecoder().decode([AgendaItem].self, from: entity.agenda_items ?? Data())

                return Flight(id: entity.id!, name: entity.name ?? "", destination: destination ?? destinations[0], agendaItems: decodedItems ?? [])
            }
        } catch {
            print("Error loading flights: \(error)")
        }
    }

    private func saveFlightToCoreData(_ flight: Flight) {
        let entity = FlightEntity(context: context)
        entity.id = flight.id
        entity.name = flight.name
        entity.destination_name = flight.destination.name
        entity.agenda_items = (try? JSONEncoder().encode(flight.agendaItems)) ?? Data()
        
        print("Guardando FlightEntity con id: \(flight.id) en Core Data como \(entity.id)")

        saveContext()
    }

    private func fetchFlightEntity(by id: UUID) -> FlightEntity? {
        let request: NSFetchRequest<FlightEntity> = FlightEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try? context.fetch(request).first
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
