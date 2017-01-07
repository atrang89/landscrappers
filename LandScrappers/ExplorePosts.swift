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
    private var _geoCode: String!
    
    private var _postKey: String!
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
    
    var geoCode: String
    {
        return _geoCode
    }
    
    var postKey: String
    {
        return _postKey
    }
    
    init(title: String, imageURL: String, mylocation: String, likes: Int, geoCode: String)
    {
        self._title = title
        self._imageURL = imageURL
        self._location = mylocation
        self._likes = likes
        self._geoCode = geoCode
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
        
        if let geoCode = postData["geoCode"] as? String
        {
            self._geoCode = geoCode
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
    
    func FirebaseGeo(updateGeo: String)
    {
        _geoCode = updateGeo
        
        _postRef.child("geoCode").setValue(_geoCode)
    }
}
