//
//  EmailLoginVC.swift
//  LandScrappers
//
//  Created by Andy Trang on 1/13/17.
//  Copyright © 2017 AlwaysOnAlpha. All rights reserved.
//

import UIKit
import Firebase

class EmailLoginVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    private let EXPLORE_SEGUE = "ToExploreVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loginPressed(_ sender: AnyObject) {
        if emailField.text != "" && passwordField.text != "" {
            
            AuthProvider.Instance.login(withEmail: emailField.text!, password: passwordField.text!, loginHandler: { (message) in
                if message != nil {
                    self.alertTheUser(title: "Problem with Authentication", message: message!)
                } else {
                    
                    self.emailField.text = "";
                    self.passwordField.text = "";
                    
                    self.performSegue(withIdentifier: self.EXPLORE_SEGUE, sender: nil)
                }
            })
        } else {
            alertTheUser(title: "Email And Password Are Required", message: "Please enter email and password in the text fields")
        }
    }
    
    @IBAction func backBtnPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    private func alertTheUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil) //creates button
        alert.addAction(ok) //adds button
        present(alert, animated: true, completion: nil) //presents alert
    }
}

