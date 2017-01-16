//
//  PostCell.swift
//  LandScrappers
//
//  Created by Andy Trang on 11/17/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class PostCell: UITableViewCell, CLLocationManagerDelegate {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likesImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var post: ExplorePosts!
    var likesRef: FIRDatabaseReference!
    var distanceRef: FIRDatabaseReference!
    var geoCoder: CLGeocoder?
    
    private var locationManager = CLLocationManager()
    private var userLocation: CLLocationCoordinate2D?
    private var otherLocation: CLLocationCoordinate2D?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.geoCoder = CLGeocoder()
        
        //Adding tap recognizer since storyboard doesn't instantiate properly in table
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likesImage.addGestureRecognizer(tap)
        likesImage.isUserInteractionEnabled = true
        
        initializeLocationManager()
        MapHandler.MapManager.observeMapData()
    }
    
    func initializeLocationManager() {
        //TODO Utilize location manager later
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func configureCell(post: ExplorePosts, img: UIImage? = nil)
    {
        self.post = post
        
        //Send data to firebase
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        self.companyLabel.text = post.title
        self.locationLabel.text = post.mylocation
        self.likesLabel.text = "\(post.likes)"
        //self.distanceLabel.text = "\(post.distance)"
        
        if img == nil {
            postImage.image = UIImage(named: "add profile img")
            return
        }
        
        //If in cache, post image
        if img != nil {
            self.postImage.image = img
        } else {
            //Download images if not in cache
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in  //2mb
                if error != nil
                {
                    print("ANDREW: Unable to download image from Firebase storage")
                }
                else
                {
                    print("ANDREW: Image downloaded from Firebase storage and saving to cache")
                    if let imgData = data
                    {
                        if let img = UIImage(data: imgData)
                        {
                            self.postImage.image = img
                            ExploreTableVC.imageCache.setObject(img, forKey: post.imageURL as NSString)
                        }
                    }
                }
                
            })
        }
        addressToGeoCoordinates ()
    }
    
    //Push and Pull data to firebase
    func likeTapped(sender: UITapGestureRecognizer)
    {
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likesImage.image = UIImage(named: "ic_thumb_up")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
                self.likesLabel.text = "\(self.post.likes)"
            }
            else
            {
                self.likesImage.image = UIImage(named: "Circle")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
                self.likesLabel.text = "\(self.post.likes)"
            }
        })
    }
    
    func addressToGeoCoordinates () {
        if let text = self.locationLabel.text
        {
            self.geoCoder?.geocodeAddressString(text, completionHandler: { (placemarks, error) in
                if error != nil
                {
                    print("Address: \(error)")
                } else {
                    if let placemarks = placemarks?.last {
                        let lat = placemarks.location!.coordinate.latitude
                        let lon = placemarks.location!.coordinate.longitude
                        
                        let uid = FIRAuth.auth()?.currentUser?.uid
                        
                        DataService.ds.REF_POSTS.child(uid!).child("lat").setValue(lat)
                        DataService.ds.REF_POSTS.child(uid!).child("lon").setValue(lon)
                        
                        let userLocation = CLLocation(latitude: lat, longitude: lon) //userLocation
                        let otherLocation = CLLocation(latitude: lat, longitude: lon) //otherLocation
                        
                        let myDistance: Double = userLocation.distance(from: otherLocation)/1609
                        
                        self.post.calculateDistance(myDistance: myDistance)
                        DataService.ds.REF_USER_CURRENT.child("distance").child(self.post.postKey)
                        
                        self.distanceLabel.text = "\(self.post.distance)"
                        
                        print("POSTDistance: \(self.post.distance)")
                    }
                }
            })
        }
    }
}
