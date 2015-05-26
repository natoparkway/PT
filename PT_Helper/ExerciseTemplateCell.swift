//
//  ExerciseTemplateCell.swift
//  PT_Helper
//
//  Created by Sherman Leung on 5/24/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class ExerciseTemplateCell: UITableViewCell {

  @IBOutlet var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
      nameLabel.preferredMaxLayoutWidth = nameLabel.frame.width
        // Initialization code
    }
  
  override func layoutSubviews() {
    nameLabel.preferredMaxLayoutWidth = nameLabel.frame.width
  }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
