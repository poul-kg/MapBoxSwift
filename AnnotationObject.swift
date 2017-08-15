//
//  AnnotationObject.swift
//  MapBoxTesting
//
//  Created by Dhvl's iMac on 12/08/17.
//  Copyright © 2017 Dhvl's iMac. All rights reserved.
//

import Foundation
import UIKit
import Mapbox

public class AnnotationObject : NSObject {
    public var userName = ""
    public var time = ""
    public var locationCoordinate : CLLocationCoordinate2D?
    public var id = ""
    public var color = ""
    
    
    init(initWith userName: String, time : String, locationCoordinate : CLLocationCoordinate2D, id : String, color : String) {
        self.userName = userName
        self.time = time
        self.locationCoordinate = locationCoordinate
        self.id = id
        self.color = color
        super.init()
    }
    
    convenience override init() {
        self.init(initWith: "Dhaval", time: "6:00 AM", locationCoordinate: CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0), id: "0", color : "000000")
    }
}
