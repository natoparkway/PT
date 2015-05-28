//
//  EditExerciseViewController.swift
//  PT_Helper
//
//  Created by Sherman Leung on 5/25/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class EditExerciseViewController: UIViewController {

  var exercise: PFObject = PFObject(className: "Exercise")
  @IBOutlet var numRepsOrDurationLabel: UILabel!
  @IBOutlet var repsOrDurationLabel: UILabel! // this is what says reps or duration under the number itself
  @IBOutlet var videoImageView: UIImageView!
  @IBOutlet var numSetsLabel: UILabel!
  @IBOutlet var exerciseNameLabel: UILabel!
  @IBOutlet var descriptionTextView: UITextView!
  @IBOutlet var isDurationSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        let isDuration = exercise["isDuration"] as! Bool
      if (isDuration) {
        isDurationSwitch.on = true
        let duration = exercise["duration"] as! Int
        numRepsOrDurationLabel.text = "\(duration)"
      } else {
        isDurationSwitch.on = false
        let numReps = exercise["repetitions"] as! Int
        numRepsOrDurationLabel.text = "\(numReps)"
      }
      let numSets = exercise["sets"] as! Int
      numSetsLabel.text = "\(numSets)"
      
      // makes sure that the label is synchronized with the value of isDuration
      switchFlipped(isDurationSwitch)
      descriptionTextView.text = exercise["description"] as! String
        exerciseNameLabel.text = Util.getNameFromExercise(exercise)
      var videoFile = Util.getVideoFromExercise(exercise)
      if (videoFile != nil) {
        setUpVideo(videoFile!)
      }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func saveExercise(sender: UIBarButtonItem) {
    exercise["isDuration"] = isDurationSwitch.on
    if (isDurationSwitch.on) {
      exercise["duration"] = numRepsOrDurationLabel.text!.toInt()
    } else {
      exercise["repetitions"] = numRepsOrDurationLabel.text!.toInt()
    }
    exercise["sets"] = numSetsLabel.text!.toInt()
    exercise["description"] = descriptionTextView.text
    exercise.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
      if (success) {
        // notify physician of the save
        self.navigationController?.popViewControllerAnimated(true)
      }
    }
  }
  @IBAction func onTap(sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }

  @IBAction func switchFlipped(sender: AnyObject) {
    if (isDurationSwitch.on) {
      repsOrDurationLabel.text = "DURATION"
    } else {
      repsOrDurationLabel.text = "REPS"
    }
  }
  
  
  
  func setUpVideo(videoFile: PFFile) {
    let videoURL = NSURL(string: videoFile.url!)!
    var player = AVPlayer(URL: videoURL)
    let playerController = AVPlayerViewController()
    playerController.player = player
    self.addChildViewController(playerController)
    self.view.addSubview(playerController.view)
    playerController.view.frame = CGRect(x: videoImageView.frame.origin.x, y: videoImageView.frame.origin.y, width: videoImageView.frame.width, height: videoImageView.frame.height)
    
  }
  
  
  @IBAction func decreaseRepsDuration(sender: UIButton) {
    var newVal = numRepsOrDurationLabel.text!.toInt()! - 1;
    numRepsOrDurationLabel.text = "\(newVal)"
  }
  @IBAction func increaseRepsDuration(sender: UIButton) {
    var newVal = numRepsOrDurationLabel.text!.toInt()! + 1;
    numRepsOrDurationLabel.text = "\(newVal)"
  }
  
  @IBAction func increaseSets(sender: UIButton) {
    var newVal = numSetsLabel.text!.toInt()! + 1;
    numSetsLabel.text = "\(newVal)"
  }
  
  @IBAction func decreaseSets(sender: UIButton) {
    var newVal = numSetsLabel.text!.toInt()! - 1;
    numSetsLabel.text = "\(newVal)"
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
