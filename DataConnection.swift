//
//  DataConnection.swift
//  TheWeather
//
//  Created by user on 5/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import CoreLocation
import  UIKit

protocol DataConnectionDelegate  {

    func UpdateTableView(weatherInformation:WeatherInfo)
}



class DataConnection{
    
    
    
    
   private static var  apiSecret = "b9b805cb05e5fd2a0d5ec444a0171a0d"
    
    var latitude:Double
    var longitude:Double
    var weather:WeatherInfo!
    var daily: DailyForecast!
    var delegate:DataConnectionDelegate!
    
    private static var connectTo: DataConnection?
    
    // static let sharedInstance = LocationMod()
    
    init (){
        
       latitude = 0.00
        longitude = 0.00
        weather = WeatherInfo()
        daily = DailyForecast()
    }

    static func ConnectNow() -> DataConnection{
        
        // var user:User =
        if connectTo == nil{
            connectTo =  DataConnection()
        }
        
        return connectTo!
    }
    
  
    
   func GetNewData(){
        
     //   let url = "https://api.darksky.net/forecast/b9b805cb05e5fd2a0d5ec444a0171a0d/\(self.latitude),\(self.longitude)"
       
        let url = "https://api.darksky.net/forecast/\(DataConnection.apiSecret)/\(self.latitude),\(self.longitude)"
        print("URL: \(url)")
        if let url = NSURL(string: url) {
            if let data = try? Data(contentsOf: url as URL) {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! [String : AnyObject]
                 
                    
                    if let location = parsedData["timezone"] as? String {
                        
                        self.weather.location = location
                    }
                    
                if let tempArrs = parsedData["currently"] as? [String: AnyObject]{
                     print(tempArrs.count)
                    
                    
                     for tempArr1 in tempArrs {
                        
                       print(tempArr1.key)
                        if tempArr1.key == "summary"{
                            self.weather.summary = tempArr1.value as! String
                            
                        }
                        else if tempArr1.key == "icon"{
                            self.weather.icon = tempArr1.value as! String
                            
                        }
                        else if tempArr1.key == "temperature"{
                            self.weather.temperature = (tempArr1.value as! NSNumber).doubleValue
                        }
                        else if tempArr1.key == "humidity"{
                            self.weather.humidity = (tempArr1.value as! NSNumber).doubleValue
                        }
                        
                        
                    }
                }
 
                    
                    if let theWeek = parsedData["daily"] as? [String: AnyObject]{
                        print(theWeek.count)
                        
                        
                        for week in theWeek {
                            
                            print(week.key)
                            if week.key == "summary"{
                                self.daily.summary = week.value as! String
                                
                            }
                            else if week.key == "icon"{
                                
                                self.daily.icon = week.value as! String
                            }
                            else if week.key == "data"{
                             
                                
                                if  let daily = week.value as? NSArray {
                                    print("Daily :\(daily.count)")
                                    
                                    for  dayWeather in daily{
                                        
                                        let dayInfo = dayWeather as? [String: AnyObject]
                                        
                                        var info:DailyDetails = DailyDetails()
                                        for details in dayInfo!{
                                            
                                            if details.key == "summary"{
                                                info.daySummary  = details.value as! String
                                
                                            }
                                            else if details.key == "temperatureMin"{
                                                info.temperatureMin  = (details.value as! NSNumber).doubleValue
                                                
                                            }
                                            else if details.key == "temperatureMax"{
                                                info.temperatureMax = (details.value as! NSNumber).doubleValue
                                              
                                            }
                                            else if details.key == "icon"{
                                                info.icon = details.value as! String
                                            }
                                            
                                                
                                        }
                                        self.daily.dayDetails.append(info)
                                        
                                    }
                                    
                                }
                                
                            }
    
                        }
                        
                        self.weather.dailyWeather.append(self.daily)
                        print("Week Count: \(self.weather.dailyWeather.count)")
                        self.delegate.UpdateTableView(weatherInformation: self.weather)
                        
                    }
                    
                    
                }
                    //else throw an error detailing what went wrong
                catch let error as NSError {
                    print("Details of JSON parsing error:\n \(error)")
                }
            }
            
            
            
        }
      
    }
    
    
    
    
    
}
