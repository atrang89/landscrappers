//
//  ViewController.swift
//  LandScrappers
//
//  Created by Andy Trang on 10/27/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import SwiftKeychainWrapper

class LoginVC: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var googleSignInBtn: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        if let _ = KeychainWrapper.standard.string (forKey: KEY_UID)
        {
            performSegue(withIdentifier: "ToExploreVC", sender: nil)
        }
    }
    
    @IBAction func googleButtonTapped(_ sender: AnyObject) {
        //GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func handleGoogleSignIn()
    {
        GIDSignIn.sharedInstance().signIn()
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
            else
            {
                print ("AT: Successfully authenticated with Firebase")
                if let user = user
                {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
    }
    
    //Sign in with Facebook
    func completeSignIn(id: String, userData: Dictionary<String, String>)
    {
        DataService.ds.createFireBaseDBUser(uid: id, userData: userData)
        let keyChainResult = KeychainWrapper.standard.set(id,forKey: KEY_UID)
        print("Andrew: Data saved to keychain \(keyChainResult)")
        performSegue(withIdentifier: "ToExploreVC", sender: nil)
    }
    
    @IBAction func guestBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ToExploreVC", sender: nil)
    }
}

