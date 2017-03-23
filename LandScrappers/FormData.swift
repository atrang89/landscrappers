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
    private var _myLocation: String!
    private var _formKey: String!
    private var _formRef: FIRDatabaseReference!
    
    var serviceLabel: String
    {
        return _serviceLabel
    }
    
    var myLocation: String
    {
        return _myLocation
    }
    
    var formKey: String
    {
        return _formKey
    }
    
    init(serviceLabel: String, myLocation: String)
    {
        self._serviceLabel = serviceLabel
        self._myLocation = myLocation
    }
    
    //Get Firebase data and use in MyFormVC
    init(formKey: String!, formData: Dictionary<String, AnyObject>) {
        
        self._formKey = formKey
        
        if let serviceLabel = formData["services"] as? String {
            self._serviceLabel = serviceLabel
        }
        
        _formRef = DataService.ds.REF_SERVICE.child(_formKey)
    }
    
    func adjustService(sendingTo: Dictionary<String,FormData>)
    {
        var uids = [String]()
        for uid in sendingTo.keys {
            uids.append(uid)
        }
        
        let sr: Dictionary<String, AnyObject> = ["serviceInterest": uids as AnyObject]
        DataService.ds.REF_SERVICE.child("Request").childByAutoId().setValue(sr)
    }
}
