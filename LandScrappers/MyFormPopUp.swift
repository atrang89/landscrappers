//
//  MyFormPopUp.swift
//  LandScrappers
//
//  Created by Andy Trang on 12/9/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit

class MyFormPopUp: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageSelect: UIImageView!
    
    var form = [FormData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func popUpClose(_ sender: AnyObject) {
        
//        guard let text = textField.text, text != "" else {
//            print ("Service Text must be entered")
//            return
//        }
        
        if let text = textField.text {
            self.postToFirebase(service: text)
        }
        
        
        dismiss(animated: true, completion: nil)
    }

    func postToFirebase(service: String) {
        let form: Dictionary<String, AnyObject> = [
        "services": textField.text! as AnyObject
        ]
        
        let firebasePost = DataService.ds.REF_FORMS.childByAutoId()
        firebasePost.setValue(form)
    }
}
