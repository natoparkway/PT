//
//  CreateNewExerciseViewController.swift
//  PT_Helper
//
//  Created by Bryan McLellan on 5/16/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class CreateNewExerciseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  @IBOutlet var numRepitionsField: UITextField!
  @IBOutlet var timesPerWeekField: UITextField!
  @IBOutlet var numSetsField: UITextField!
  @IBOutlet var exerciseNameField: UITextField!
  @IBOutlet var durationField: UITextField!
  @IBOutlet var patientNameField: IQDropDownTextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var picker: UIImagePickerController!
    var patientHash = [String:String]()
  var patients:[PFObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        patientNameField.isOptionalDropDown = false
        let patientQuery = PFQuery(className: "Patient")
        if let curPhysician = Util.currentPhysician() {
          patientQuery.whereKey("physician", equalTo: curPhysician)
          patientQuery.findObjectsInBackgroundWithBlock({ (result: [AnyObject]?, error: NSError?) -> Void in
            if (error == nil) {
              self.patients = result as! [PFObject]
              var patientNames:[String] = []
              
              for p in self.patients {
                let first = p["first_name"] as! String
                let last = p["last_name"] as! String
                patientNames.append(first + " " + last)
                self.patientHash[first + " " + last] = p.objectId!
              }
              self.patientNameField.itemList = patientNames
            } else {
              println(error?.description)
            }
          })
        }
        // Do any additional setup after loading the view.
    }
    
  @IBAction func saveExercise(sender: AnyObject) {
    var exercise = PFObject(className: "Exercise")
    exercise["name"] = exerciseNameField.text
    exercise["numRepetitions"] = numRepitionsField.text
    exercise["numSets"] = numSetsField.text
    exercise["timesPerWeek"] = timesPerWeekField.text
    exercise["duration"] = durationField.text
    // TODO: Figure out how to not hardcode this
    exercise["isDuration"] = true
    exercise["physician"] = Util.currentPhysician()
    var patient = PFObject(className: "Patient")
    let patientQuery = PFQuery(className: "Patient")
    var fullName = patientNameField.text
    var fullNameArr = split(fullName) {$0 == " "}
    var firstName: String = fullNameArr[0]
    var lastName: String = fullNameArr[1]
    patientQuery.whereKey("objectId", equalTo: patientHash[firstName + " " + lastName]!)
    patientQuery.findObjectsInBackgroundWithBlock { (result:[AnyObject]?, error: NSError?) -> Void in
      if (error == nil) {
        var patient = result![0] as! PFObject
        exercise.addObject(patient, forKey: "patients")
        exercise.save()
      } else {
        self.displayMessage("Patient not found", title: "Alert")
      }
    }
    navigationController?.popToRootViewControllerAnimated(true)
  }
  
  func displayMessage(message: String, title: String) {
    var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
    @IBAction func takeVideo(sender: UIButton) {
        picker = UIImagePickerController()
        picker.delegate = self
        
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func uploadFromCamera(sender: UIButton) {
        picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        presentViewController(picker, animated: true, completion: nil)
    }

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        profileImageView.image = image
        dismissViewControllerAnimated(true, completion: nil)
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
