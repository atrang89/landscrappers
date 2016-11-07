//
//  VisualTweaks.swift
//  LandScrappers
//
//  Created by Andy Trang on 11/6/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit

class VisualTweaks: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: SHADOW_GRAY).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }

}
