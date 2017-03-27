//
//  MyFormVC.swift
//  LandScrappers
//
//  Created by Andy Trang on 11/27/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SwiftKeychainWrapper
import CoreLocation

class MyFormVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var imageAdd: CircleView!
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var formTableView: UITableView!
    @IBOutlet weak var locationField: UITextField!
    
    var formData: [FormData] = []
    var imagePicker: UIImagePickerController?
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController() //Init
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        formTableView.delegate = self
        formTableView.dataSource = self
        
        observeServices()
    }
    
    func observeServices() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let ref = DataService.ds.REF_SERVICE.child(uid)
        
        ref.observe(.value, with: { (snapshot: FIRDataSnapshot) in
            
            self.formData = []  //Clear out post array each time its loaded
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot]
            {
                for snap in snapshot
                {
                    print("SNAPform: \(snap)")
                    if let formDict = snap.value as? Dictionary<String, AnyObject>
                    {
                        //Getting UniqueKey ID from snap
                        let key = snap.key
                        let service = FormData(formKey: key, formData: formDict)
                        self.formData.append(service)
                    }
                }
            }
            
            self.formData.sort(by: {$0.serviceLabel < $1.serviceLabel})  //sorts table in myForm
            self.formTableView.reloadData()
        })
    }
    
    @IBAction func postBtnTapped(_ sender: AnyObject) {
        
        guard let caption = captionField.text, caption != "" else {
            print("POST: Caption must be entered")
            return
        }
        
        guard let location = locationField.text, location != "" else {
            print("POST: Address must be entered")
            return
        }
        
        guard let img = imageAdd.image, imageSelected == true else{
            print("POST: An image must be selected")
            return
        }
        
        //Send image data to firebase
        //getting image data by uncompression 20% of quality
        if let imgData = UIImageJPEGRepresentation(img, 0.2)
        {
            //Getting unique identifier
            let imageUID = NSUUID().uuidString
            
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POSTS_IMAGES.child(imageUID).put(imgData, metadata: metadata) { (metadata, error) in
                if error != nil
                {
                    print("ANDREW: Unable to upload image to Firebase storage")
                }
                else
                {
                    print("ANDREW: Successfully uploaded image to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    
                    if let url = downloadURL
                    {
                        self.postToFirebase(imgURL: url)
                        
                        if let newLocation = self.locationField.text {
                            self.geoCoordinatePost(userLocation: newLocation)
                            self.postToProfile(location: newLocation)
                        }
                    }
                }
            }
        }
    }
    
    //Send data to firebase for ExplorePost
    func postToFirebase(imgURL: String)
    {
        let post: Dictionary<String, AnyObject> = [
            "title": captionField.text! as AnyObject,
            "location": locationField.text! as AnyObject,
            "imageURL": imgURL as AnyObject,
            "likes": 0 as AnyObject
        ]
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        let firebasePost = DataService.ds.REF_POSTS.child(uid!)
        
        firebasePost.updateChildValues(post)
    }
    
    func geoCoordinatePost(userLocation: String!) {
        
        let geoCoder: CLGeocoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(userLocation, completionHandler: { (placemarks, error) in
            if error != nil
            {
                print("Address: \(error)")
            } else {
                if let placemarks = placemarks?.last {
                    let lat = placemarks.location!.coordinate.latitude
                    let lon = placemarks.location!.coordinate.longitude
                    
                    let uid = FIRAuth.auth()?.currentUser?.uid
                    
                    let post: Dictionary<String, AnyObject> = ["latitude": lat as AnyObject, "longitude": lon as AnyObject]
                    
                    DataService.ds.REF_POSTS.child(uid!).updateChildValues(post)
                    print("GEO: is this executing")
                }
            }
        })
    }
    
    func postToProfile(location: String!)
    {
        let post: Dictionary<String, AnyObject> = ["location": location as AnyObject]
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        let locationUser = DataService.ds.REF_USERS.child(uid!)
        
        locationUser.updateChildValues(post)
    }
    
    @IBAction func ImageChange(_ sender: AnyObject) {
        present(imagePicker!, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            imageAdd.image = image
            imageSelected = true
        }
        else
        {
            print("ANDREW: No Image printed")
        }
        imagePicker?.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return formData.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let forms = formData[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FormCell") as? FormCell {
            cell.configureCell(form: forms)
            return cell
        }
        else {
            //Return empty if failed
            return FormCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO MVC this view
        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.blue
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //TODO MVC this view
        let cellToDeSelect:UITableViewCell = tableView.cellForRow(at: indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor(red: LIGHT_GRAY, green: LIGHT_GRAY, blue: LIGHT_GRAY, alpha: 0.8)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
//        let forms = self.formData[indexPath.row]
//        let uidFormData = forms["uidFormData"]
//        let firebaseForm = DataService.ds.REF_FORMS
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            formData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
}
