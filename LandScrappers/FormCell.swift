//
//  FormCell.swift
//  LandScrappers
//
//  Created by Andy Trang on 12/8/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class FormCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    func configureCell(form: FormData) {
        self.title.text = form.serviceLabel
    }
}

class FormInteract: FormCell {
    @IBOutlet weak var selectBtn: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCheckMark(selected: false)
    }

    func setCheckMark(selected: Bool){
        let imageChecked = selected ? "messageindicatorchecked3" : "messageindicator3"

        self.selectBtn.image = UIImage(named: imageChecked)
    }
}
