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
    @IBOutlet weak var numRepsLabel: UILabel!
    @IBOutlet weak var numSetsLabel: UILabel!
    @IBOutlet weak var numDegreesLabel: UILabel!
    @IBOutlet weak var daysPerWeekView: CircleWithTextView!
    @IBOutlet weak var repetitionsView: CircleWithTextView!
    @IBOutlet weak var setsOrTimeView: CircleWithTextView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /*
     * Updates contents of ExerciseCell. Sets exercise global variable and sets cell contents and gui accordingly.
     */
    func setup(e: PFObject) {
        var template = PFObject(className: "ExerciseTemplate")
        template = e["template"] as! PFObject
        let name = template["name"] as! String
        let numDegrees = e["degrees"] as! Int
        numDegreesLabel.text = "\(numDegrees)"
      
        let numReps = e["repetitions"] as! Int
        numRepsLabel.text = "\(numReps)"
      
      
        let numSets = e["sets"] as! Int
        numSetsLabel.text = "\(numSets)"
      
        //We need to remove white space as well
//        daysPerWeekView.updateCounter(daysPerWeek.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
//        repetitionsView.updateCounter(numReps.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
//        setsOrTimeView.updateCounter(duration.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
        exerciseNameLabel.text = name
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
