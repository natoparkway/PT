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
    var isDuration = false
    var repsOrSecondsDone: Int!
    var setsCompleted: Int!
    @IBOutlet weak var repsOrSecondsLabel: UILabel!
    @IBOutlet weak var exerciseNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(repsOrSecondsDone)
        repsCircleView.updateCounter(String(repsOrSecondsDone))
        setsCircleView.updateCounter(String(setsCompleted))
        
        if isDuration {
            repsOrSecondsLabel.text = "Seconds"
        }
        
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
