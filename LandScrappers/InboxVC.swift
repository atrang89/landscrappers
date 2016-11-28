//
//  InboxVCViewController.swift
//  LandScrappers
//
//  Created by Andy Trang on 11/21/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit

class InboxVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func buttonPressedToRegister(_ sender: UIButton) {
        performSegue(withIdentifier: "ToRegisterVC", sender: nil)
    }
}
