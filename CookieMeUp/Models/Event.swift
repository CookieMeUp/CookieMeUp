//
//  Event.swift
//  CookieMeUp
//
//  Created by Daniel Calderon on 3/27/18.
//  Copyright © 2018 Daniel Calderon. All rights reserved.
//

import Foundation
class Event{
    var latitude: Double?
    var longitute: Double?
    var address: String?
    var firebaseUID: String?
    var dateString: String?
    var randomId: String?
    var description: String?
    var username: String?
    init(latitude: Double,longitude: Double?,address: String,firebaseUID: String,dateString: String?,randomId: String?, description: String?, username: String?){
        self.latitude  = latitude
        self.longitute = longitude
        self.address = address
        self.firebaseUID = firebaseUID
        self.dateString = dateString
        self.randomId = randomId
        self.description = description
        self.username = username
    }
    
}
