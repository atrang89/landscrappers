//
//  MyFormPopUp.swift
//  LandScrappers
//
//  Created by Andy Trang on 12/9/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit
import Firebase

class MyFormPopUp: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageSelect: UIImageView!
    
    var form = [FormData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func popUpClose(_ sender: AnyObject) {
        
        guard let serviceText = textField.text, serviceText != "" else {
            print("FORM: Description must be entered")
            return
        }
        
        //Optimize later
        if let text = textField.text {
            self.postToFirebase(service: text)
        }
        
        dismiss(animated: true, completion: nil)
    }

    func postToFirebase(service: String) {
        let form: Dictionary<String, AnyObject> = ["services": textField.text! as AnyObject]
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        let firebasePost = DataService.ds.REF_FORMS.child(uid!)
        
        firebasePost.setValue(form)
    }
}
