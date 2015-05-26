//
//  ProviderManagePatientExercises.swift
//  PT_Helper
//
//  Created by Sherman Leung on 5/23/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class ProviderManagePatientExercises: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet var tableView: UITableView!
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func onRefresh() {
    let query = PFQuery(className: "Exercise")
    query.whereKey("patient", equalTo: patient)
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
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("ExerciseTemplateCell") as! ExerciseTemplateCell
    var exercise = exercises[indexPath.row]
    cell.nameLabel.text = Util.getNameFromExercise(exercise)
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
        
        var vc = segue.destinationViewController as! EditExerciseViewController
        vc.exercise = exercises[indexPath.row]
      }
    }
  

}
