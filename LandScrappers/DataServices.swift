//
//  DataServices.swift
//  LandScrappers
//
//  Created by Andy Trang on 11/22/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

//Reference base and make global = Getting the root URL of firebase
let DB_Base = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService{
    
    //Singleton class that is accessible
    static let ds = DataService()
    
    //DB References
    private var _REF_BASE = DB_Base
    private var _REF_POSTS = DB_Base.child("posts")  //FIRDatabase.database().reference().child("post")
    private var _REF_USERS = DB_Base.child("user_profiles")
    
    //Storage References
    private var _REF_POSTS_IMAGES = STORAGE_BASE.child("PostPics")
    
    var REF_BASE: FIRDatabaseReference
    {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference
    {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference
    {
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference
    {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    var REF_POSTS_IMAGES: FIRStorageReference
    {
        return _REF_POSTS_IMAGES
    }
    
    func createFireBaseDBUser(uid: String, userData: Dictionary<String, String>)
    {
        //Firebase will create a new key
        REF_USERS.child(uid).updateChildValues(userData)
    }
}
