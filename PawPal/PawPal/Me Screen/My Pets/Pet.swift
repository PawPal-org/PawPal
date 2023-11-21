//
//  Pet.swift
//  PawPal
//
//  Created by Cynthia Zhang on 11/20/23.
//

import Foundation

struct Pet{
    var name: String?
    var sex: String?
    var age: String?
    var weight: String?
    
    init(name: String? = nil, sex: String? = nil, age: String? = nil, weight: String? = nil) {
        self.name = name
        self.sex = sex
        self.age = age
        self.weight = weight
    }
    
}
