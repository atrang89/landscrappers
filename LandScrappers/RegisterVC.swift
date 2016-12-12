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

    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var coordinates: UILabel!
    @IBOutlet weak var coordinatesLon: UILabel!
    
    var geoCoder: CLGeocoder?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.geoCoder = CLGeocoder()
    }
    
    @IBAction func geoCode(_ sender: AnyObject) {
        if let text = self.address.text
        {
            self.geoCoder?.geocodeAddressString(text, completionHandler: { (placemarks, error) in
                if error != nil
                {
                    print("Address: \(error)")
                } else {
                    if let placemarks = placemarks?.last {
                        self.coordinates.text = "lat: \(placemarks.location!.coordinate.latitude)"
                        self.coordinatesLon.text = "long: \(placemarks.location!.coordinate.longitude)"
                    }
                }
            })
        }

    }
}
