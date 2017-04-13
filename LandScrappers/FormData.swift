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
    private var _checkMark: Bool!
    private var _formKey: String!
    private let _formRef: FIRDatabaseReference!
    private let _interestRef: FIRDatabaseReference!
    
    var serviceLabel: String
    {
        return _serviceLabel
    }
    
    var checkMark: Bool
    {
        return _checkMark
    }
    
    var formKey: String
    {
        return _formKey
    }
    
    var formRef: FIRDatabaseReference
    {
        return _formRef
    }
    
    var interestRef: FIRDatabaseReference
    {
        return _interestRef
    }
    
//    Get Firebase data and use in MyFormVC
    init(formKey: String, formData: [String: AnyObject], snapshot: FIRDataSnapshot) {
        
        self._formKey = formKey
        
        if let serviceLabel = formData["services"] as? String {
            self._serviceLabel = serviceLabel
        }
        
        if let checkMark = formData["completed"] as? Bool
        {
            self._checkMark = checkMark
        }
        
        _formRef = snapshot.ref
        //Test this out
        _interestRef = DataService.ds.REF_SERVICE.child(_formKey)
    }
    
    func serviceRequest(toID: String, refCell: String, requestedUID: String)
    {
        let ref: Dictionary<String, AnyObject> = [requestedUID: true as AnyObject]
        
        DataService.ds.REF_SERVICE.child(toID).child(refCell).child("services").childByAutoId().setValue(ref)
    }
    
    func adjustService(senderUID: String)
    {
        let sr: Dictionary<String, AnyObject> = ["serviceInterest": senderUID as AnyObject]
        DataService.ds.REF_SERVICE.child("request").childByAutoId().setValue(sr)
    }
}
