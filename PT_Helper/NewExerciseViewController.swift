//
//  NewExerciseViewController.swift
//  PT_Helper
//
//  Created by Sherman Leung on 5/24/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class NewExerciseViewController: UIViewController, IQDropDownTextFieldDelegate, UITextViewDelegate {

  
  @IBAction func onTap(sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
  @IBOutlet var templateDropdown: IQDropDownTextField!
  @IBOutlet var isDurationSwitch: UISwitch!
  @IBOutlet var numRepsOrDurationLabel: UILabel!
  @IBOutlet var repsOrDurationLabel: UILabel!
  @IBOutlet var numSetsLabel: UILabel!
  @IBOutlet var descriptionTextView: UITextView!
  var exerciseTemplates : [PFObject] = []
  var exerciseTemplatesMap = [String: PFObject]()
  var patient = PFObject(className: "Patient")
  var initialDescription:String = ""
  var exerciseTemplate  = PFObject(className: "ExerciseTemplate")
    override func viewDidLoad() {
        super.viewDidLoad()
        let query = PFQuery(className: "ExerciseTemplate")
      
      // setting the initial placeholder for description
      let firstName = patient["first_name"] as! String
      let lastName = patient["last_name"] as! String
      
      initialDescription = "Write any specific instructions you have for " + firstName + " " + lastName
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
  
  @IBAction func switchFlipped(sender: UISwitch) {
    if (isDurationSwitch.on) {
      repsOrDurationLabel.text = "DURATION"
    } else {
      repsOrDurationLabel.text = "REPS"
    }
  }
  @IBAction func saveExercise(sender: AnyObject) {
    var exercise = PFObject(className: "Exercise")
    var templateName = templateDropdown.text
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
  func textViewDidBeginEditing(textView: UITextView) {
    if (textView.text == initialDescription) {
      textView.text = "";
    }
  }
  func textFieldDidEndEditing(textField: UITextField) {
    if (textField == templateDropdown) {
      // TODO: Display video here...
    }
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
