//
//  Exercise.swift
//  PT_Helper
//
//  Created by Nathaniel Okun on 5/11/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class Exercise: NSObject {
    var name: String?
    var exerciseDescription: String?
    var numRepetitions: Int?
    var duration: Int?
    var daysPerWeek: Int?
    
    init(dictionary: NSDictionary) {
        println("called")
        exerciseDescription = dictionary["exerciseDescription"] as? String
        name = dictionary["name"] as? String
        numRepetitions = dictionary["numRepetitions"] as? Int
        duration = dictionary["duration"] as? Int
        daysPerWeek = dictionary["daysPerWeek"] as? Int
    
    }
    
    func print() {

    }
}
