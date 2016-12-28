//
//  MyFormVC.swift
//  LandScrappers
//
//  Created by Andy Trang on 11/27/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class MyFormVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imageAdd: CircleView!
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var formTableView: UITableView!
    
    var formData = [FormData]()
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController() //Init
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        formTableView.delegate = self
        formTableView.dataSource = self
        
        //Gets data from firebase forms of type object (snapshot)
        DataService.ds.REF_FORMS.observe(.value, with: { (snapshot) in
            
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
                        let formData = FormData(formKey: key, formData: formDict)
                        self.formData.append(formData)
                    }
                }
            }
            self.formTableView.reloadData()
        })
    }

    @IBAction func TitleInput(_ sender: UITextField) {
    }
    
    @IBAction func postBtnTapped(_ sender: AnyObject) {
        guard let caption = captionField.text, caption != "" else
        {
            print("ANDREW: Caption must be entered")
            return
        }
        
        guard let img = imageAdd.image, imageSelected == true else{
            print("ANDREW: An image must be selected")
            return
        }
        
        //Send image data to firebase
        //getting image data by uncompression
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
                        self.postToFirease(imgURL: url)
                    }
                }
            }
        }
    }
    
    //Send data to firebase for ExplorePost
    func postToFirease(imgURL: String)
    {
        let post: Dictionary<String, AnyObject> = [
            "title": captionField.text! as AnyObject,
            "imageURL": imgURL as AnyObject,
            "likes": 0 as AnyObject
        ]
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        //let firebasePost = DataService.ds.REF_POSTS.childByAutoId()   //used to create new child objects
        let firebasePost = DataService.ds.REF_POSTS.child(uid!)
        
        firebasePost.setValue(post)
    }
    
    
    
    @IBAction func ImageChange(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
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
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return formData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.blue
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //TODO MVC this view
        let cellToDeSelect:UITableViewCell = tableView.cellForRow(at: indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor(red: LIGHT_GRAY, green: LIGHT_GRAY, blue: LIGHT_GRAY, alpha: 0.8)
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
}
