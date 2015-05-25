//
//  NewExerciseViewController.swift
//  PT_Helper
//
//  Created by Sherman Leung on 5/24/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class NewExerciseViewController: UIViewController, IQDropDownTextFieldDelegate {

  
  @IBAction func onTap(sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  @IBOutlet var templateDropdown: IQDropDownTextField!
  @IBOutlet var numRepsLabel: UILabel!
  @IBOutlet var numDegreesLabel: UILabel!
  @IBOutlet var numSetsLabel: UILabel!
  @IBOutlet var descriptionTextView: UITextView!
  @IBOutlet var patientNameLabel: UILabel!
  var exerciseTemplates : [PFObject] = []
  var exerciseTemplatesMap = [String: PFObject]()
  var patient = PFObject(className: "Patient")
  var exerciseTemplate  = PFObject(className: "ExerciseTemplate")
    override func viewDidLoad() {
        super.viewDidLoad()
        let query = PFQuery(className: "ExerciseTemplate")
      patientNameLabel.text = patient["first_name"] as! String
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
      
        // Do any additional setup after loading the view.
    }
  
  @IBAction func saveExercise(sender: AnyObject) {
    var exercise = PFObject(className: "Exercise")
    exercise["template"] = exerciseTemplate
    exercise["repetitions"] = numRepsLabel.text!.toInt()
    exercise["sets"] = numSetsLabel.text!.toInt()
    exercise["degrees"] = numDegreesLabel.text!.toInt()
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
  
  func textFieldDidEndEditing(textField: UITextField) {
    var templateName = templateDropdown.text
    exerciseTemplate = exerciseTemplatesMap[templateName]!
    
    // TODO: Display video here...
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
