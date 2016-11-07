//
//  ViewController.swift
//  LandScrappers
//
//  Created by Andy Trang on 10/27/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit

class LoginVC: UIViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    @IBAction func fbButtonTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil
            {
                print("AT: Cannot Authenticate with Facebook - \(error)")
            }
                
                //if given the permission but user declines
            else if result?.isCancelled == true
            {
                print("AT: User cancelled auth")
            }
            else
            {
                print("AT: Successfully logged into FB")
                //Needs credential to communicate with Firebase using token
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.fireBaseAuth(credential)
            }
        }
    }
    
    func fireBaseAuth(_ credential:FIRAuthCredential)
    {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil
            {
                print("AT: Unable to authenticate with firebase")
            }
            else{
                print ("AT: Successfully authenticated with Firebase")
            }
        })
    }
}

