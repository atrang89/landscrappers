//
//  ViewController.swift
//  LandScrappers
//
//  Created by Andy Trang on 10/27/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }

}

