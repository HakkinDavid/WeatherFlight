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
    struct Current: Decodable {
        let temperature_2m: Double
    }
    let daily: Daily
    let current: Current
    var season: String? // Temporada opcional para el fondo
}
