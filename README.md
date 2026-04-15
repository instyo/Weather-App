# Weather App

A simple iOS weather application built with UIKit that displays current weather information for a given location.

## Features

- Displays current temperature, weather condition, and location
- Fetches weather data from a weather API
- Clean and intuitive user interface

## Screenshots

| 1.png | 2.png | 3.png |
|-------|-------|-------|
| ![Screenshot 1](https://raw.githubusercontent.com/instyo/Weather-App/refs/heads/main/Screenshots/1.png) | ![Screenshot 2](https://raw.githubusercontent.com/instyo/Weather-App/refs/heads/main/Screenshots/2.png) | ![Screenshot 3](https://raw.githubusercontent.com/instyo/Weather-App/refs/heads/main/Screenshots/3.png) |

## Requirements

- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

## Installation

1. Clone the repository
2. Open `Weather App.xcodeproj` in Xcode
3. Build and run the project on a simulator or device

## Usage

Upon launching the app, it will display the current weather information for a default location. The app uses a weather API to fetch real-time data.

## Architecture

The app follows a simple MVC (Model-View-Controller) pattern:
- **Model**: `WeatherModel.swift` - Contains the data structures for weather information
- **View**: Main.storyboard - Contains the UI elements
- **Controller**: `ViewController.swift` - Handles the logic and updates the UI

## API

This app uses a weather API to fetch weather data. You may need to obtain an API key and update the `OPEN_WEATHER_API_KEY` on Info.plist file with your credentials.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
