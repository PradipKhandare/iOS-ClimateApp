//
//  WeatherData.swift
//  MyClimateApp
//
//  Created by NTS on 04/01/24.
//

import Foundation

struct WeatherData: Decodable, Encodable
{
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable, Encodable
{
    var temp: Double
}

struct Weather: Decodable, Encodable
{
    var id: Int
    var description: String
}

