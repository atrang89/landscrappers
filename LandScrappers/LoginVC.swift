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
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        if let _ = KeychainWrapper.standard.string (forKey: KEY_UID)
        {
            performSegue(withIdentifier: "ToExploreVC", sender: nil)
        }
    }
    
    @IBAction func googleButtonTapped(_ sender: AnyObject) {
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
                //let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                let accessToken = FBSDKAccessToken.current()
                guard let accessTokenString = accessToken?.tokenString else
                    {return}
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
                self.fireBaseAuth(credential)
            }
        }
    }
    
    func fireBaseAuth(_ credential: FIRAuthCredential)
    {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            guard let uid = user?.uid else {
                return
            }
            
            let usersReference = DataService.ds.REF_BASE.child("user_profiles").child(uid)
            
            if error != nil
            {
                print("AT: Unable to authenticate with firebase - \(error)")
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
            
            //Getting User name, email, and id
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, email, name"]).start{
                (connection, result, err) in
                
                if err != nil {
                    print("Failed to start graph request", err)
                    return
                }
                
                let dict: [String:AnyObject] = result as! [String : AnyObject]
                print (result!)
                print (dict)

                // update our databse by using the child database reference above called usersReference
                usersReference.updateChildValues(dict, withCompletionBlock: { (err, ref) in
                    // if there's an error in saving to our firebase database
                    if err != nil {
                        print(err)
                        return
                    }
                    // no error, so it means we've saved the user into our firebase database successfully
                    print("Save the user successfully into Firebase database")
                })
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

