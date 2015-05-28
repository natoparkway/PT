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
    var userExercises: [PFObject] = []
    var curPatient: PFObject = PFObject(className: "Patient")
    var curPhysician: PFObject = PFObject(className: "Physician")
  
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
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Logging In"
      PFUser.logInWithUsernameInBackground(emailField.text, password: passwordField.text) { (user: PFUser?, error: NSError?) -> Void in
        if (error == nil) {
          // login successful
          // determine if physician login view is appropriate
          
          
          if let curPhysician = PFUser.currentUser()?["physician"] as? PFObject {
            curPhysician.fetchInBackgroundWithBlock({ (physician: PFObject?, error: NSError?) -> Void in
              self.curPhysician = physician!
              self.performSegueWithIdentifier("physicianLoginSegue", sender: self)
                MBProgressHUD.hideHUDForView(self.view, animated: true)

            })
          } else {
            if let curPatient = PFUser.currentUser()?["patient"] as? PFObject {
              curPatient.fetchInBackgroundWithBlock({ (patient: PFObject?, error: NSError?) -> Void in
                self.curPatient = curPatient
                self.performPatientSegue()
                MBProgressHUD.hideHUDForView(self.view, animated: true)

              })
            }
          }
        } else {
          let patientQuery = PFQuery(className: "Patient")
          patientQuery.whereKey("email", equalTo: self.emailField.text)
          patientQuery.findObjectsInBackgroundWithBlock({ (result: [AnyObject]?, error: NSError?) -> Void in
            if (error == nil && result?.count > 0) {
              var results = result as! [PFObject]
              self.curPatient = results[0]
              var user = PFUser()
              user.username = self.emailField.text
              user.password = self.passwordField.text
              user.email = self.emailField.text
              user.setObject(self.curPatient, forKey: "patient")
              user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let err = error {
                  self.displayError(err)
                } else {
                  self.performPatientSegue()
                }
              }
            } else {
              self.displayError(error!)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
          })
        }
      }
    }
  
    //Gets user exercise data from parse, then logs in
    func performPatientSegue() {
        var exerciseQuery = PFQuery(className: "Exercise")
        exerciseQuery.whereKey("patient", equalTo: curPatient)
        exerciseQuery.includeKey("template")
        exerciseQuery.findObjectsInBackgroundWithBlock({ (result: [AnyObject]?, error: NSError?) -> Void in
            
            if (error == nil) {
                println("Got Exercises Sucessfully")
                self.userExercises = result as! [PFObject]
                println(self.userExercises)
                self.performSegueWithIdentifier("ToStoryboardSegue", sender: self)
            } else {
                println(error?.description)
            }
        })
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
        if let id = segue.identifier {
            if id == "physicianSignupSegue" {
                var finishSignupVC = segue.destinationViewController as! ProviderSignupVIewController
                finishSignupVC.email = emailField.text
                finishSignupVC.password = passwordField.text
            }
            
            if id == "ToStoryboardSegue" {
                var patientTabBar = segue.destinationViewController as! UITabBarController
                var workoutViewNav = patientTabBar.viewControllers![0] as! UINavigationController
                var workoutViewVC = workoutViewNav.topViewController as! PatientHomeViewController
                workoutViewVC.exercises = userExercises
                
                var listNav = patientTabBar.viewControllers![1] as! UINavigationController
                var listVC = listNav.topViewController as! PatientExercisesViewController
                listVC.exercises = userExercises
            }
          
          if id == "physicianLoginSegue" {
            var physicianTabBar = segue.destinationViewController as! UITabBarController
            var physicianViewNav = physicianTabBar.viewControllers![0] as! UINavigationController
            var managePatientVC = physicianViewNav.topViewController as! ProviderPatientsViewController
            managePatientVC.curPhysician = self.curPhysician
          }
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
