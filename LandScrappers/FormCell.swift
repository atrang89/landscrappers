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
    @IBOutlet weak var interestedIMG: UIImageView!
    
    var form: FormData!
    var interestRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(interestTapped))
        tap.numberOfTapsRequired = 1
        interestedIMG.addGestureRecognizer(tap)
        interestedIMG .isUserInteractionEnabled = true
    }
    
    func configureCell(form: FormData) {
        self.form = form
        self.title.text = form.serviceLabel
        
        interestRef = DataService.ds.REF_USER_CURRENT.child("interest")  //using keychainwrapper id and reference to user for
    }
    
    func interestTapped (sender: UITapGestureRecognizer)
    {
        interestRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.interestedIMG.image = UIImage(named: "Circle")
                self.form.adjustInterests(interested: false)
                self.interestRef.setValue(true)
            }
            else
            {
                self.interestedIMG.image = UIImage(named: "Float")
                self.form.adjustInterests(interested: false)
                self.interestRef.removeValue()
            }
        })
    }
}
