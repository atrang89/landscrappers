//
//  MyFormVC.swift
//  LandScrappers
//
//  Created by Andy Trang on 11/27/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit
import Firebase

class MyFormVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageAdd: CircleView!
    @IBOutlet weak var captionField: UITextField!
    
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
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
                }
            }
        }
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
}
