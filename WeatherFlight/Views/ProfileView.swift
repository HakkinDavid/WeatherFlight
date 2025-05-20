//
//  ProfileView.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 17/05/25.
//
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var flightManager: FlightManager
    @State private var showingExport = false
    @State private var showingAbout = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Cuenta")) {
                    Label("Usuario anónimo", systemImage: "person.crop.circle")
                }

                Section(header: Text("Opciones")) {
                    Button("Exportar Agenda a Calendario") {
                        showingExport = true
                    }
                    Button("Acerca de WeatherFlight") {
                        showingAbout = true
                    }
                }

                Section {
                    Button("Cerrar sesión", role: .destructive) {
                        // TODO: Lógica futura si hay login real
                    }
                }
            }
            .navigationTitle("Perfil")
            .sheet(isPresented: $showingExport) {
                // TODO: Puede navegar a una vista con resumen de exportación
            }
            .alert("WeatherFlight", isPresented: $showingAbout) {
                Button("Cerrar", role: .cancel) {}
            }
        }
    }
}
