//
//  AuthProviders.swift
//  LandScrappers
//
//  Created by Andy Trang on 1/13/17.
//  Copyright © 2017 AlwaysOnAlpha. All rights reserved.
//

import Foundation
import Firebase

typealias LoginHandler = (_ msg: String?) -> Void //we dont have to return msg

struct LoginErrorCode {
    static let INVALID_EMAIL = "Invalid Email Address, Please Provide A Real Email Address"
    static let WRONG_PASSWORD = "Wrong Password, Please Enter The Correct Password"
    static let PROBLEM_CONNECTING = "Problem Connecting To Database, Please Try Later"
    static let USER_NOT_FOUND = "User Not Found, Please Register"
    static let EMAIL_ALREADY_IN_USE = "Email Already In Use, Please Use Another Email"
    static let WEAK_PASSWORD = "Password Should Be At Least 6 Characters Long"
}

class AuthProvider {
    private static let _instance = AuthProvider()
    
    static var Instance: AuthProvider {
        return _instance
    }
    
    func login(withEmail: String, password: String, loginHandler: LoginHandler?) {
        
        FIRAuth.auth()?.signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            if error != nil {
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler)
            } else {
                loginHandler?(nil)
            }
        })
    }
    
    func signUp(withEmail: String, password: String, name: String, loginHandler: LoginHandler?) {
        
        FIRAuth.auth()?.createUser(withEmail: withEmail, password: password, completion: { (user, error) in
            
            if error != nil {
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler);
            } else {
                
                if user?.uid != nil {
                    
                    // create the user to database
                    DataService.ds.saveUser(uid: user!.uid, email: withEmail, password: password, name: name);
                    
                    // login the user
                    self.login(withEmail: withEmail, password: password, loginHandler: loginHandler);
                }
            }
            
        });
        
    }
    
    private func handleErrors(err: NSError, loginHandler: LoginHandler?) {
        
        if let errCode = FIRAuthErrorCode(rawValue: err.code) {
            
            switch errCode {
                
            case .errorCodeWrongPassword:
                loginHandler?(LoginErrorCode.WRONG_PASSWORD);
                break;
                
            case .errorCodeInvalidEmail:
                loginHandler?(LoginErrorCode.INVALID_EMAIL);
                break;
                
            case .errorCodeUserNotFound:
                loginHandler?(LoginErrorCode.USER_NOT_FOUND);
                break;
                
            case .errorCodeEmailAlreadyInUse:
                loginHandler?(LoginErrorCode.EMAIL_ALREADY_IN_USE);
                break;
                
            case .errorCodeWeakPassword:
                loginHandler?(LoginErrorCode.WEAK_PASSWORD);
                break;
                
            default:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
                
            }
            
        }
        
    }
}
