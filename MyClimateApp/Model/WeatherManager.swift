//
//  WeatherManager.swift
//  MyClimateApp
//
//  Created by NTS on 04/01/24.
//

import Foundation
import CoreLocation


protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherCondition)
    func didFailWithError(error: Error)
}

struct WeatherManager
{
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=645a7bdf60164c1adf2427f676b63d12&units=metric"
    //let weatherCondition : WeatherCondition
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeather(lattitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherUrl)&lat=\(lattitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString){                                    //---->Create URL
            
            let session = URLSession(configuration: .default)                  //----Creating url session
            
            let task = session.dataTask(with: url) { data, response, error in //----give the session task
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                   // let dataString = String(data: safeData, encoding: .utf8)
                    if let weather = self.parseJSON(from: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            task.resume()                                                   //---- Start the task
        }
        
    }
    
    func parseJSON(from weatherData: Data) -> WeatherCondition? {
        let decoder = JSONDecoder()
        do{
          let jsonData = try decoder.decode(WeatherData.self, from: weatherData)
            let city = jsonData.name
            let temp = jsonData.main.temp
            let id = jsonData.weather[0].id
            let desc = jsonData.weather[0].description
           
           let weather = WeatherCondition(conditionId: id, cityName: city, temperature: temp, description: desc)
            return weather
        }catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
            
    }
    
//    func codeHandle(data: Data?, response: URLResponse?, error: Error?) {
//        if error != nil {
//            print(error!)
//            return
//        }
//        if let safeData = data {
//            let dataString = String(data: safeData, encoding: .utf8)
//            
//        }
//    }
    
}
