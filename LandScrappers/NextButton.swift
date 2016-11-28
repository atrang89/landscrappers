//
//  NextButton.swift
//  LandScrappers
//
//  Created by Andy Trang on 11/25/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import Foundation

class NextButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
    }
    
}
