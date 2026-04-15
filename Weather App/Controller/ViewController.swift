//
//  ViewController.swift
//  Weather App
//
//  Created by Ikhwan Setyo on 15/04/26.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var degree: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var visibility: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var windDeg: UILabel!
    @IBOutlet weak var searchCityField: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var infoStackView: UIStackView!
    
    var weatherManager: WeatherManager = WeatherManager()
    let locationManager: CLLocationManager = CLLocationManager()
    
    // Triggers a fresh location fetch when the user taps the location button
    @IBAction func onTapLocation(_ sender: UIButton) {
        searchCityField.text = ""
        handleAuthorizationStatus(locationManager.authorizationStatus)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        infoStackView.layer.cornerRadius = 12
        searchCityField.layer.cornerRadius = 12
        searchCityField.layer.masksToBounds = true
        searchCityField.delegate = self
        weatherManager.delegate = self
        setupLocationManager()
        setupKeyboardListener()
    }
    
    deinit {
        disposeKeyboardListener()
    }
    
    func setupKeyboardListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func disposeKeyboardListener() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let frameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        let keyboardHeight = UIScreen.main.bounds.height - frameEnd.origin.y

        view.frame.origin.y = keyboardHeight > 0 ? -keyboardHeight : 0
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: - WeatherManagerDelegate

extension ViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: Weather) {
        DispatchQueue.main.async {
            self.cityName.text = weather.name
            self.degree.text = weather.temperatureString
            self.condition.text = weather.descriptionString
            self.feelsLike.text = weather.feelsLikeString
            self.pressure.text = weather.pressureString
            self.humidity.text = weather.humidityString
            self.visibility.text = weather.visibilityString
            self.windSpeed.text = weather.windSpeedString
            self.windDeg.text = weather.windDirectionString
            self.backgroundImage.image = weather.backgroundImage
            self.activityIndicator.stopAnimating()
        }
    }
    
    func didGetWeatherError(error: NetworkError) {
        DispatchQueue.main.async {
            self.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleAuthorizationStatus(manager.authorizationStatus)
    }
    
    // Required by requestLocation()
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        Task {
            await weatherManager.getWeatherFromLocation(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(title: "Location Error", message: error.localizedDescription)
    }
    
    private func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.showAlert(title: "Location Access Denied",
                               message: "Please allow location access in Settings.")
            }
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}

// MARK: - Textfield Delegate

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchCityField.text {
            Task {
                await weatherManager.getWeatherFromCity(cityName: city)
            }
        }
    }
}

// MARK: - Helpers

extension ViewController {
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            self.activityIndicator.stopAnimating()
        }
    }
}
