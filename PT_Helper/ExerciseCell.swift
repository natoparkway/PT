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
    @IBOutlet weak var repetitionsLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var daysPerWeekLabel: UILabel!
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
        let daysPerWeek = e["timesPerWeek"] as! String
        let numReps = e["numRepetitions"] as! String
        let duration = e["duration"] as! String
        daysPerWeekView.updateCounter(daysPerWeek)
        repetitionsView.updateCounter(numReps)
        setsOrTimeView.updateCounter(duration )
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
