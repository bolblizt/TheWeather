//
//  DailyForecast.swift
//  TheWeather
//
//  Created by user on 6/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation


class DailyForecast{
    
    
    var day:Int = 0
    var summary:String = ""
    var temperatureMin:Double =  0.00
    var temperatureMax:Double =  0.00
    var icon:String = ""
    var dayDetails:[DailyDetails] = []
    //var dayDetails:details = details(daySummary: "", temperatureMin: 0, temperatureMax: 0, icon: "")
   
}

struct DailyDetails {
    var daySummary:String = ""
    var temperatureMin:Double = 0.0
    var temperatureMax:Double = 0.00
    var icon:String = ""
}
