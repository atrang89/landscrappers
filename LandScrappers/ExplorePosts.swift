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
    private var _distance: Double!
    
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
    
    var distance: Double
    {
        return _distance
    }
    
    var postKey: String
    {
        return _postKey
    }
    
    init(title: String, imageURL: String, userLocation: String, likes: Int, lat: Double, lon: Double, distance: Double)
    {
        self._title = title
        self._imageURL = imageURL
        self._location = userLocation
        self._likes = likes
        self._lat = lat
        self._lon = lon
        self._distance = distance
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
        
        if let userlocation = postData["location"] as? String
        {
            self._location = userlocation
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
    
    func configureDistance(distance: Double)
    {
        self._distance = distance
    }
}
