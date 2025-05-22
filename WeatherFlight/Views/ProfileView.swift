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
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                
                (colorScheme == .dark ? Color(red: 0.05, green: 0.1, blue: 0.2) : Color(red: 0.96, green: 0.94, blue: 0.89))
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // PROFILE
                        VStack(spacing: 16) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .foregroundColor(colorScheme == .dark ? .blue : .brown)
                                .padding(.top, 40)
                            
                            Text("Usuario anónimo")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            
                            Divider()
                                .frame(width: 200)
                                .background(colorScheme == .dark ? Color.blue.opacity(0.5) : Color.brown.opacity(0.5))
                        }
                        .padding(.bottom, 30)
                        
                        // PROFILE BUTTONS
                        VStack(spacing: 16) {
                            ProfileButton(
                                icon: "calendar",
                                text: "Exportar Agenda a Calendario",
                                color: colorScheme == .dark ? .blue : .brown
                            ) {
                                showingExport = true
                            }
                            
                            ProfileButton(
                                icon: "info.circle",
                                text: "Acerca de WeatherFlight",
                                color: colorScheme == .dark ? .blue : .brown
                            ) {
                                showingAbout = true
                            }
                        }
                        .padding(.horizontal, 30)
                        
                        // SIGN OUT
                        Button(action: {
                        }) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Cerrar sesión")
                            }
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(colorScheme == .dark ? Color.red.opacity(0.1) : Color.red.opacity(0.05))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 10)
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Perfil")
            .navigationBarTitleDisplayMode(.inline)
            
            .sheet(isPresented: $showingExport) {
                // TODO: Puede navegar a una vista con resumen de exportación
            }
            
            // ABOUT BUTTON
            .alert("WeatherFlight", isPresented: $showingAbout) {
                Button("Cerrar", role: .cancel) {}
            } message: {
                Text("PLACEHOLDER TEXT")
            }
        }
    }
}

// Adding profile buttons
struct ProfileButton: View {
    let icon: String
    let text: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 24)
                Text(text)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground).opacity(0.7))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}
