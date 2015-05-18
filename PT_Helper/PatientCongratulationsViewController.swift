//
//  PatientCongratulationsViewController.swift
//  PT_Helper
//
//  Created by Nathaniel Okun on 5/15/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit
import Darwin


class PatientCongratulationsViewController: UIViewController {

    
    @IBOutlet weak var setsCircleView: CircleWithTextView!
    @IBOutlet weak var repsCircleView: CircleWithTextView!
    @IBOutlet weak var repsOrSecondsLabel: UILabel!
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!

    
    var isDuration = false          //Is the exercise duration based?
    var repsOrSecondsDone: Int!
    var setsCompleted: Int!
    var exerciseName: String!
    
    var partOfFullWorkout = false   //Has the user clicked to do a full workout or just a single exercise
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCircleViews()
        exerciseNameLabel.text = exerciseName
        
        if isDuration {
            repsOrSecondsLabel.text = "Seconds"
        }
        
        //If this is part of the full workout, we want the button to say "Next"
        if partOfFullWorkout {
            nextButton.setTitle("Next", forState: nil)
        }
        
    }
    
    func updateCircleViews() {
        repsCircleView.updateCounter(String(repsOrSecondsDone))
        setsCircleView.updateCounter(String(setsCompleted))
        repsCircleView.setFont(UIFont.boldSystemFontOfSize(24.0))
        setsCircleView.setFont(UIFont.boldSystemFontOfSize(24.0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnToExerciseClicked(sender: AnyObject) {
        performSegueWithIdentifier("BackToExerciseList", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
