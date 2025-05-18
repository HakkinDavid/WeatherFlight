//
//  WeatherData.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 17/05/25.
//


import SwiftUI

struct WeatherData: Decodable {
    struct Daily: Decodable {
        let temperature_2m_max: [Double]
        let temperature_2m_min: [Double]
        let precipitation_sum: [Double]
        let windspeed_10m_max: [Double]
        let relative_humidity_2m_mean: [Double]
        let time: [String]
    }
    let daily: Daily
}

struct WeatherView: View {
    var destination: Destination
    var date: Date
    
    @State private var weather: WeatherData?
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Consultando clima...")
            } else if let weatherData = weather {
                List {
                    Text("📍 \(destination.name), \(destination.location)")
                    Text("📅 \(formattedDate(date))")
                    
                    if !weatherData.daily.temperature_2m_max.isEmpty {
                        Text("🌡️ Máx: \(weatherData.daily.temperature_2m_max[0], specifier: "%.1f")°C")
                    }
                    
                    if !weatherData.daily.temperature_2m_min.isEmpty {
                        Text("🌡️ Mín: \(weatherData.daily.temperature_2m_min[0], specifier: "%.1f")°C")
                    }
                    
                    if !weatherData.daily.precipitation_sum.isEmpty {
                        Text("🌧️ Lluvia: \(weatherData.daily.precipitation_sum[0], specifier: "%.1f") mm")
                    }
                    
                    if !weatherData.daily.windspeed_10m_max.isEmpty {
                        Text("💨 Viento: \(weatherData.daily.windspeed_10m_max[0], specifier: "%.1f") km/h")
                    }
                    
                    if !weatherData.daily.relative_humidity_2m_mean.isEmpty {
                        Text("💧 Humedad: \(weatherData.daily.relative_humidity_2m_mean[0], specifier: "%.0f")%")
                    }
                }
            } else if let error = errorMessage {
                Text("Error: \(error)")
            }
        }
        .onAppear(perform: fetchWeather)
        .navigationTitle("Clima estimado")
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }

    func fetchWeather() {
        isLoading = true
        let lat = destination.latitude
        let lon = destination.longitude
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = formatter.string(from: date)
        
        let urlStr = """
        https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&start_date=\(formattedDate)&end_date=\(formattedDate)&daily=temperature_2m_max,temperature_2m_min,precipitation_sum,windspeed_10m_max,relative_humidity_2m_mean&timezone=auto
        """
        
        guard let url = URL(string: urlStr) else {
            self.errorMessage = "URL inválida"
            self.isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                // Para depuración - imprimir la respuesta HTTP
                if let httpResponse = response as? HTTPURLResponse {
                    print("Código de estado HTTP: \(httpResponse.statusCode)")
                }
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No se recibieron datos"
                    return
                }
                
                // Para depuración - imprimir los datos JSON recibidos
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Datos JSON recibidos: \(jsonString)")
                }

                do {
                    let result = try JSONDecoder().decode(WeatherData.self, from: data)
                    self.weather = result
                } catch {
                    print("Error de decodificación: \(error)")
                    self.errorMessage = "Error al decodificar datos: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
