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
    private var _state: String!
    private var _zip: String!
    
    var street: String {
        return _street
    }
    
    var city: String {
        return _city
    }
    
    var state: String {
        return _state
    }
    
    var zip: String {
        return _zip
    }
    
    var address: String {
        return "\(_street!) \(_city!) \(state) \(zip)"
    }
    
    init(street: String, city: String, state: String, zip: String) {
        self._street = street
        self._city = city
        self._state = state
        self._zip = zip
    }
}
