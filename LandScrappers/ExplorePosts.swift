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

class ExplorePosts
{
    private var _title: String!
    private var _imageURL: String!
    private var _likes: Int!
    private var _location: String!
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
    
    var mylocation: String
    {
        return _location
    }
    
    var likes: Int
    {
        return _likes
    }
    
    var distance: Double
    {
        return _distance
    }
    
    var postKey: String
    {
        return _postKey
    }
    
    init(title: String, imageURL: String, mylocation: String, likes: Int, distance: Double)
    {
        self._title = title
        self._imageURL = imageURL
        self._location = mylocation
        self._likes = likes
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
        
        if let mylocation = postData["location"] as? String
        {
            self._location = mylocation
        }
        
        if let likes = postData["likes"] as? Int
        {
            self._likes = likes
        }
        
        if let distance = postData["distance"] as? Double
        {
            self._distance = distance
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
    
    func calculateDistance(myDistance: Double) {
            let roundedDistance = round(myDistance * 100) / 100
            _distance = roundedDistance
        
        _postRef.child("distance").setValue(_distance)
    }
}
