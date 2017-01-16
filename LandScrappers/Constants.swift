//
//  Constants.swift
//  LandScrappers
//
//  Created by Andy Trang on 11/6/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit

let SHADOW_GRAY: CGFloat = 120.0 / 255.0
let LIGHT_GRAY: CGFloat = 170.0 / 255.0

let KEY_UID = "uid"

let EMAIL = "email"
let PASSWORD = "password"


//if FIRAuth.auth()?.currentUser?.uid == nil {
//    performSelector(#selector(handleLogout), withObject: nil, afterDelay: 0)
//} else {
//    let uid = FIRAuth.auth()?.currentUser?.uid
//    FIRDatabase.database().reference().child("users").child(uid!).observeSingleEventOfType(.Value, withBlock: {snapshot) in
//        
//        print (snapshot) }, withCancelBlock: nil)}
//
//https://www.youtube.com/watch?v=qD582zfXlgo&index=4&list=PL0dzCUj1L5JEfHqwjBV0XFb9qx9cGXwkq
//}
//}
