//
//  Util.swift
//  PT_Helper
//
//  Created by Sherman Leung on 5/15/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import Foundation

var _currentUser: PFObject?
class Util {
  class func currentPhysician() -> PFObject? {
    if let curPhysician = PFUser.currentUser()?["physician"] as? PFObject {
      return curPhysician
    }
    return nil
  }
  
  class func currentPatient() -> PFObject? {
    if let curPatient = PFUser.currentUser()?["patient"] as? PFObject {
      return curPatient
    }
    return nil
  }
  
  class func getNameFromExercise(exercise: PFObject)->String
  {
    let template = exercise["template"] as! PFObject
    return template["name"] as! String
  }
  
  class func getVideoFromExercise(exercise: PFObject)->PFFile?
  {
    let template = exercise["template"] as! PFObject
    return template["video"] as? PFFile
  }
}