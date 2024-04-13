//
//  Weather.swift
//  TripPlanner
//
//  Created by Rachit Chawla on 12/04/24.
//

import Foundation

struct WeatherResult: Codable {
    let weather: [Weather]
    let main: Main
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    // Add other properties like temp_min, temp_max, humidity, etc., if needed
}
