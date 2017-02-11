//
//  ExploreDetailsVC.swift
//  LandScrappers
//
//  Created by Andy Trang on 1/17/17.
//  Copyright © 2017 AlwaysOnAlpha. All rights reserved.
//

import UIKit
import Firebase

class ExploreDetailsVC: UIViewController {
    
    var user: ExplorePosts!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func blueBtnPressed(_ sender: AnyObject) {
        let ref = DataService.ds.REF_FORMS
        let childRef = ref.childByAutoId()
        let fromID = FIRAuth.auth()!.currentUser!.uid
        let toID = user.postKey
        
        let values = ["fromID": fromID, "toID": toID] as [String : Any]
        
        childRef.updateChildValues(values)
    }
}
