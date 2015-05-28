//
//  ExerciseCell.swift
//  PT_Helper
//
//  Created by Nathaniel Okun on 5/10/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class ExerciseCell: UITableViewCell {

    @IBOutlet weak var exerciseNameLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        exerciseNameLabel.preferredMaxLayoutWidth = exerciseNameLabel.frame.width
    }
    
    override func layoutSubviews() {
        exerciseNameLabel.preferredMaxLayoutWidth = exerciseNameLabel.frame.width
    }
    
    /*
     * Updates contents of ExerciseCell. Sets exercise global variable and sets cell contents and gui accordingly.
     */
    func setup(e: PFObject) {
        var template = PFObject(className: "ExerciseTemplate")
        template = e["template"] as! PFObject
        template.fetchIfNeeded()
        let name = template["name"] as! String
        exerciseNameLabel.text = name
      
        //We need to remove white space as well
//        daysPerWeekView.updateCounter(daysPerWeek.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
//        repetitionsView.updateCounter(numReps.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
//        setsOrTimeView.updateCounter(duration.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
        exerciseNameLabel.text = name
    }

//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    

}
