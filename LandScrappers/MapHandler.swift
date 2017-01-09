//
//  MapHandler.swift
//  LandScrappers
//
//  Created by Andy Trang on 1/7/17.
//  Copyright © 2017 AlwaysOnAlpha. All rights reserved.
//

import Foundation
import Firebase

protocol LocationController: class {
    func updateUserLocation(lat: Double, long: Double)
    func updateOtherLocation(lat: Double, long: Double)
}

class MapHandler {
    private static let _mapMangager = MapHandler()
    
    weak var delegate: LocationController?
    
    static var MapManager: MapHandler {
        return _mapMangager
    }
    
    func updateUserLocation (lat: Double, long: Double) {
        let data: Dictionary <String, Any> = ["Latitude": lat, "Longitude": long]
        
        DataService.ds.REF_POSTS.child("location").setValue(data);
    }
    
    func observeMapData () {
        DataService.ds.REF_POSTS.observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let lat = data["latitude"] as? Double {
                    if let long = data["longitude"] as? Double {
                        self.delegate?.updateOtherLocation(lat: lat, long: long);
                    }
                }
            }
        }
    }
}
