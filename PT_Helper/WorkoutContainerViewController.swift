//
//  WorkoutContainerViewController.swift
//  PT_Helper
//
//  Created by Nathaniel Okun on 5/17/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class WorkoutContainerViewController: UIViewController, ExerciseFinishedDelegate {

    @IBOutlet weak var currentExerciseView: UIView!
    var exerciseIndex = 0
    var exercises: [PFObject] = []
    
    var workingOutViewController: PatientWorkingOutViewController? {
        didSet {
            workingOutViewController!.exercise = exercises[exerciseIndex]
            workingOutViewController!.view.frame = currentExerciseView.bounds
            

            
            //Set fields
            workingOutViewController!.delegate = self
            workingOutViewController!.partOfFullWorkout = true
            
            //Remove all current subviews
            for subview in currentExerciseView.subviews {
                subview.removeFromSuperview()
            }
            
            //Place off screen initially
            currentExerciseView.frame.origin = CGPoint(x: currentExerciseView.frame.width, y: 0)
            currentExerciseView.addSubview(workingOutViewController!.view)
            
            animateTransition(currentExerciseView)
            exerciseIndex++
        }

    }

    func animateTransition(view: UIView) {
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: nil, animations: { () -> Void in
            
            view.frame.origin = CGPoint(x: 0, y: 0)
            
            }) { (finished: Bool) -> Void in
            println("done")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        workingOutViewController = storyboard!.instantiateViewControllerWithIdentifier("WorkoutViewController") as?PatientWorkingOutViewController
        
        // Do any additional setup after loading the view.
    }
    
    //Delegate method - called when an exercise finishes
    func exerciseFinished() {
        setNewExerciseView()
    }
    
    func setNewExerciseView() {
        workingOutViewController = storyboard!.instantiateViewControllerWithIdentifier("WorkoutViewController") as?PatientWorkingOutViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
