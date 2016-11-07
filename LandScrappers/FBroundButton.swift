//
//  FBroundButton.swift
//  LandScrappers
//
//  Created by Andy Trang on 11/6/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit

class FBroundButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.8).cgColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //suppose to round the corner image
        layer.cornerRadius = 2
    }
}
