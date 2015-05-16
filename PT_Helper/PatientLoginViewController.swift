//
//  PatientLoginViewController.swift
//  PT_Helper
//
//  Created by Nathaniel Okun on 5/10/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class PatientLoginViewController: UIViewController, UITextFieldDelegate {

  @IBOutlet var passwordField: UITextField!
  @IBOutlet var emailField: UITextField!
  
  @IBAction func onTap(sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonClicked(sender: AnyObject) {
      PFUser.logInWithUsernameInBackground(emailField.text, password: passwordField.text) { (user: PFUser?, error: NSError?) -> Void in
        if (error == nil) {
          // login successful
          println(PFUser.currentUser()!["isPhysician"])
          // determine if physician login view is appropriate
          let isPhysician = PFUser.currentUser()!["isPhysician"] as! Bool
          if (isPhysician == true) {
            self.performSegueWithIdentifier("physicianLoginSegue", sender: self)
          } else {
            self.performSegueWithIdentifier("ToPatientExercises", sender: self)
          }
        } else {
          self.displayError(error!)
        }
      }
      
    }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    loginButtonClicked(textField)
    return true
  }
  func displayError(error: NSError) {
    let errorString = error.userInfo?["error"] as? NSString
    var alert = UIAlertController(title: "Alert", message: errorString as! String, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }


    /*
    // MARK: - Navigation
  */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if (segue.identifier == "physicianSignupSegue") {
        var finishSignupVC = segue.destinationViewController as! ProviderSignupVIewController
        finishSignupVC.email = emailField.text
        finishSignupVC.password = passwordField.text
      }
    }
  

  @IBAction func onPhysicianSignUp(sender: UIButton) {
    var user = PFUser()
    user.username = emailField.text
    user.password = passwordField.text
    user.email = emailField.text
    // other fields can be set just like with PFObject

    user.signUpInBackgroundWithBlock {
      (succeeded: Bool, error: NSError?) -> Void in
      if let error = error {
        self.displayError(error)
      } else {
        self.performSegueWithIdentifier("physicianSignupSegue", sender: self)
      }
    }
  }
}
