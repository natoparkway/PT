//
//  PatientWorkingOutViewController.swift
//  PT_Helper
//
//  Created by Nathaniel Okun on 5/11/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit
import MobileCoreServices
import MediaPlayer
import Foundation
import AVFoundation
import AVKit

protocol ExerciseFinishedDelegate {
    func exerciseFinished()
}

class PatientWorkingOutViewController: UIViewController {

    @IBOutlet weak var exerciseNameLabel: UILabel!
    
    @IBOutlet weak var videoImageView: UIImageView!
    var exercise: PFObject!
    var elapsedTime: Double = 0.0
    var numReps: Int?
    var duration: Double?
    var isDuration: Bool = true
    var setsToComplete: Int!
    
    //constant representing number of random images to cycle through
    let workoutImages = ["gym1", "gym2", "gym3", "gym4"]
    
    //Indicates whether this exercise is a standalone (and then goes to a congratulations view)
    //or tells a container view to switch to the next exercise
    var partOfFullWorkout = false
    
    var timer: NSTimer!
    let timerWidth: CGFloat = 10.0
    var setsCompleted: Int = 0
    var timerIsRunning = false
    let timerColor: UIColor = UIColor.greenColor()
    let congratsSegue = "ToCongratulationsView"
    
    var delegate: ExerciseFinishedDelegate?
    

    @IBOutlet weak var sceneButton: UIButton!
    @IBOutlet weak var timerView: KAProgressLabel!
    @IBOutlet weak var setsCompletedView: CircleWithTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseNameLabel.text = exercise["name"] as? String
        isDuration = exercise["isDuration"] as! Bool
//        isDuration = false //Uncomment this for debugging faster so you don't have to wait for timer
        setsToComplete = (exercise["numSets"] as! NSString).integerValue
        
        if isDuration {
            duration = (exercise["duration"] as! NSString).doubleValue
            setUpTimer()
        } else {
            numReps = (exercise["numRepetitions"] as! NSString).integerValue
            setUpRepsView()
        }
        if(exercise["video"] != nil){
            var videoFile = exercise["video"] as! PFFile
            
            
            let videoURL = NSURL(string: videoFile.url!)!
            
            var player = AVPlayer(URL: videoURL)
            let playerController = AVPlayerViewController()
            playerController.player = player
            self.addChildViewController(playerController)
            self.view.addSubview(playerController.view)
            playerController.view.frame = videoImageView.frame
            player.play()
        }
        else{
           let index = arc4random_uniform(UInt32(workoutImages.count))
            videoImageView.image = UIImage(named: workoutImages[Int(index)])
            videoImageView.contentMode = UIViewContentMode.ScaleAspectFit
        }
        updateSetsCompleted()
    }
    
    //Adds a view that displays the number of reps completed. Also removes timerView
    func setUpRepsView() {
        let frame = self.timerView.frame
        let width = self.timerView.frame.width
        let height = self.timerView.frame.height
        let constraints = self.timerView.constraints()
        timerView.removeFromSuperview() //Remove timer
        
        //Add reps counter
        var repsCircleView = CircleWithTextView(frame: frame)
        repsCircleView.updateCounter((exercise["numRepetitions"] as! String).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
        repsCircleView.setFont(UIFont.boldSystemFontOfSize(36.0))
        view.addSubview(repsCircleView)
        
        //Change button text
        sceneButton.setTitle("Finished Set", forState: nil)
    }
    
    //Start button clicked
    @IBAction func startButtonClicked(sender: AnyObject) {
        if isDuration && !timerIsRunning {
            startTimer()
        } else if !isDuration {
            setsCompleted++
            ifDonePerformSegue()
            updateSetsCompleted()
        }
    }
    
    //Sets up and starts the timer
    func startTimer() {
        //Resets progress view and timer
        resetStats()
        timerIsRunning = true
        
        //Schedules a timer that updates every 0.1 seconds
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    //Resets the necessary properties for the timerView and elapsed time
    func resetStats() {
        timerView.progress = CGFloat(0)
        elapsedTime = 0.0
    }
    
    //Increments the setsCompletedView label by 1
    func updateSetsCompleted() {
        setsCompletedView.updateCounter(String(setsToComplete - setsCompleted))
    }
    
    //Specifies the physical attributes of the timer
    func setUpTimer() {
        timerView.fillColor = UIColor.clearColor()
        timerView.trackColor = UIColor.clearColor()
        timerView.progressColor = timerColor
        timerView.progress = CGFloat(1.0)
        timerView.trackWidth = timerWidth
        timerView.progressWidth = timerWidth
        timerView.roundedCornersWidth = timerWidth
        timerView.text = "Ready?"
    }
    
    //Called whenever the timer "ticks"
    func update() {
        timerView.progress = CGFloat(elapsedTime / duration!)
        
        timerView.text = String(format: "%.1f", duration! - elapsedTime)

        elapsedTime += 0.1
        if elapsedTime > duration {
            timerView.progress = CGFloat(1.0)
            timer.invalidate()
            timerView.text = "Way To Go!"
            setsCompleted++
            updateSetsCompleted()   //Updates GUI
            timerIsRunning = false
            ifDonePerformSegue()
        }
    }
    
    //If the patient has completed the specified amount of exercise, segue
    //If this exercise is part of the full workout, tell the container view that the exercise has finished
    func ifDonePerformSegue() {
        if setsCompleted == setsToComplete {
            if partOfFullWorkout {
                delegate?.exerciseFinished()
            } else {
               performSegueWithIdentifier("ToCongratulationsView", sender: self)
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let id = segue.identifier {
            if id == congratsSegue {
                var congratsVC = segue.destinationViewController as! PatientCongratulationsViewController
                congratsVC.setsCompleted = setsCompleted
                congratsVC.isDuration = isDuration
                congratsVC.exerciseName = exercise["name"] as! String
                
                if isDuration {
                    congratsVC.repsOrSecondsDone = Int(duration!)
                } else {
                    congratsVC.repsOrSecondsDone = numReps
                }
                
            }
        }
    }
    

}
