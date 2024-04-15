//
//  Weather.swift
//  TripPlanner
//
//  Created by Rachit Chawla on 12/04/24.
//

import Foundation

struct WeatherResult: Codable {
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}
