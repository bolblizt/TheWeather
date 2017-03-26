//
//  ViewController.swift
//  TheWeather
//
//  Created by user on 5/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, DataConnectionDelegate {

    var myLocation:LocationMod!
    var myConnection:DataConnection!
    var dailyWeather:DailyForecast!
    var weekDays = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday", "Saturday"]
    @IBOutlet weak var forecastTable:UITableView!
    @IBOutlet weak var temperature:UILabel!
    @IBOutlet weak var weatherIcon:UIImageView!
    @IBOutlet weak var location:UILabel!
    @IBOutlet weak var summary:UILabel!
    
    @IBOutlet weak var sumIcon:UIImageView!
    @IBOutlet weak var sumLabel:UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.view.bounds
        self.view.addSubview(blurredEffectView)
        self.view.sendSubview(toBack: blurredEffectView)
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.locationMain =  locationManager
        
        self.myLocation = LocationMod.LocationNow()
        self.myConnection = DataConnection.ConnectNow()
        self.myConnection.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    //MARK: - CLLocation delegates
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0{
            
            let currentLoc = locations[0]
            let lat = currentLoc.coordinate.latitude
            let lon = currentLoc.coordinate.longitude
            
            if( self.myLocation.NewLocation(newX: lat , newY: lon )){
                
                DispatchQueue.global(qos: .default).async {
                    self.myConnection.longitude = self.myLocation.locationY
                    self.myConnection.latitude = self.myLocation.locationX
                    self.myConnection.GetNewData()
                    
                    
                }
                
            }
            print(currentLoc.coordinate.longitude)
            manager.stopUpdatingLocation()
            
        }
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            manager.startUpdatingLocation()
        }
        else if CLLocationManager.authorizationStatus() == .notDetermined{
            
            manager.requestWhenInUseAuthorization()
        }
        else
        {
            manager.requestWhenInUseAuthorization()
        }
        
    }
    
    
    
    
    //MARK: -  Table delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rowCount:Int
        rowCount  = 0
        
        if self.dailyWeather.dayDetails.count > 0 {
            rowCount = self.dailyWeather.dayDetails.count - 1
           // print("Days \(rowCount)")
        }
        
        
        return rowCount
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) 
        
        
            cell = tableCell(tableCell: cell, index: indexPath)
        
        
        
        return cell
    }
    
    
    func tableCell(tableCell:UITableViewCell, index:IndexPath) ->UITableViewCell{
        
        let dailyData = self.dailyWeather.dayDetails[index.row]
        tableCell.detailTextLabel?.text = dailyData.daySummary
        let max = Int(dailyData.temperatureMax)
        let min = Int(dailyData.temperatureMin)
        tableCell.textLabel?.text = "\(min)° - \(max)°  \(self.weekDays[index.row])"
        tableCell.imageView?.image = UIImage.init(named: "\(dailyData.icon)")
        
        return tableCell
    }
    
    
    //MARK: Other delegate
    func UpdateTableView(weatherInformation:WeatherInfo){
        
        DispatchQueue.main.async {
            
           self.weatherIcon.image = UIImage(named:weatherInformation.icon)
           self.location.text = weatherInformation.location
           let intTemp = Int(weatherInformation.temperature)
            self.temperature.text = "\(intTemp)°"
            self.summary.text = weatherInformation.summary
           
            if weatherInformation.dailyWeather.count > 0{
                 self.dailyWeather = weatherInformation.dailyWeather[0]
                self.sumLabel.text = self.dailyWeather.summary
                 self.forecastTable.delegate = self
                 self.forecastTable.dataSource = self
                self.forecastTable.reloadData()
            }
          
            
        }
    }
    
    //MARK: Test
    func TestMode(lat:Double , lon:Double){
        self.myConnection = DataConnection()
        self.myConnection.longitude = lat
        self.myConnection.latitude = lon
        self.myConnection.GetNewData()
        
        
    }
    
    
    //func  LocationChange(lat:Double lon:Double){
        
    //}
}



