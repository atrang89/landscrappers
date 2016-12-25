//
//  FoundationVC.swift
//  LandScrappers
//
//  Created by Andy Trang on 11/2/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit
import CoreLocation

class RegisterVC: UIViewController {

    @IBOutlet weak var streetField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var zipField: UITextField!
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var coordinates: UILabel!
    @IBOutlet weak var coordinatesLon: UILabel!
    
    var geoCoder: CLGeocoder?
    var person: Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.geoCoder = CLGeocoder()
    }
    
    @IBAction func geoCode(_ sender: AnyObject) {
        
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
                        self.coordinates.text = "lat: \(placemarks.location!.coordinate.latitude)"
                        self.coordinatesLon.text = "long: \(placemarks.location!.coordinate.longitude)"
                        
                        let coordinate1 = CLLocation(latitude: placemarks.location!.coordinate.latitude, longitude: placemarks.location!.coordinate.longitude)
                        let coordinate2 = CLLocation(latitude: 42.96, longitude: -88.00)
                        let distanceInMeters = coordinate1.distance(from: coordinate2) / 1609
                        
                        
                        print("DISTANCE: \(distanceInMeters)")
                    }
                }
            })
        }
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
}
