//
//  DetailViewController.swift
//  Alarm
//
//  Created by gtk on 2021/1/3.
//

import UIKit
import CoreLocation

let detail_id = "DetailViewController"
class DetailViewController: UIViewController,CLLocationManagerDelegate {
    var memo:Memo?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    var locationManager:CLLocationManager!
    
    lazy var geoCoder: CLGeocoder = {
        return CLGeocoder()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let memo = memo{
            contentLabel.text = memo.content
            dateLabel.text = memo.getDate()
            timeLabel.text = memo.getTime()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initLocation()
    }
    
    func initLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        getCityInformation(latitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error.localizedDescription = \(error.localizedDescription)")
    }
    
    let SCHEME_AND_HOST = "https://restapi.amap.com"
    let PATH_CITY_INFORMATION = "/v3/geocode/regeo"
    let PATH_WEATHER_INFORMATION = "/v3/weather/weatherInfo"
    let PARAM_KEY = "key=9fd87874bd0d22ba54679a8571db1974"
    let PARAM_EXTENSIONS = "extensions=base"
    
    func getCityInformation(latitude:Double, longitude:Double){
        let url = URL(string: "\(SCHEME_AND_HOST)\(PATH_CITY_INFORMATION)?\(PARAM_KEY)&location=\(longitude),\(latitude)")!
        let task = URLSession.shared.dataTask(with: url){ (data,response,error) in
            if data == nil {
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
            let info = json?["info"] as? String
            
            if info == "OK"{
                let regeocode = json!["regeocode"] as! [String:Any]
                let addressComponent = regeocode["addressComponent"] as! [String:Any]
                let provice = addressComponent["province"] as? String
                let city = addressComponent["city"] as? String
                let adcode = addressComponent["adcode"] as! String
                
                var realCity = city
                if city == nil {
                    realCity = provice
                }
                
                self.updateCityLabelInMainThread(city: realCity!)
                self.getWeatherInformation(adcode: adcode)
            }else{
                self.httpError()
            }
        }
        task.resume()
    }
    
    func getWeatherInformation(adcode:String){
        let url = URL(string: "\(SCHEME_AND_HOST)\(PATH_WEATHER_INFORMATION)?\(PARAM_KEY)&\(PARAM_EXTENSIONS)&city=\(adcode)")!
        
        let task = URLSession.shared.dataTask(with: url){ (data,response,error) in
            if data == nil {
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
            
            let infocode = json!["infocode"] as? String
            if infocode == "10000" {
                let lives = (json!["lives"] as? NSArray)?[0] as? [String:Any]
                if let weather = lives?["weather"] as? String {
                    self.updateWeatherLabelInMainThread(weather: weather)
                }
            }else{
                self.httpError()
            }
        }
        task.resume()
    }
    
    
    func httpError(){
        print("http error")
        DispatchQueue.main.async {
            self.cityLabel.text = ""
            self.weatherLabel.text = ""
        }
    }
    
    func updateCityLabelInMainThread(city:String){
        DispatchQueue.main.async(execute: {
            self.cityLabel.text = city
        })
    }
    
    func updateWeatherLabelInMainThread(weather:String)  {
        DispatchQueue.main.async {
            self.weatherLabel.text = weather
        }
    }
}
