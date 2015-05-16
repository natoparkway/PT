//
//  PatientWorkingOutViewController.swift
//  PT_Helper
//
//  Created by Nathaniel Okun on 5/11/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class PatientWorkingOutViewController: UIViewController {

    var elapsedTime: Double = 0.0
    let duration: Double = 3.0
    var timer: NSTimer!
    let timerWidth: CGFloat = 10.0
    var setsCompleted: Int = 0
    let setsToComplete: Int = 1
    let timerColor: UIColor = UIColor.greenColor()
    @IBOutlet weak var timerView: KAProgressLabel!
    @IBOutlet weak var setsCompletedView: CircleWithTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTimer()
        updateSetsCompleted()
    }
    
    //Start button clicked
    @IBAction func startButtonClicked(sender: AnyObject) {
        startTimer()
    }
    
    //Sets up and starts the timer
    func startTimer() {
        //Resets progress view and timer
        resetStats()
        
        //Schedules a timer that updates every 0.1 seconds
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    //Resets the necessary properties for the timerView and elapsed time
    func resetStats() {
        timerView.progress = CGFloat(0)
        timerView.progressColor = timerColor
        elapsedTime = 0.0
    }
    
    //Increments the setsCompletedView label by 1
    func updateSetsCompleted() {
        setsCompletedView.updateCounter(String(setsCompleted))
    }
    
    //Specifies the physical attributes of the timer
    func setUpTimer() {
        timerView.fillColor = UIColor.clearColor()
        timerView.trackColor = UIColor.clearColor()
        timerView.progressColor = UIColor.clearColor()
        timerView.trackWidth = timerWidth
        timerView.progressWidth = timerWidth
        timerView.roundedCornersWidth = timerWidth
    }
    
    //Called whenever the timer "ticks"
    func update() {
        timerView.progress = CGFloat(elapsedTime / duration)
        
        timerView.text = String(format: "%.1f", duration - elapsedTime)

        elapsedTime += 0.1
        if elapsedTime > duration {
            timerView.progress = CGFloat(1.0)
            timer.invalidate()
            timerView.text = "Way To Go!"
            setsCompleted++
            updateSetsCompleted()
            if setsCompleted == setsToComplete {
                performSegueWithIdentifier("ToCongratulationsView", sender: self)
            }
        }
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
