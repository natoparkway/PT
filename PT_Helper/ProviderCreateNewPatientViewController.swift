//
//  ProviderCreateNewPatientViewController.swift
//  PT_Helper
//
//  Created by Bryan McLellan on 5/13/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class ProviderCreateNewPatientViewController: UIViewController {

    @IBOutlet weak var workoutsUntilApp: UITextField!
  @IBOutlet var firstNameTextField: UITextField!
  @IBOutlet var lastNameTextField: UITextField!
  @IBOutlet weak var injuryTextField: UITextField!
  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var ageField: UITextField!
  @IBOutlet var maleFemaleButton: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

  @IBAction func savePatient(sender: UIBarButtonItem) {
    var patient = PFObject(className: "Patient")
    patient["first_name"] = firstNameTextField.text.capitalizedString
    patient["last_name"] = lastNameTextField.text.capitalizedString
    patient["workoutsUntilAppointment"] = workoutsUntilApp.text.toInt()
    patient["totalWorkouts"] = workoutsUntilApp.text.toInt()
    
    // TODO: change this to be dynamic
    var password = "abc"
    patient["password"] = password
    patient["injury"] = injuryTextField.text
    patient["email"] = emailTextField.text
    patient["age"] = ageField.text.toInt()
    patient["gender"] = "M"
    patient["physician"] = Util.currentPhysician()
    
//    var curUser = PFUser.currentUser()
//    var curUsername = curUser!["username"] as! String
//    var curPassword = curUser!["password"] as! String
    
    // Make PFUser so that the patient can login
    var user = PFUser()
    user.setValue(self.emailTextField.text, forKey: "username")
    user.setValue(password, forKey: "password")
    
    if (user.signUp()) {
      patient.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
        if (success) {
          user.setValue(patient, forKey: "patient")
            user.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                //          self.navigationController?.popViewControllerAnimated(true)
                println("we hit done")
                var alert = UIAlertController(title: "Alert", message: "New Patient Created", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
                    println("completed")
//                    PFUser.logInWithUsername(curUsername, password: curPassword)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
                println("completed again")
          })
        } else {
          let errorString = error!.userInfo?["error"] as! String
          self.displayMessage(errorString)
        }
      }
    } else {
      displayMessage("A user with that email exists!")
    }

    
  }
  
  func displayMessage(message: String) {
    var alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
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
    
    }


}
