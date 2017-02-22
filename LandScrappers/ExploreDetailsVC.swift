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
    
    private var _post: ExplorePosts!
    
    var post: ExplorePosts {
        get {
            return _post
        } set {
            _post = newValue
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func blueBtnPressed(_ sender: AnyObject) {
        let fromID = FIRAuth.auth()!.currentUser!.uid
        let toID = post.postKey

        let values = ["fromID": fromID, "toID": toID] as [String : Any]
       
        DataService.ds.REF_SERVICE.childByAutoId().updateChildValues(values)
    }
}
