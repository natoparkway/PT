//
//  ProviderManagePatientExercises.swift
//  PT_Helper
//
//  Created by Sherman Leung on 5/23/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class ProviderManagePatientExercises: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

  @IBOutlet var tableView: UITableView!
    @IBOutlet weak var workoutsUntilApp: UITextView!
    @IBOutlet weak var patientNameTextView: UITextView!
    @IBOutlet weak var emailTextView: UITextView!
    @IBOutlet weak var ageTextView: UITextView!
    @IBOutlet weak var injuryTextView: UITextView!
  var exercises: [PFObject] = []
  var refreshControl = UIRefreshControl()
  var patient: PFObject = PFObject(className: "Patient")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onRefresh()
      refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
      tableView.insertSubview(refreshControl, atIndex: 0)
      tableView.delegate = self
      tableView.dataSource = self
        patientNameTextView.delegate = self
        emailTextView.delegate = self
        ageTextView.delegate = self
        injuryTextView.delegate = self
        workoutsUntilApp.delegate = self
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        
        var wUntilApp = patient["workoutsUntilAppointment"] as! Int
        workoutsUntilApp.text = String(wUntilApp)
        injuryTextView.text = patient["injury"] as! String
        var age = patient["age"] as! Int
        ageTextView.text = String(age)
        var temp = patient["first_name"] as! String
        temp += " "
        temp += patient["last_name"] as! String
        patientNameTextView.text = temp
        emailTextView.text = patient["email"] as! String
        self.tableView.reloadData()
    }
    

    @IBAction func savePatient(sender: UIButton) {
        var alert = UIAlertController(title: "Alert", message: "Patient Details Saved", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
            }))
            
        self.presentViewController(alert, animated: true, completion: nil)
        println("pressed the save button")
        var wUntilApp = workoutsUntilApp.text
        patient["workoutsUntilAppointment"] = wUntilApp.toInt()!
        patient["injury"] = injuryTextView.text
        var age = ageTextView.text
        var intAge = age.toInt()
        patient["age"] = intAge!
        patient["email"] = emailTextView.text
        patient["injury"] = injuryTextView.text
        
        println("text view age is \(intAge)")
        var temp = patient["age"] as! Int
        println("the patients age is \(temp)")
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
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
