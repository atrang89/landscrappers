//
//  MapVC.swift
//  LandScrappers
//
//  Created by Andy Trang on 12/8/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    private var locationManager = CLLocationManager()
    private var userLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //Getting coordinates
        let latitude: CLLocationDegrees = 44.5644118
        let longitude: CLLocationDegrees = -88.109463
        
        //Map scaling
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        
        //Overall map view using latDelta and lonDelta
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D (latitude: latitude, longitude: longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: userLocation, span: span)
        
        self.map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = "My House"
        annotation.subtitle = "No one comes into my house without paying the price"
        annotation.coordinate = userLocation
        map.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Getting coordinates
        let latitude: CLLocationDegrees = 44.5644118
        let longitude: CLLocationDegrees = -88.109463
        
        //Map scaling
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        
        //Overall map view using latDelta and lonDelta
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D (latitude: latitude, longitude: longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: userLocation, span: span)
        
        self.map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = "My House"
        annotation.subtitle = "No one comes into my house without paying the price"
        annotation.coordinate = userLocation
        map.addAnnotation(annotation)
    }

    @IBAction func cancelPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}
