//
//  PatientHomeViewController.swift
//  PT_Helper
//
//  Created by Nathaniel Okun on 5/21/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class PatientHomeViewController: UIViewController, WorkoutFinishedDelegate {

    let greenColor = UIColor(red: 115/255, green: 255/255, blue: 171/255, alpha: 1.0)
    let redColor = UIColor(red: 255/255, green: 94/255, blue: 69/255, alpha: 1.0)

    
    @IBOutlet weak var progressBar: YLProgressBar!
    
    let transitionManager = SlideTransitionDelegate()
    var patientLoggedIn = false
    var exercises: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProgressBar()
        // Do any additional setup after loading the view.
    }
    
    func setUpProgressBar() {
        progressBar.progressTintColor = greenColor
        progressBar.hideStripes = true
        progressBar.type = YLProgressBarType.Flat
        progressBar.progress = 0.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }
    
    //Delegate method
    func workOutFinished() {
        progressBar.progress += 1/3
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
                workoutVC.delegate = self
            }
        }
    }


}
