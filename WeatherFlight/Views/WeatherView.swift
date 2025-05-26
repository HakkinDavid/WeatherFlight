//
//  WeatherData.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 17/05/25.
//

import SwiftUI
import CoreML

struct WeatherView: View {
    var destination: Destination
    var date: Date
    
    @State private var weather: WeatherData?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var dataSource: DataSource = .api
    
    // Servicio de predicción
    private let predictionService = WeatherPredictionService()
    
    var body: some View {
        ZStack {
            // Fondo basado en la temporada
            backgroundForSeason()
                .ignoresSafeArea()
            
            VStack {
                if isLoading {
                    ProgressView("Consultando clima...")
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                } else if let weatherData = weather {
                    VStack(spacing: 15) {
                        if weatherData.current.temperature_2m != -273.15 {
                            Text("Actualmente")
                                .font(.system(size: 50))
                                .position(x: 165, y: 60)
                            Text("\(weatherData.current.temperature_2m, specifier: "%.1f")°C")
                                .font(.system(size:28))
                                .frame(maxWidth: 200, minHeight: 50)
                                .background(Color.black.opacity(0.125))
                                .cornerRadius(150)
                                .position(x: 165, y: 40)
                        }
                        
                        Text("📍 \(destination.name), \(destination.location)")
                            .font(.headline)
                            .position(x: 165, y: 40)
                        
                        Text("📅 \(formattedDate(date))")
                            .font(.system(size: 26))
                            .position(x: 165, y: 45)
                        
                        HStack {
                            Spacer()
                            sourceLabel
                                .font(.caption)
                                .padding(6)
                                .background(Color.black.opacity(0.9))
                                .cornerRadius(5)
                        }
                        
                        VStack(spacing: 8) {
                            weatherRow(icon: "🌡️", title: "Temperatura", value: temperatureText(weatherData))
                            
                            weatherRow(icon: "🌧️", title: "Precipitación", value: precipitationText(weatherData))
                            
                            weatherRow(icon: "💨", title: "Viento", value: windText(weatherData))
                            
                            weatherRow(icon: "💧", title: "Humedad", value: humidityText(weatherData))
                            
                            if let season = weatherData.season {
                                weatherRow(icon: "🍂", title: "Temporada", value: Text(season.capitalized))
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.75))
                        .cornerRadius(20)
                    }
                    .padding()
                } else if let error = errorMessage {
                    Text("Error: \(error)")
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .onAppear(perform: fetchWeatherData)
        .navigationTitle("Clima estimado")
    }
    
    private var sourceLabel: some View {
        Text(dataSource == .api ? "Datos en tiempo real" : "Predicción ML")
            .foregroundColor(dataSource == .api ? .blue : .orange)
    }
    
    private func weatherRow(icon: String, title: String, value: Text) -> some View {
        HStack {
            Text(icon)
                .font(.title)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                value
                    .font(.body)
            }
            
            Spacer()
        }
    }
    
    private func backgroundForSeason() -> some View {
        let season = weather?.season?.lowercased() ?? "default"
        
        switch season {
        case "verano":
            return LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .top, endPoint: .bottom).eraseToAnyView()
        case "invierno":
            return LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.white]), startPoint: .top, endPoint: .bottom).eraseToAnyView()
        case "otoño":
            return LinearGradient(gradient: Gradient(colors: [Color.orange, Color.brown]), startPoint: .top, endPoint: .bottom).eraseToAnyView()
        case "primavera":
            return LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.6), Color.blue.opacity(0.3)]), startPoint: .top, endPoint: .bottom).eraseToAnyView()
        default:
            return Color.gray.opacity(0.3).eraseToAnyView()
        }
    }
    
    // Texto formateado para temperatura según la fuente de datos
    private func temperatureText(_ weatherData: WeatherData) -> Text {
        if dataSource == .api, !weatherData.daily.temperature_2m_max.isEmpty, !weatherData.daily.temperature_2m_min.isEmpty {
            return Text("Máx: \(weatherData.daily.temperature_2m_max[0], specifier: "%.1f")°C / Mín: \(weatherData.daily.temperature_2m_min[0], specifier: "%.1f")°C")
        } else if dataSource == .mlModel, !weatherData.daily.temperature_2m_max.isEmpty {
            return Text("Promedio: \(weatherData.daily.temperature_2m_max[0], specifier: "%.1f")°C")
        }
        return Text("No disponible")
    }
    
    // Texto formateado para precipitación
    private func precipitationText(_ weatherData: WeatherData) -> Text {
        if !weatherData.daily.precipitation_sum.isEmpty {
            return Text("\(weatherData.daily.precipitation_sum[0], specifier: "%.1f") mm")
        }
        return Text("No disponible")
    }
    
    // Texto formateado para viento
    private func windText(_ weatherData: WeatherData) -> Text {
        if !weatherData.daily.windspeed_10m_max.isEmpty {
            return Text("\(weatherData.daily.windspeed_10m_max[0], specifier: "%.1f") km/h")
        }
        return Text("No disponible")
    }
    
    // Texto formateado para humedad
    private func humidityText(_ weatherData: WeatherData) -> Text {
        if !weatherData.daily.relative_humidity_2m_mean.isEmpty {
            return Text("\(weatherData.daily.relative_humidity_2m_mean[0], specifier: "%.0f")%")
        }
        return Text("No disponible")
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    func fetchWeatherData() {
        isLoading = true
        
        dataSource = WeatherPredictionService.isDateWithinForecastRange(date) ? .api : .mlModel
        
        predictionService.fetchWeatherData(for: destination, date: date) { data, error in
            if let error = error {
                self.errorMessage = error
            } else {
                self.weather = data
            }
            self.isLoading = false
        }
    }
}

// Extensión para View para facilitar el cambio de tipos
extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
