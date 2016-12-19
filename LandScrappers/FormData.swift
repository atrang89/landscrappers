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
    private var _interest: Bool!
    private var _formKey: String!
    
    var serviceLabel: String
    {
        return _serviceLabel
    }
    
    var interest: Bool
    {
        return _interest
    }
    
    var formKey: String
    {
        return _formKey
    }
    
    init(serviceLabel: String, interest: Bool)
    {
        self._serviceLabel = serviceLabel
        self._interest = interest
    }
    
    //Get Firebase data and use in MyFormVC
    init(formKey: String!, formData: Dictionary<String, AnyObject>) {
        self._formKey = formKey
        
        if let serviceLabel = formData["services"] as? String {
            self._serviceLabel = serviceLabel
        }
        
        if let interest = formData["interest"] as? Bool {
            self._interest = interest
        }
    }
}
