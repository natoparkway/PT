//
//  WorkoutContainerViewController.swift
//  PT_Helper
//
//  Created by Nathaniel Okun on 5/17/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

protocol WorkoutFinishedDelegate {
    func workOutFinished()
}

class WorkoutContainerViewController: UIViewController, ExerciseFinishedDelegate {

    var delegate: WorkoutFinishedDelegate?
    @IBOutlet weak var currentExerciseView: UIView!
    var exerciseIndex = 0
    var exercises: [PFObject] = []
    let iphoneWidth = 320
    
    var workingOutNavController: UINavigationController? {
        didSet {
            var workingOutViewController = workingOutNavController?.topViewController as! PatientWorkingOutViewController
            println("\(exercises)")
            println("\(exerciseIndex)")
            if exercises.count > 0 {
            workingOutViewController.exercise = exercises[exerciseIndex]
                workingOutNavController!.view.frame = currentExerciseView.bounds
            }
            
            //Set fields
            workingOutViewController.delegate = self
            workingOutViewController.partOfFullWorkout = true
            
            //Remove all current subviews
            for subview in currentExerciseView.subviews {
                subview.removeFromSuperview()
            }
            
            //Place off screen initially
            currentExerciseView.frame.origin = CGPoint(x: CGFloat(iphoneWidth), y: 0)
            currentExerciseView.addSubview(workingOutNavController!.view)
            
            animateTransition(currentExerciseView)
            exerciseIndex++
        }

    }

    func animateTransition(view: UIView) {
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            view.frame.origin = CGPoint(x: 0, y: 0)
        }) { (finished) -> Void in
            //Do something
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNewExerciseView()
        
        // Do any additional setup after loading the view.
    }
    
    //Delegate method - called when an exercise finishes
    func exerciseFinished(earlyExit: Bool) {
        if exercises.count == exerciseIndex || earlyExit {
            delegate?.workOutFinished()
            dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        setNewExerciseView()
    }
    
    func setNewExerciseView() {
        workingOutNavController = storyboard!.instantiateViewControllerWithIdentifier("WorkoutViewNav") as? UINavigationController
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
