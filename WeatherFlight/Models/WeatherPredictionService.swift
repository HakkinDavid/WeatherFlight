//
//  WeatherPredictionService.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 17/05/25.
//

import CoreML
import Foundation

class WeatherPredictionService {
    private let temperature_model: TemperatureModel
    private let precipitation_model: PrecipitationModel
    private let humidity_model: HumidityModel
    private let wind_model: WindModel
    
    // Estructura para almacenar resultados de predicción
    struct WeatherPrediction {
        let temperature: Double
        let precipitation: Double
        let humidity: Double
        let wind: Double
    }

    init() {
        do {
            let config = MLModelConfiguration()
            self.temperature_model = try TemperatureModel(configuration: config)
            self.precipitation_model = try PrecipitationModel(configuration: config)
            self.humidity_model = try HumidityModel(configuration: config)
            self.wind_model = try WindModel(configuration: config)
        } catch {
            fatalError("No se pudieron cargar los modelos: \(error)")
        }
    }
    
    // Método principal de predicción
    func predictWeather(for city: String, date: Date) -> WeatherPrediction? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd"
        let dateString = formatter.string(from: date)
        
        // Predecir cada característica por separado
        guard let temperatureValue = predictTemperature(city: city, dateString: dateString),
              let precipitationValue = predictPrecipitation(city: city, dateString: dateString),
              let humidityValue = predictHumidity(city: city, dateString: dateString),
              let windValue = predictWind(city: city, dateString: dateString) else {
            return nil
        }
        
        return WeatherPrediction(
            temperature: temperatureValue,
            precipitation: precipitationValue,
            humidity: humidityValue,
            wind: windValue
        )
    }
    
    // Métodos individuales para cada predicción
    private func predictTemperature(city: String, dateString: String) -> Double? {
        do {
            let input = TemperatureModelInput(city: city, date: dateString)
            let output = try temperature_model.prediction(input: input)
            return output.temperature
        } catch {
            print("Error al predecir temperatura: \(error)")
            return nil
        }
    }
    
    private func predictPrecipitation(city: String, dateString: String) -> Double? {
        do {
            let input = PrecipitationModelInput(city: city, date: dateString)
            let output = try precipitation_model.prediction(input: input)
            return output.precipitation
        } catch {
            print("Error al predecir precipitación: \(error)")
            return nil
        }
    }
    
    private func predictHumidity(city: String, dateString: String) -> Double? {
        do {
            let input = HumidityModelInput(city: city, date: dateString)
            let output = try humidity_model.prediction(input: input)
            return output.humidity
        } catch {
            print("Error al predecir humedad: \(error)")
            return nil
        }
    }
    
    private func predictWind(city: String, dateString: String) -> Double? {
        do {
            let input = WindModelInput(city: city, date: dateString)
            let output = try wind_model.prediction(input: input)
            return output.wind
        } catch {
            print("Error al predecir viento: \(error)")
            return nil
        }
    }
}

// Extensión para el uso más simplificado
extension WeatherPredictionService {
    func predict(for city: String, date: Date) -> (temperature: Double, precipitation: Double, humidity: Double, wind: Double)? {
        guard let prediction = predictWeather(for: city, date: date) else {
            return nil
        }
        
        return (
            temperature: prediction.temperature,
            precipitation: prediction.precipitation,
            humidity: prediction.humidity,
            wind: prediction.wind
        )
    }
}
