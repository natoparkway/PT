//
//  Util.swift
//  PT_Helper
//
//  Created by Sherman Leung on 5/15/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import Foundation

public class Util {
  func currentPhysician() -> PFObject {
    let curPhysician = PFUser.currentUser()!["physician"]
    return curPhysician as! PFObject
  }
}