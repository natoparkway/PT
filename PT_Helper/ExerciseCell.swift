//
//  ExerciseCell.swift
//  PT_Helper
//
//  Created by Nathaniel Okun on 5/10/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class ExerciseCell: UITableViewCell {

    @IBOutlet weak var exerciseImage: UIImageView!
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var repetitionsLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var daysPerWeekLabel: UILabel!
    
    var exercise: Exercise!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /*
     * Updates contents of ExerciseCell. Sets exercise global variable and sets cell contents and gui accordingly.
     */
    func updateContents(exerciseData: Exercise) {
        exercise = exerciseData
        exerciseNameLabel.text = exercise.name
        repetitionsLabel.text = String(exercise.numRepetitions!) + "x"
        durationLabel.text = String(exercise.duration!) + "s"
        daysPerWeekLabel.text = String(exercise.daysPerWeek!) + " days per week"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
