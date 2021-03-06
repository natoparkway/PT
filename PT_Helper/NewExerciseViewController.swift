//
//  NewExerciseViewController.swift
//  PT_Helper
//
//  Created by Sherman Leung on 5/24/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class NewExerciseViewController: UIViewController, IQDropDownTextFieldDelegate, UITextViewDelegate {

  
  @IBAction func onTap(sender: UITapGestureRecognizer) {
    view.endEditing(true)
    templateDropdown.resignFirstResponder()
  }
  
  @IBOutlet var videoImageView: UIImageView!
  @IBOutlet var templateDropdown: IQDropDownTextField!
  @IBOutlet var isDurationSwitch: UISwitch!
  @IBOutlet var numRepsOrDurationLabel: UILabel!
  @IBOutlet var repsOrDurationLabel: UILabel!
  @IBOutlet var numSetsLabel: UILabel!
  @IBOutlet var descriptionTextView: UITextView!
  var exerciseTemplates : [PFObject] = []
  var exerciseTemplatesMap = [String: PFObject]()
  var patient = PFObject(className: "Patient")
  var initialDescription: String = ""
  var exerciseTemplate  = PFObject(className: "ExerciseTemplate")
    override func viewDidLoad() {
        super.viewDidLoad()
        let query = PFQuery(className: "ExerciseTemplate")
      
      // setting the initial placeholder for description
      let firstName = patient["first_name"] as! String
      let lastName = patient["last_name"] as! String
      
      initialDescription = "Write any specific instructions you have for " + firstName + " " + lastName
      descriptionTextView.text = initialDescription
      templateDropdown.delegate = self
      query.findObjectsInBackgroundWithBlock { (result:[AnyObject]?, error: NSError?) -> Void in
        if (error == nil) {
          self.exerciseTemplates = result as! [PFObject]
          var exerciseNames : [String] = []
          for e in self.exerciseTemplates {
            let name = e["name"] as! String
            self.exerciseTemplatesMap[name] = e
            exerciseNames.append(name)
          }
          self.templateDropdown.itemList = exerciseNames
        }
      }
      descriptionTextView.delegate = self
      
        // Do any additional setup after loading the view.
    }
  
  
  @IBAction func decreaseRepsDuration(sender: UIButton) {
    view.endEditing(true)
    templateDropdown.resignFirstResponder()
    var newVal = numRepsOrDurationLabel.text!.toInt()! - 1;
    numRepsOrDurationLabel.text = "\(newVal)"
  }
  @IBAction func increaseRepsDuration(sender: UIButton) {
    view.endEditing(true)
    templateDropdown.resignFirstResponder()
    var newVal = numRepsOrDurationLabel.text!.toInt()! + 1;
    numRepsOrDurationLabel.text = "\(newVal)"
  }
  
  @IBAction func increaseSets(sender: UIButton) {
    view.endEditing(true)
    templateDropdown.resignFirstResponder()
    var newVal = numSetsLabel.text!.toInt()! + 1;
    numSetsLabel.text = "\(newVal)"
  }
  
  @IBAction func decreaseSets(sender: UIButton) {
    view.endEditing(true)
    templateDropdown.resignFirstResponder()
    var newVal = numSetsLabel.text!.toInt()! - 1;
    numSetsLabel.text = "\(newVal)"
  }
  
  @IBAction func switchFlipped(sender: UISwitch) {
    view.endEditing(true)
    templateDropdown.resignFirstResponder()
    if (isDurationSwitch.on) {
      repsOrDurationLabel.text = "SECONDS"
    } else {
      repsOrDurationLabel.text = "REPS"
    }
  }
  @IBAction func saveExercise(sender: AnyObject) {
    var exercise = PFObject(className: "Exercise")
    var templateName = templateDropdown.text
    if (templateName == "") {
      displayMessage("Please select a type of exercise from the dropdown.")
      return
    }
    var exerciseTemplate = exerciseTemplatesMap[templateName]!
    exercise.setObject(exerciseTemplate, forKey: "template")
    exercise["isDuration"] = isDurationSwitch.on
    if (isDurationSwitch.on) {
      exercise["duration"] = numRepsOrDurationLabel.text!.toInt()
    } else {
      exercise["repetitions"] = numRepsOrDurationLabel.text!.toInt()
    }
    exercise["sets"] = numSetsLabel.text!.toInt()
    exercise["patient"] = patient
    exercise["description"] = descriptionTextView.text
    exercise["physician"] = Util.currentPhysician()
    exercise.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
      if (success) {
        // notify physician of the save
        self.dismissViewControllerAnimated(true, completion: nil)
      }
    }
  }
  
  func displayMessage(message: String) {
    var alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  func textViewDidBeginEditing(textView: UITextView) {
    if (textView.text == initialDescription) {
      textView.text = "";
    }
  }
  
  func textField(textField: IQDropDownTextField!, didSelectItem item: String!) {
    if (textField == templateDropdown) {
      if (exerciseTemplatesMap[item] == nil) {
        return
      }
      let template = exerciseTemplatesMap[item]! as! PFObject
      
      let videoFile = template["video"] as? PFFile
      if (videoFile == nil) {
        return
      }
      setUpVideo(videoFile!)
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
  
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

  @IBAction func dismissModal(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
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
