//
//  ExplorePosts.swift
//  LandScrappers
//
//  Created by Andy Trang on 11/24/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import Foundation

class ExplorePosts
{
    private var _title: String!
    private var _imageURL: String!
    private var _likes: Int!
    private var _postKey: String!
    
    var title: String
    {
        return _title
    }
    
    var imageURL: String
    {
        return _imageURL
    }
    
    var likes: Int
    {
        return _likes
    }
    
    var postKey: String
    {
        return _postKey
    }
    
    init(title: String, likes: Int)
    {
        self._title = title
        self._likes = likes
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
        
        if let likes = postData["likes"] as? Int
        {
            self._likes = likes
        }
    }
}
