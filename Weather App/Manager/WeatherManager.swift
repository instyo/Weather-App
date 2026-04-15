//
//  WeatherManager.swift
//  Weather App
//
//  Created by Ikhwan Setyo on 15/04/26.
//

import Foundation
import CoreLocation

enum NetworkError: LocalizedError {
    case invalidURL, responseError, failedToDecode, unknown
}

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: Weather)
    func didGetWeatherError(error: NetworkError)
}

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    static let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPEN_WEATHER_API_KEY") as? String
    let openWeatherURL: String = "https://api.openweathermap.org/data/2.5/weather?&units=metric&appid=\(apiKey ?? "")"
    
    func getRequest(with url: String) async {
        print(">> GET REQUEST : \(url)")
        do {
            guard let url = URL(string: url) else {
                throw NetworkError.invalidURL
            }
            
            print(url.absoluteString)
            
            let request = URLRequest(url: url)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                throw NetworkError.responseError
            }
            
            if let weather = try? JSONDecoder().decode(Weather.self, from: data) {
                delegate?.didUpdateWeather(self, weather: weather)
            } else {
                delegate?.didGetWeatherError(error: NetworkError.responseError)
            }
            
        } catch {
            delegate?.didGetWeatherError(error: NetworkError.unknown)
        }
    }
    
    func getWeatherFromLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async {
        let urlString = "\(openWeatherURL)&lat=\(latitude)&lon=\(longitude)"
        await getRequest(with: urlString)
    }
    
    func getWeatherFromCity(cityName: String) async {
        let urlString = "\(openWeatherURL)&q=\(cityName)"
        let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) // prevent space
        await getRequest(with: encodedUrl ?? urlString)
    }
}
