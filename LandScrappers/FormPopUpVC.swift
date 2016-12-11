//
//  FormPopUpVC.swift
//  LandScrappers
//
//  Created by Andy Trang on 12/11/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit

class FormPopUpVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func closePopUp(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}
