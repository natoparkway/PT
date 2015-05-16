//
//  Util.swift
//  PT_Helper
//
//  Created by Sherman Leung on 5/15/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import Foundation

class Util {
  class func currentPhysician() -> PFObject? {
    if let curPhysician = PFUser.currentUser()?["physician"] as? PFObject {
      curPhysician.fetch()
      return curPhysician
    }
    return nil
  }
  
  class func currentPatient() -> PFObject? {
    if let curPatient = PFUser.currentUser()?["patient"] as? PFObject {
      curPatient.fetch()
      return curPatient
    }
    return nil
  }
}