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
    func exerciseFinished(earlyExit: Bool)
}

class PatientWorkingOutViewController: UIViewController {


  
    @IBOutlet weak var repetitionsOrSecondsLabel: UILabel!
    @IBOutlet weak var countersContainerView: UIView!
    @IBOutlet weak var exerciseDescription: UILabel!
    @IBOutlet weak var videoImageView: UIImageView!
    var exercise: PFObject!
    var elapsedTime: Double = 0.0
    var numReps: Int?
    var duration: Double?
    var isDuration: Bool = true
    var setsToComplete: Int!
    var font = UIFont.boldSystemFontOfSize(24.0)
    var videoCentered = true
    let videoOffScreenPos: CGFloat = 40 //Minimum amount of the video showing in the screen
    let minimumDistToSnap: CGFloat = 120 //Minimum distance the screen has to be moved before we snap it
    var videoView: UIView!

    //constant representing number of random images to cycle through
    let workoutImages = ["gym1", "gym2", "gym3", "gym4"]

    //Indicates whether this exercise is a standalone (and then goes to a congratulations view)
    //or tells a container view to switch to the next exercise
    var partOfFullWorkout = false

    var timer: NSTimer!
    let timerWidth: CGFloat = 10.0
    var setsCompleted: Int = 0
    var timerIsRunning = false
    var timerColor: UIColor = UIColor.greenColor()  //Default color

    var delegate: ExerciseFinishedDelegate?

    @IBOutlet weak var timerView: KAProgressLabel!
    var repsCircleView: CircleWithTextView!
    @IBOutlet weak var setsCompletedView: CircleWithTextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        videoView = videoImageView
        allowWrapAroundForLabels()

        exerciseDescription.text = exercise["description"] as? String
        navigationItem.title = Util.getNameFromExercise(exercise)
        setsToComplete = exercise["sets"] as! Int

        isDuration = exercise["isDuration"] as! Bool
        if isDuration {
            repetitionsOrSecondsLabel.text = "Seconds"
        }
        
        addSetCounter() //Either sets up timer or adds rep counter

        var videoFile = Util.getVideoFromExercise(exercise)
        if(videoFile != nil){
            setUpVideo(videoFile!)
        } else {
            removeVideoAndDisplayDescription()
        }

        updateSetsCompleted()
    }


    /*
    * Allows labels to wrap around by setting preferred max width.
    */
    func allowWrapAroundForLabels() {
        exerciseDescription.preferredMaxLayoutWidth = exerciseDescription.frame.width
    }

    /*
     * Adds relevant exercise counter to the middle of the screen.
     * If the exercise is duration based, adds a timer.
     * If the exercise is repetition based, it adds a counter and changes the bottom button.
     */
    func addSetCounter() {
        if isDuration {
            duration = exercise["duration"] as? Double
            setUpTimer()
        } else {
            numReps = exercise["repetitions"] as? Int
            setUpRepsView()
        }
    }


    /*
     * Removes the UIImageView containing the video and instead displays the exercise description.
     */
    func removeVideoAndDisplayDescription() {
        let index = arc4random_uniform(UInt32(workoutImages.count))
        videoImageView.image = UIImage(named: workoutImages[Int(index)])
        videoImageView.contentMode = UIViewContentMode.ScaleToFill
        addPanGestureRecognizer(videoImageView)
    }

    /*
     * Displays exercise video on screen.
     */
  func setUpVideo(videoFile: PFFile) {
        let videoURL = NSURL(string: videoFile.url!)!

        var player = AVPlayer(URL: videoURL)
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.addChildViewController(playerController)
        self.view.addSubview(playerController.view)
        playerController.view.frame = CGRect(x: videoImageView.frame.origin.x, y: videoImageView.frame.origin.y + 64, width: videoImageView.frame.width, height: videoImageView.frame.height)

        addPanGestureRecognizer(playerController.view)
    }

    func addPanGestureRecognizer(view: UIView) {
        var panGesture = UIPanGestureRecognizer(target: self, action: "videoPanned:")
        videoView = view
        view.addGestureRecognizer(panGesture)
    }


    func videoPanned(sender: UIPanGestureRecognizer) {
        var velocity = sender.velocityInView(view)
        var isMovingRight = velocity.x > 0

        if sender.state == UIGestureRecognizerState.Began {

        } else if sender.state == UIGestureRecognizerState.Changed {
            animateImageView(isMovingRight, translation: sender.translationInView(view))

        } else if sender.state == UIGestureRecognizerState.Ended {
            snapVideoViewToPosition(isMovingRight, translation: sender.translationInView(view))
        }

        sender.setTranslation(CGPointZero, inView: view)

    }

    func snapVideoViewToPosition(isMovingRight: Bool, translation: CGPoint) {
        var movedEnoughRight = self.videoView.frame.origin.x > minimumDistToSnap
        var movedEnoughLeft = self.videoView.frame.origin.x < view.frame.width - minimumDistToSnap

        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: nil, animations: { () -> Void in

            if(isMovingRight && movedEnoughRight) {
                self.videoView.center.x = self.view.frame.width - self.videoOffScreenPos + self.videoView.frame.width / 2
            } else if(!isMovingRight && movedEnoughLeft) {
                self.videoView.center.x = self.view.center.x
            } else if isMovingRight {
                self.videoView.center.x = self.view.center.x
            } else {
                self.videoView.center.x = self.view.frame.width - self.videoOffScreenPos + self.videoView.frame.width / 2
            }

        }) { (finished) -> Void in

        }
    }

    func animateImageView(isMovingRight: Bool, translation: CGPoint) {
        var scale = CGFloat(1.0)
        if shouldBeSlow(isMovingRight) {
            scale = 0.1
        }

        videoView.center.x += scale * translation.x

    }

    func shouldBeSlow(isMovingRight: Bool) -> Bool {
        //If we have moved off the left edge of the screen and are moving left
        var condition1 = videoView.center.x < view.center.x && !isMovingRight

        //If we have reached the furthest point on screen we allow the video to go and are moving right
        var condition2 = videoView.frame.origin.x > view.frame.width - videoOffScreenPos && isMovingRight

        return condition1 || condition2
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        delegate?.exerciseFinished(true)
    }
    
    
    //Adds a view that displays the number of reps completed. Also removes timerView
    func setUpRepsView() {
        let frame = self.timerView.frame
        let width = self.timerView.frame.width
        let height = self.timerView.frame.height
        let constraints = self.timerView.constraints()

        //Add reps counter
        repsCircleView = CircleWithTextView(frame: frame)
        let numReps = exercise["repetitions"] as! Int
        repsCircleView.updateCounter("\(numReps)".stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
        repsCircleView.setFont(font)
        repsCircleView.circularView.layer.borderWidth = timerWidth
//        repsCircleView.addConstraints(timerView.constraints())
        
        timerView.removeFromSuperview() //Remove timer

        //Add gesture recognizer
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "counterTapped:")
        repsCircleView.addGestureRecognizer(tapGestureRecognizer)

        //Add subview
        countersContainerView.addSubview(repsCircleView)
    }

    @IBAction func counterTapped(sender: AnyObject) {
        if isDuration {

            if !timerIsRunning {
                startTimer()
            } else {
                stopTimer()
            }

        } else if !isDuration {
            setsCompleted++
            animateRepsView()
            ifDonePerformSegue()
            updateSetsCompleted()
        }
    }

    //Stops the timer, but does not reset the timing values.
    func stopTimer() {
        //animateTimer(true)
        timerIsRunning = false
        timer.invalidate()
    }

    //Sets up and starts the timer
    func startTimer() {
        //animateTimer(false)
        //Resets progress view and timer
        timerIsRunning = true

        //Schedules a timer that updates every 0.1 seconds
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }

    func animateRepsView() {
        var scale: CGFloat = 1.1

        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.repsCircleView.transform = CGAffineTransformScale(self.repsCircleView.transform, scale, scale)
            }) { (finished) -> Void in
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.repsCircleView.transform = CGAffineTransformScale(self.repsCircleView.transform, 1 / scale, 1 / scale)
                })
        }

    }

    //Resets the necessary properties for the timerView and elapsed time
    func resetStats() {
        timerView.progress = CGFloat(1.0)
        timerView.text = String(format:"%.1f", duration!)
        elapsedTime = 0.0
    }

    //Increments the setsCompletedView label by 1
    func updateSetsCompleted() {
        setsCompletedView.updateCounter(String(setsToComplete - setsCompleted))
    }

    //Specifies the physical attributes of the timer
    func setUpTimer() {
        if let color = timerView.backgroundColor {
            timerColor = color
        }
        timerView.fillColor = UIColor.clearColor()
        timerView.backgroundColor = UIColor.clearColor()
        timerView.trackColor = UIColor.clearColor()
        timerView.progressColor = timerColor
        timerView.progress = CGFloat(1.0)
        timerView.trackWidth = timerWidth
        timerView.progressWidth = timerWidth
        timerView.roundedCornersWidth = timerWidth
        timerView.text = String(format:"%.1f", duration!)
        timerView.font = font
    }

    //Called whenever the timer "ticks"
    func update() {
        timerView.progress = CGFloat(elapsedTime / duration!)

        timerView.text = String(format: "%.1f", duration! - elapsedTime)

        elapsedTime += 0.1
        if elapsedTime > duration {
            timerView.progress = CGFloat(1.0)
            timer.invalidate()
            setsCompleted++
            updateSetsCompleted()   //Updates GUI
            timerIsRunning = false
            resetStats()
            ifDonePerformSegue()
        }
    }

    //If the patient has completed the specified amount of exercise, segue
    //If this exercise is part of the full workout, tell the container view that the exercise has finished
    func ifDonePerformSegue() {
        if setsCompleted == setsToComplete {
            if partOfFullWorkout {
                delegate?.exerciseFinished(false)
            } else {
                //Dismiss or something
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

        }
    }


}
