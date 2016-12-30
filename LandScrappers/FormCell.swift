//
//  FormCell.swift
//  LandScrappers
//
//  Created by Andy Trang on 12/8/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import Foundation
import Firebase

class FormCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    var form: FormData!
    var interestRef: FIRDatabaseReference!
    
    func configureCell(form: FormData) {
        self.form = form
        self.title.text = form.serviceLabel
        
        interestRef = DataService.ds.REF_USER_CURRENT.child("interest")  //using keychainwrapper id and reference to user for
    }
}
