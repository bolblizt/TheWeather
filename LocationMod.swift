//
//  LocationManager.swift
//  TheWeather
//
//  Created by user on 5/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class LocationMod{
    
    var locationX:CLLocationDegrees
    var locationY:CLLocationDegrees
    var locationName:String
    
    
     private static var userLocation: LocationMod?
   
   // static let sharedInstance = LocationMod()
   
    init (){
        self.locationX = 0.00
        self.locationY = 0.00
        self.locationName = ""
    }
    
 


    static func LocationNow() -> LocationMod{
        
        // var user:User =
        if userLocation == nil{
            userLocation =  LocationMod()  //LocationMod(locationX: 23.2322 locationY: 32.23232, locationName:"now where")
        }
        
        return userLocation!
    }
    
    func NewLocation(newX:CLLocationDegrees, newY:CLLocationDegrees )  -> Bool {
        
        var result: Bool = false
        if (self.locationX != newX) || (self.locationY != newY){
            
            self.locationX = newX
            self.locationY = newY
            result = true
        }
        
        return result
    }
   

}
