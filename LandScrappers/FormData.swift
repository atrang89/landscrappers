//
//  FormCell.swift
//  LandScrappers
//
//  Created by Andy Trang on 12/8/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import Foundation

class FormData  {
    private var _serviceLabel: String!
    
    var serviceLabel: String
    {
        return _serviceLabel
    }
    
    init(serviceLabel: String)
    {
        self._serviceLabel = serviceLabel
    }
}
