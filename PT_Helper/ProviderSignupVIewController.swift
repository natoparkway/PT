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

  @IBAction func onSignUp(sender: UIButton) {
    PFUser.logInWithUsernameInBackground(email  , password:password) {
      (user: PFUser?, error: NSError?) -> Void in
      if user != nil {
        // update the user with the additional info
        user!["phone"] = self.phoneField.text
        user!["first_name"] = self.firstNameField.text
        user!["last_name"] = self.lastNameField.text
        user!.save()
        println("logged in to " + user!.email!)
        self.performSegueWithIdentifier("toPhysicianHome", sender: self)
      } else {
        let errorString = error!.userInfo?["error"] as? NSString
        var alert = UIAlertController(title: "Alert", message: errorString as! String, preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
      }
    }
  }
}
