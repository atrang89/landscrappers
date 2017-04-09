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
    private let _formRef: FIRDatabaseReference!
    
    var serviceLabel: String
    {
        return _serviceLabel
    }
    
    var formKey: String
    {
        return _formKey
    }
    
    var formRef: FIRDatabaseReference
    {
        return _formRef
    }
//    
//    init(key: String, service: String)
//    {
//        self._formKey = key
//        self._serviceLabel = service
//        self._formRef = nil
//    }
    
//    Get Firebase data and use in MyFormVC
    init(formKey: String, formData: [String: AnyObject], snapshot: FIRDataSnapshot) {
        
        self._formKey = formKey
        
        if let serviceLabel = formData["services"] as? String {
            self._serviceLabel = serviceLabel
        }
        
        _formRef = snapshot.ref
    }
    
//    init(snapshot: FIRDataSnapshot) {
//        _formKey = snapshot.key
//        let snapshotValue = snapshot.value as? Dictionary<String, AnyObject>
//        _serviceLabel = snapshotValue?["services"] as! String
//        _formRef = snapshot.ref
//    }
    
    func adjustService(sendingTo: Dictionary<String,FormData>)
    {
        let sr: Dictionary<String, AnyObject> = ["serviceInterest": sendingTo.keys as AnyObject]
        DataService.ds.REF_SERVICE.child("Request").childByAutoId().setValue(sr)
    }
//
//    func toAnyObject() -> Any {
//        return ["services": _serviceLabel]
//    }
}
