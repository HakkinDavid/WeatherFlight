//
//  WeatherPredictionService.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 17/05/25.
//

/*
import CoreML

class WeatherPredictionService {
    private let model: WeatherModel

    init() {
        do {
            self.model = try WeatherModel(configuration: MLModelConfiguration())
        } catch {
            fatalError("No se pudo cargar el modelo WeatherModel.mlmodel: \(error)")
        }
    }

    func predict(for city: String, date: Date) -> (temperature: Double, precipitation: Double, humidity: Double, wind: Double, season: String)? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let input = WeatherModelInput(
            city: city,
            date: formatter.string(from: date)
        )

        do {
            let output = try model.prediction(input: input)
            return (
                temperature: output.temperature,
                precipitation: output.precipitation,
                humidity: output.humidity,
                wind: output.wind,
                season: output.season
            )
        } catch {
            print("Error al hacer predicción: \(error)")
            return nil
        }
    }
}
*/
