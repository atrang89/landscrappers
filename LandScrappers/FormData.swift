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
    private var _formKey: String!
    private var _formRef: FIRDatabaseReference!
    
    var serviceLabel: String
    {
        return _serviceLabel
    }
    
    var formKey: String
    {
        return _formKey
    }
    
    init(serviceLabel: String)
    {
        self._serviceLabel = serviceLabel
    }
    
    //Get Firebase data and use in MyFormVC
    init(formKey: String!, formData: Dictionary<String, AnyObject>) {
        
        self._formKey = formKey
        
        if let serviceLabel = formData["services"] as? String {
            self._serviceLabel = serviceLabel
        }
        
        _formRef = DataService.ds.REF_SERVICE.child(_formKey)
    }
}

class FormRequest: FormData {
    
    private var _selectService: Bool!
    
    var selectService: Bool {
        return _selectService
    }
    
}
