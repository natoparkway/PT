//
//  ProviderCreateNewPatientViewController.swift
//  PT_Helper
//
//  Created by Bryan McLellan on 5/13/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class ProviderCreateNewPatientViewController: UIViewController {

    @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet weak var injuryTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

  @IBAction func savePatient(sender: UIBarButtonItem) {
    var user = PFObject()
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
