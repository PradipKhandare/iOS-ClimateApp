//
//  ViewController.swift
//  MyClimateApp
//
//  Created by NTS on 04/01/24.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    var weatherManager = WeatherManager()
    var lastUserLocation = CLLocationManager()
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var climateLogo: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastUserLocation.delegate = self
        lastUserLocation.requestWhenInUseAuthorization()
        lastUserLocation.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
       
    }

    @IBAction func searchButtonTapped(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }

}

//MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != nil {
            return true
        }else{
            textField.placeholder = "Type Something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate
extension ViewController: WeatherManagerDelegate
{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherCondition) {
        
        DispatchQueue.main.async {
            self.tempLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.climateLogo.image = UIImage(systemName: weather.conditionName)
            self.infoLabel.text = weather.description
        }
    
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate
{
    
    @IBAction func currentLocationButtonTapped(_ sender: UIButton) {
        lastUserLocation.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            lastUserLocation.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
         weatherManager.fetchWeather(lattitude: lat, longitude: lon)
            
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

