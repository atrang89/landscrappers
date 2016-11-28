//
//  CircleView.swift
//  LandScrappers
//
//  Created by Andy Trang on 11/17/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        //Round the corner image
        layer.cornerRadius = self.frame.height/2
        clipsToBounds = true
    }

}
