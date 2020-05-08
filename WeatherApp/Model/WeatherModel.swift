//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by VJ's iMAC on 05/05/20.
//  Copyright © 2020 Deuglo. All rights reserved.
//

import UIKit

class WeatherModel: NSObject {
  
    var cityName      : String?
    var visibility    : Int?
    var timeZone      : Int?
    var temp_max      : Double?
    var temp_min      : Double?
    var feels_like    : Double?
    var pressure      : Double?
    var humidity      : Double?
    var temp          : Double?
    var sunrisetime   : Int?
    var sunSetTime    : Int?
    var windSpeed     : Double?
    
    
    func initWith(dictionary:[String: Any]?){
        self.visibility      = dictionary?["visibility"] as? Int
        self.cityName        = dictionary?["name"] as? String
        self.timeZone        = dictionary?["timezone"] as? Int
        if let windDict = dictionary?["wind"] as? [String: Any]{
            self.windSpeed   = windDict["speed"] as? Double
        }
        if let data     = dictionary?["main"] as? [String: Any]{
            self.temp_min    = data["temp_min"] as? Double
            self.humidity    = data["humidity"] as? Double
            self.pressure    = data["pressure"] as? Double
            self.temp        = data["temp"] as? Double
            self.feels_like  = data["feels_like"] as? Double
            self.temp_max    = data["temp_max"] as? Double
            
        }
        if let sunTimings = dictionary?["sys"] as? [String: Any]{
            self.sunrisetime = sunTimings["sunrise"] as? Int
            self.sunSetTime  = sunTimings["sunset"] as? Int
        }
        
    }
    
}
