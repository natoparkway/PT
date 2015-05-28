//
//  ProviderManagePatientExercises.swift
//  PT_Helper
//
//  Created by Sherman Leung on 5/23/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

import MessageUI

class ProviderManagePatientExercises: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, MFMailComposeViewControllerDelegate  {

  @IBOutlet var tableView: UITableView!

    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var workoutsUntilApptTextField: UITextField!
    @IBOutlet weak var workoutsCompletedLabel: UILabel!
    
    @IBOutlet weak var injuryLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
  var exercises: [PFObject] = []
  var refreshControl = UIRefreshControl()
  var patient: PFObject = PFObject(className: "Patient")
    
  @IBAction func callPatient(sender: UIButton) {
    var phoneNum = String(patient["phone"] as! Int)
    UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phoneNum)")!)

  }
    
    
//    func dismissKeyboard (){
//       // injuryTextView.resignFirstResponder()
//        workoutsUntilApptTextField.resignFirstResponder()
//    }
    
//    func textViewDidEndEditing(textView: UITextView) {
//        textView.layer.borderColor = UIColor.blueColor().CGColor
//    }
//    
//    func textViewDidChange(textView: UITextView) {
//        textView.layer.borderWidth = 1
//        textView.layer.backgroundColor = UIColor(red: 119/255.0, green: 190/255.0, blue: 119/255.0, alpha: 1).CGColor
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        onRefresh()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        tableView.delegate = self
        tableView.dataSource = self
//        patientNameTextView.delegate = self
//        emailTextView.delegate = self
//        injuryTextView.delegate = self
//        workoutsUntilApp.delegate = self
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if let imageURl = patient["profileImageUrl"] as? String {
            profileImageView.setImageWithURL(NSURL(string: imageURl )!)
        }
        else{
            profileImageView.image = UIImage(named: "patient")
        }
        
        //profileImageView.setImageWithURL(NSURL(string: url)!)
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.clipsToBounds = true

        var wUntilApp = patient["workoutsUntilAppointment"] as! Int
        workoutsUntilApptTextField.text = String(wUntilApp)
       // injuryTextView.text = patient["injury"] as! String
        var temp = patient["first_name"] as! String
        temp += " "
        temp += patient["last_name"] as! String
        patientNameLabel.text = temp
        emailLabel.text = patient["email"] as? String
        var wInt = patient["totalWorkouts"] as! Int
        workoutsCompletedLabel.text = String(wInt - wUntilApp)
        injuryLabel.preferredMaxLayoutWidth = injuryLabel.frame.width
        injuryLabel.text = patient["injury"] as? String
        self.tableView.reloadData()
    }
    
    @IBAction func emailButtonTapped(sender: UIButton) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        var email = patient["email"] as! String
        mailComposerVC.setToRecipients(["\(email)"])
        mailComposerVC.setSubject("Feedback from your friendly Physical Therapist")
        
//        var name = PFUser.currentUser()?["physician"] as? PFObject
//        var signature = "Sincerely, \n Dr. "
//        var signature1 = name["last_name"] as! String
//        signature += signature1
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func savePatient(sender: UIButton) {
        var alert = UIAlertController(title: "Alert", message: "Patient Details Saved", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
            }))
            
        self.presentViewController(alert, animated: true, completion: nil)
        println("pressed the save button")
        var wUntilApp = workoutsUntilApptTextField.text
        patient["workoutsUntilAppointment"] = wUntilApp.toInt()!
       // patient["injury"] = injuryTextView.text
      //  patient["email"] = emailTextView.text
      //  patient["injury"] = injuryTextView.text

    }
    
    @IBAction func backgroundTapped(sender: AnyObject) {
        view.endEditing(true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func onRefresh() {
    let query = PFQuery(className: "Exercise")
    query.whereKey("patient", equalTo: patient)
    query.includeKey("template")
    query.findObjectsInBackgroundWithBlock { (result: [AnyObject]?, error: NSError?) -> Void in
      if (error == nil) {
        self.exercises = result as! [PFObject]
        self.tableView.reloadData()
      }
      self.refreshControl.endRefreshing()
    }
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return exercises.count
  }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        return view
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var first = patient["first_name"] as! String
        var last = patient["last_name"] as! String
        
        return "Exercises for \(first) \(last)"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
  
    func tableView(tableView: UITableView,    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ExerciseTemplateCell") as! ExerciseTemplateCell
        var exercise = exercises[indexPath.row]
    
        cell.nameLabel.text = Util.getNameFromExercise(exercise)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("editExerciseSegue", sender: indexPath)
  }
    

    /*
    // MARK: - Navigation
    */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if (segue.identifier == "newExerciseSegue") {
        var vc = segue.destinationViewController as! NewExerciseViewController
        vc.patient = patient
      }
      
      if (segue.identifier == "editExerciseSegue") {
        var indexPath = sender as! NSIndexPath
        println("\(sender)")
        var vc = segue.destinationViewController as! EditExerciseViewController
        vc.exercise = exercises[indexPath.row]
      }
    }
  

}
