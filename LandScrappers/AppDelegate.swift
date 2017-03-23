//
//  AppDelegate.swift
//  LandScrappers
//
//  Created by Andy Trang on 10/27/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FBSDKLoginKit
import SwiftKeychainWrapper

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{

    var window: UIWindow?
    var databaseRef: FIRDatabaseReference!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Use Firebase library to configure APIs
        FIRApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        //FB
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        
        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return googleDidHandle || facebookDidHandle
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if let error = error
        {
            print(error.localizedDescription)
            return
        }
        print("User signed into Google")
        
        guard let idToken = user.authentication.idToken else {return}
        guard let accessToken = user.authentication.accessToken else {return}
        
        let credential = FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

        let fullName = user.profile.name as NSString
        let email = user.profile.email as NSString
        let userId = user.userID as NSString
        
        print("Google Sign In:\(fullName)")
        print("Google Sign In:\(email)")
        print("Google Sign In:\(userId)")
        
        let dict: [String: AnyObject] = ["name": fullName, "email": email, "id": userId]
            
        FIRAuth.auth()?.signIn(with: credential, completion:
        { (user, error) in
            if let error = error {
                print("User Signed Into Google", error)
                return
            }
        })
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            guard let uid = user?.uid else {return}
            let usersReference = DataService.ds.REF_BASE.child("user_profiles").child(uid)
            
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
                    
                    self.handleLogin()
                }
            }
            
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
            
        })
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>)
    {
        DataService.ds.createFireBaseDBUser(uid: id, userData: userData)
        let keyChainResult = KeychainWrapper.standard.set(id,forKey: KEY_UID)
        print("Andrew: Data saved to keychain \(keyChainResult)")
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let error = error
        {
            print(error.localizedDescription)
            return
        }
    }

    
    func googleLoginNavController()
    {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ExploreVCID") as! ExploreTableVC
        
        let tablePage = UINavigationController (rootViewController: viewController)
        
        self.window?.rootViewController = tablePage
    }
    
    func handleLogin()
    {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "TabBarID") 
        self.window?.rootViewController = viewController
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
