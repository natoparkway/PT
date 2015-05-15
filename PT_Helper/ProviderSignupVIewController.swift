//
//  ProviderSignupVIewController.swift
//  PT_Helper
//
//  Created by Sherman Leung on 5/14/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class ProviderSignupVIewController: UIViewController {
  var email:String!
  var password:String!
  @IBOutlet var firstNameField: UITextField!
  @IBOutlet var lastNameField: UITextField!
  @IBOutlet var phoneField: UITextField!
  
  @IBAction func onTap(sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

  func displayError(error: NSError) {
    let errorString = error.userInfo?["error"] as? NSString
    var alert = UIAlertController(title: "Alert", message: errorString as! String, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }

  @IBAction func onSignUp(sender: UIButton) {
    PFUser.logInWithUsernameInBackground(email  , password:password) {
      (user: PFUser?, error: NSError?) -> Void in
      if user != nil {
        // update the user with the additional info
        user!["isPhysician"] = true
        var physician = PFObject(className: "Physician")
        physician["email"] = self.email
        physician["phone"] = self.phoneField.text
        physician["first_name"] = self.firstNameField.text
        physician["last_name"] = self.lastNameField.text
        physician.save()
        user!["physician"] = physician
        user!.save()
        self.performSegueWithIdentifier("toPhysicianHome", sender: self)
      } else {
        self.displayError(error!)
      }
    }
  }
}
