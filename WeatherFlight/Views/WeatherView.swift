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
    
    enum DataSource {
        case api
        case mlModel
    }
    
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
                                .background(Color.black.opacity(0.1))
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
    
    func isDateWithinForecastRange(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let futureDate = calendar.date(byAdding: .day, value: 15, to: today)!
        
        let targetDate = calendar.startOfDay(for: date)
        return targetDate >= today && targetDate <= futureDate
    }

    func fetchWeatherData() {
        isLoading = true
        
        // Determinar la fuente de datos basada en la fecha
        if isDateWithinForecastRange(date) {
            dataSource = .api
            fetchWeatherFromApi()
        } else {
            dataSource = .mlModel
            fetchWeatherFromModel()
        }
    }
    
    func fetchWeatherFromApi() {
        let lat = destination.latitude
        let lon = destination.longitude
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = formatter.string(from: date)
        
        let urlStr = """
        https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&start_date=\(formattedDate)&end_date=\(formattedDate)&daily=temperature_2m_max,temperature_2m_min,precipitation_sum,windspeed_10m_max,relative_humidity_2m_mean&current=temperature_2m&timezone=auto
        """
        
        guard let url = URL(string: urlStr) else {
            self.errorMessage = "URL inválida"
            self.isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No se recibieron datos"
                    return
                }

                do {
                    var result = try JSONDecoder().decode(WeatherData.self, from: data)
                    
                    // Determinar la temporada basada en la fecha
                    result.season = determineSeason(from: date)
                    self.weather = result
                } catch {
                    print("Error de decodificación: \(error)")
                    self.errorMessage = "Error al decodificar datos: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    func fetchWeatherFromModel() {
        // Usar el modelo de CoreML para predicción
        if let prediction = predictionService.predict(for: destination.name, date: date) {
            // Crear un objeto WeatherData a partir de la predicción del modelo
            let daily = WeatherData.Daily(
                temperature_2m_max: [prediction.temperature], // Usar el valor único como máximo
                temperature_2m_min: [], // No hay mínimo en el modelo
                precipitation_sum: [prediction.precipitation],
                windspeed_10m_max: [prediction.wind],
                relative_humidity_2m_mean: [prediction.humidity],
                time: [formattedDateString(date)]
            )
            
            let current = WeatherData.Current(temperature_2m: -273.15)
            
            let weatherData = WeatherData(
                daily: daily,
                current: current,
                season: determineSeason(from: date)
            )
            
            self.weather = weatherData
            self.isLoading = false
        } else {
            self.errorMessage = "No se pudo generar la predicción del clima"
            self.isLoading = false
        }
    }
    
    func formattedDateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func determineSeason(from date: Date) -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        
        switch month {
        case 12, 1, 2:
            return "invierno"
        case 3, 4, 5:
            return "primavera"
        case 6, 7, 8:
            return "verano"
        case 9, 10, 11:
            return "otoño"
        default:
            return "desconocida"
        }
    }
}

// Extensión para View para facilitar el cambio de tipos
extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
