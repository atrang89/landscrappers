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
let STORAGE_BASE = FIRStorage.storage().reference()  //Reference to images

class DataService{
    
    //Singleton class that is accessible
    static let ds = DataService()
    
    //DB References
    private var _REF_BASE = DB_Base
    private var _REF_POSTS = DB_Base.child("posts")  //FIRDatabase.database().reference().child("post")
    private var _REF_FORMS = DB_Base.child("forms")
    private var _REF_LOCATION = DB_Base.child("location")
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
    
    var REF_FORMS: FIRDatabaseReference
    {
        return _REF_FORMS
    }
    
    var REF_LOCATION: FIRDatabaseReference
    {
        return _REF_LOCATION
    }
    
    var REF_USERS: FIRDatabaseReference
    {
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference
    {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!) //DB_Base.child("user_profiles").child(KeychainWrapper.standard.string(forKey: uid))
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
    
    func saveUser(uid: String, email: String, password: String, name: String) {
        let data: Dictionary<String, Any> = ["email": email, "password": password, "name": name];
        REF_USERS.child(uid).setValue(data)
    }
    
    func sendMediaPullRequest(senderUID: String, sendingTo:Dictionary<String, User>) {
        
        var uids = [String]()
        for uid in sendingTo.keys {
            uids.append(uid)
        }
        
        let pr: Dictionary<String, AnyObject> = ["userID":senderUID as AnyObject, "recipients":uids as AnyObject] 
        
        DB_Base.child("pullRequests").childByAutoId().setValue(pr)
        
    }
}
