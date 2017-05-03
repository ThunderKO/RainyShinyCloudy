//
//  Location.swift
//  RainyShinyCloudy
//
//  Created by KO TING on 3/5/2017.
//  Copyright © 2017年 EdUHK. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    var latitude: Double!
    var longitude: Double!
}
