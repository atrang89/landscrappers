//
//  ProfileImageVC.swift
//  LandScrappers
//
//  Created by Andy Trang on 11/25/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit

class ProfileImageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var profileImage: CircleView!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }

    @IBAction func ImageChange(_ sender: AnyObject) {
            present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            profileImage.image = image
        }
        else
        {
            print("ANDREW: No Image printed")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

}
