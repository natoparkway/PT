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
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
