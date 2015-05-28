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

    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var progressBar: YLProgressBar!
    
    let transitionManager = SlideTransitionDelegate()
    var patientLoggedIn = false
    var exercises: [PFObject] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProgressBar()
        // Do any additional setup after loading the view.
        var user = PFUser.currentUser()?["patient"] as! PFObject
        var wUntilAppt = user["workoutsUntilAppointment"] as! Int
        progressLabel.preferredMaxLayoutWidth = progressLabel.frame.width
        
        if wUntilAppt < 0 {
            wUntilAppt = 0
        }
        
        println("View did load")
        
        progressLabel.text = "\(wUntilAppt) workouts until your next appointment"
        
    }
    
    
    func setUpProgressBar() {
        progressBar.progressTintColor = greenColor
        progressBar.hideStripes = true
        progressBar.type = YLProgressBarType.Flat
        var user = PFUser.currentUser()?["patient"] as! PFObject
        var progress = (user["totalWorkouts"] as! Int ) - (user["workoutsUntilAppointment"] as! Int)
        progressBar.progress = CGFloat(progress) / (user["totalWorkouts"] as! CGFloat)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }
    
  @IBAction func onLogout(sender: UIBarButtonItem) {
    PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
      if (error == nil) {
        self.dismissViewControllerAnimated(true, completion: nil)
      }
    }
  }
    //Delegate method
    func workOutFinished() {
        var user = PFUser.currentUser()?["patient"] as! PFObject
        var wUntilAppt = (user["workoutsUntilAppointment"] as! Int) - 1
        println("wUntilAppt is \(wUntilAppt)")
        progressBar.progress += (1 / (user["totalWorkouts"] as! CGFloat))
        
        if wUntilAppt < 0 {
            wUntilAppt = 0
        }
        
        user["workoutsUntilAppointment"] = wUntilAppt
        user.save()
        if( wUntilAppt > 0 ){
            progressLabel.text = "Only \(wUntilAppt) workouts until your next appointment"
        }
        else{
            progressLabel.text = "You are ready to see your physical therapist"
        }
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
