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
    @IBOutlet weak var profileImageView: UIImageView!
    
    var picker: UIImagePickerController!
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
    exercise.save()
    navigationController?.popToRootViewControllerAnimated(true)
    
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
