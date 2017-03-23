//
//  ExplorePosts.swift
//  LandScrappers
//
//  Created by Andy Trang on 11/24/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation
import MapKit

class ExplorePosts: NSObject, CLLocationManagerDelegate
{
    private var _title: String!
    private var _imageURL: String!
    private var _likes: Int!
    private var _location: String!
    private var _lat: Double!
    private var _lon: Double!
    
    private var _postKey: String! //used in toID
    private var _postRef: FIRDatabaseReference!
    
    var title: String
    {
        return _title
    }
    
    var imageURL: String
    {
        return _imageURL
    }
    
    var userlocation: String
    {
        return _location
    }
    
    var likes: Int
    {
        return _likes
    }
    
    var lat: Double
    {
        return _lat
    }
    
    var lon: Double
    {
        return _lon
    }
    
    var postKey: String
    {
        return _postKey
    }
    
    init(title: String, imageURL: String, mylocation: String, likes: Int, lat: Double, lon: Double)
    {
        self._title = title
        self._imageURL = imageURL
        self._location = mylocation
        self._likes = likes
        self._lat = lat
        self._lon = lon
    }
    
    //Convert data from firebase to use
    init(postKey: String, postData: Dictionary<String, AnyObject>)
    {
        self._postKey = postKey
        
        if let title = postData["title"] as? String
        {
            self._title = title
        }
        
        if let imageURL = postData["imageURL"] as? String
        {
            self._imageURL = imageURL
        }
        
        if let mylocation = postData["location"] as? String
        {
            self._location = mylocation
        }
        
        if let likes = postData["likes"] as? Int
        {
            self._likes = likes
        }
        
        if let lat = postData["latitude"] as? Double
        {
            self._lat = lat
        }
        
        if let lon = postData["longitude"] as? Double
        {
            self._lon = lon
        }

        _postRef = DataService.ds.REF_POSTS.child(_postKey)
    }
    
    func adjustLikes(addLike: Bool)
    {
        if addLike {
            _likes = _likes + 1
        }
        else {
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
    
    var geoCoder: CLGeocoder = CLGeocoder()
    
    func postGeoCoordinates(userLocation: String) {
        
        geoCoder.geocodeAddressString(userLocation, completionHandler: { (placemarks, error) in
            if error != nil
            {
                print("Address: \(error)")
            } else {
                if let placemarks = placemarks?.last {
                    let lat = placemarks.location!.coordinate.latitude
                    let lon = placemarks.location!.coordinate.longitude
                    
                    let uid = FIRAuth.auth()?.currentUser?.uid
                    
                    DataService.ds.REF_POSTS.child(uid!).child("geo").child("lat").setValue(lat)
                    DataService.ds.REF_POSTS.child(uid!).child("geo").child("lon").setValue(lon)
                }
            }
        })
    }
}
