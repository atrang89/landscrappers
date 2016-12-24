//
//  FormCell.swift
//  LandScrappers
//
//  Created by Andy Trang on 12/8/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import Foundation
import Firebase

class FormData  {
    
    private var _serviceLabel: String!
    private var _interest: Int!
    private var _formKey: String!
    private var _formRef: FIRDatabaseReference!
    
    var serviceLabel: String
    {
        return _serviceLabel
    }
    
    var interest: Int
    {
        return _interest
    }
    
    var formKey: String
    {
        return _formKey
    }
    
    init(serviceLabel: String, interest: Int)
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
        
        if let interest = formData["interest"] as? Int {
            self._interest = interest
        }
        
        _formRef = DataService.ds.REF_FORMS.child(_formKey)
    }
}
