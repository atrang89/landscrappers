//
//  FoundationVC.swift
//  LandScrappers
//
//  Created by Andy Trang on 11/2/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class RegisterVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var streetField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var zipField: UITextField!
    @IBOutlet weak var addressLbl: UILabel!
    
    var geoCoder: CLGeocoder?
    var person: Person!
    private let PROFILE_SEGUE = "ToProfileVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.geoCoder = CLGeocoder()
    }
    
    @IBAction func nextBtnPress(_ sender: AnyObject) {
        if emailField.text != "" && passwordField.text != ""{
            
            if passwordField.text! == confirmPassword.text! {
            
                AuthProvider.Instance.signUp(withEmail: emailField.text!, password: passwordField.text!, name: nameField.text!, loginHandler: { (message) in
                
                    if message != nil {
                        self.alertTheUser(title: "Problem With Creating A New User", message: message!)
                    } else {
                        self.emailField.text = ""
                        self.passwordField.text = ""
                        self.geoCoordinates()
                        
                        self.performSegue(withIdentifier: self.PROFILE_SEGUE, sender: nil)
                    }
                })
            } else {
                alertTheUser(title: "Passwords Do Not Match", message: "Please make sure your passwords are entered correctly")
            }
        } else {
            alertTheUser(title: "Email And Password Are Required", message: "Please enter email and password in the text fields")
        }
    }
    
    @IBAction func cancelPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func addressOutput(person: Person)
    {
        self.person = person
        self.streetField.text = person.street
        self.cityField.text = person.city
        self.stateField.text = person.state
        self.zipField.text = person.zip
        self.addressLbl.text = person.address
            
        print ("STREET: \(person.street)")
        print ("CITY: \(person.city)")
        print ("ADDRESS: \(person.address)")
    }
    
    func geoCoordinates()
    {
        let ref = DataService.ds.REF_LOCATION
        
        let personInfo = Person(street: streetField.text!, city: cityField.text!, state: stateField.text!, zip: zipField.text!)
        
        self.addressOutput(person: personInfo)
        
        if let text = self.addressLbl.text
        {
            self.geoCoder?.geocodeAddressString(text, completionHandler: { (placemarks, error) in
                if error != nil
                {
                    print("Address: \(error)")
                } else {
                    if let placemarks = placemarks?.last {
                        let lat = placemarks.location!.coordinate.latitude
                        let lon = placemarks.location!.coordinate.longitude

                        let values = ["lat": lat, "lon": lon]
                        ref.setValue(values)
                    }
                }
            })
        }
    }
    
    private func alertTheUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
}
