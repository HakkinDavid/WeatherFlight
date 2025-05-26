//
//  WeatherPredictionService.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 17/05/25.
//

import CoreML
import Foundation

enum DataSource {
    case api
    case mlModel
}

class WeatherPredictionService {
    private let temperature_model: TemperatureModel
    private let precipitation_model: PrecipitationModel
    private let humidity_model: HumidityModel
    private let wind_model: WindModel

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

    static func isDateWithinForecastRange(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let futureDate = calendar.date(byAdding: .day, value: 15, to: today)!
        let targetDate = calendar.startOfDay(for: date)
        return targetDate >= today && targetDate <= futureDate
    }

    func fetchWeatherData(for destination: Destination, date: Date, completion: @escaping (WeatherData?, String?) -> Void) {
        if WeatherPredictionService.isDateWithinForecastRange(date) {
            fetchWeatherFromApi(for: destination, date: date, completion: completion)
        } else {
            fetchWeatherFromModel(for: destination, date: date, completion: completion)
        }
    }

    private func fetchWeatherFromApi(for destination: Destination, date: Date, completion: @escaping (WeatherData?, String?) -> Void) {
        let lat = destination.latitude
        let lon = destination.longitude
        let formattedDate = Self.formattedDateString(date)

        let urlStr = """
        https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&start_date=\(formattedDate)&end_date=\(formattedDate)&daily=temperature_2m_max,temperature_2m_min,precipitation_sum,windspeed_10m_max,relative_humidity_2m_mean&current=temperature_2m&timezone=auto
        """

        guard let url = URL(string: urlStr) else {
            completion(nil, "URL inválida")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error.localizedDescription)
                    return
                }

                guard let data = data else {
                    completion(nil, "No se recibieron datos")
                    return
                }

                do {
                    var result = try JSONDecoder().decode(WeatherData.self, from: data)
                    result.season = Self.determineSeason(from: date)
                    completion(result, nil)
                } catch {
                    completion(nil, "Error al decodificar datos: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    private func fetchWeatherFromModel(for destination: Destination, date: Date, completion: @escaping (WeatherData?, String?) -> Void) {
        if let prediction = predict(for: destination.name, date: date) {
            let daily = WeatherData.Daily(
                temperature_2m_max: [prediction.temperature],
                temperature_2m_min: [],
                precipitation_sum: [prediction.precipitation],
                windspeed_10m_max: [prediction.wind],
                relative_humidity_2m_mean: [prediction.humidity],
                time: [Self.formattedDateString(date)]
            )

            let current = WeatherData.Current(temperature_2m: -273.15)

            let weatherData = WeatherData(
                daily: daily,
                current: current,
                season: Self.determineSeason(from: date)
            )

            completion(weatherData, nil)
        } else {
            completion(nil, "No se pudo generar la predicción del clima")
        }
    }

    private static func formattedDateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private static func determineSeason(from date: Date) -> String {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        switch month {
        case 12, 1, 2: return "invierno"
        case 3, 4, 5: return "primavera"
        case 6, 7, 8: return "verano"
        case 9, 10, 11: return "otoño"
        default: return "desconocida"
        }
    }

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

    private func predictWeather(for city: String, date: Date) -> WeatherPrediction? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd"
        let dateString = formatter.string(from: date)

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
