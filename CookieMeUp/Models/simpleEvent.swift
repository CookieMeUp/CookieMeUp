//
//  simpleEvent.swift
//  CookieMeUp
//
//  Created by Daniel Calderon on 3/27/18.
//  Copyright © 2018 Daniel Calderon. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces
class simpleEvent{
    var adressLabel: String?
    var location: CLLocation?
    var dateString: String?
    var referenceId: String?
    var distance: Double?
    init(adressLabel: String?, location: CLLocation?, dateString: String?,referenceId: String?){
        self.adressLabel = adressLabel
        self.location = location
        self.dateString = dateString
        self.referenceId = referenceId
        distance = nil
    }
}
