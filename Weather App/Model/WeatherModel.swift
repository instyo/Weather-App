//
//  Weather.swift
//  Weather App
//
//  Created by Ikhwan Setyo on 15/04/26.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weather = try? JSONDecoder().decode(Weather.self, from: jsonData)

import Foundation
import UIKit

// MARK: - Weather
struct Weather: Codable {
    let coord: Coord?
    let weather: [WeatherElement]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
    
    var temperatureString: String {
        return String(format: "%.0f", main?.temp ?? 0) + "ºC"
        }
        
        var descriptionString: String {
            return weather?.first?.main ?? "--"
        }
        
        var feelsLikeString: String {
            return String(format: "%.0f", main?.feelsLike ?? 0.0) + "ºC"
        }
        
        var pressureString: String {
            return "\(main?.pressure ?? 0) hPa"
        }
        
        var humidityString: String {
            return "\(main?.humidity ?? 0)%"
        }
        
        var visibilityString: String {
            return "\(visibility ?? 0)m"
        }
        
        var windSpeedString: String {
            return String(format: "%.0f", wind?.speed ?? 0) + "m/s"
        }
        
        var windDirectionString: String {
            return "\(wind?.deg ?? 0)deg"
        }
       
        var backgroundImage: UIImage? {
            switch weather?.first?.id ?? 0 {
            case 200...232:
                return UIImage(named: "thunderstorm")
            case 300...321:
                return UIImage(named: "rain")
            case 500...531:
                return UIImage(named: "rain")
            case 600...622:
                return UIImage(named: "snow")
            case 701...781:
                return UIImage(named: "fog")
            case 801...804:
                return UIImage(named: "clouds")
            default:
                return UIImage(named: "clear")
            }
        }

}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double?
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity, seaLevel, grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int?
    let country: String?
    let sunrise, sunset: Int?
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int?
    let main, description, icon: String?
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}

