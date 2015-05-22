//
//  PatientHomeViewController.swift
//  PT_Helper
//
//  Created by Nathaniel Okun on 5/21/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class PatientHomeViewController: UIViewController {

    let transitionManager = SlideTransitionDelegate()
    var patientLoggedIn = false
    var exercises: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func workoutButtonClicked(sender: AnyObject) {
        performSegueWithIdentifier("ToWorkout", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier {
            if id == "ToWorkout" {
                var workoutVC = segue.destinationViewController as! WorkoutContainerViewController
                workoutVC.modalPresentationStyle = .Custom
                workoutVC.transitioningDelegate = transitionManager
                workoutVC.exercises = exercises
            }
        }
    }


}
