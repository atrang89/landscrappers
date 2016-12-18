//
//  RegisterForm.swift
//  LandScrappers
//
//  Created by Andy Trang on 12/13/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import Foundation

class Person {
    
    private var _street: String!
    private var _city: String!
    private var _address: String!
    
    var street: String {
        get {
            return _street
        }
        set{
            _street = newValue
        }
        
    }
    
    var city: String {
        get {
            return _city
        }
        set{
            _city = newValue
        }
    }
    
    var address: String {
        get{
            return _address
        }
        set{
            _address = newValue
        }
    }
    
    init(street: String, city: String, address: String) {
        self._street = street
        self._city = city
        self._address = address
    }

    
}
