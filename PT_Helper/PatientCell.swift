//
//  PatientCell.swift
//  PT_Helper
//
//  Created by Sherman Leung on 5/14/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class PatientCell: UITableViewCell {

  @IBOutlet var ageGenderLabel: UILabel!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var injuryLabel: UILabel!
  @IBOutlet var profileImage: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func setup(patient: PFObject) {
    let firstName = patient["first_name"] as! String
    let lastName = patient["last_name"] as! String
    let injury = patient["injury"] as! String
    let age = patient["age"] as! Int
    let url = patient["profileImageUrl"] as? String
    if (url == nil) {
      profileImage.image = UIImage(named: "patient")
    } else {
      profileImage.setImageWithURL(NSURL(string: url!)!)
    }
    let gender = patient["gender"] as! String
    nameLabel.text = firstName + " " + lastName
    injuryLabel.text = injury
    ageGenderLabel.text = "\(age)yo " + gender
  }

}
