//
//  WeatherVC.swift
//  RainyShinyCloudy
//
//  Created by KO TING on 2/5/2017.
//  Copyright © 2017年 EdUHK. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTemp: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbWeather: UILabel!
    @IBOutlet weak var imgMainIcon: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    //creating a location manager
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather: CurrentWeather!
    var forecast: Forecast!
    var forecasts = [Forecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //the algo about the location manger
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        print(CURRENT_WEATHER_URL)
        currentWeather = CurrentWeather()
        currentWeather.downloadWeatherDetails {
            //Setup the UI to load downloaded data
            self.downloadForecastData {
                self.updatedMainUI()
            }
        }

    }
    
    //when authorized, do some function and ask for it when we don't have
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete) {
        //Downloading forecast weather data for TableView
        let forecastURL = URL(string: FORECAST_URL)
        Alamofire.request(forecastURL!).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    for obj in list {
                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                        print(obj)
                    }
                    self.forecasts.remove(at: 0)
                    self.tableView.reloadData()
                }
            }
            completed()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell {
            //After WeatherCell
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
        } else {
            return WeatherCell()
        }
    }
    
    func updatedMainUI() {
        lbDate.text = currentWeather.date
        lbTemp.text = "\(currentWeather.currentTemp)"
        lbWeather.text = currentWeather.weatherType
        lbLocation.text = currentWeather.cityName
        imgMainIcon.image = UIImage(named: currentWeather.weatherType)
    }



}

