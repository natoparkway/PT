//
//  PatientExercisesViewController.swift
//  PT_Helper
//
//  Created by Nathaniel Okun on 5/10/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class PatientExercisesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var exercises: [PFObject] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
      
        var exerciseQuery = PFQuery(className: "Exercise")
        if let curPatient = Util.currentPatient() {
            exerciseQuery.whereKey("patients", equalTo: curPatient)
            exerciseQuery.includeKey("patients")
            exerciseQuery.findObjectsInBackgroundWithBlock({ (result: [AnyObject]?, error: NSError?) -> Void in
        
            if (error == nil) {
                println("Got Exercises Sucessfully")
                self.exercises = result as! [PFObject]
                self.tableView.reloadData()
            } else {
                println(error?.description)
            }
          })
        }
      

        // Do any additional setup after loading the view.
    }

  @IBAction func onLogout(sender: UIBarButtonItem) {
    PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
      if (error == nil) {
        self.navigationController?.popToRootViewControllerAnimated(true)
      }
    }
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//TABLE VIEW DELEGATE METHODS
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ExerciseCell") as! ExerciseCell
        cell.selectionStyle = .None    //Prevents highlighting
        cell.setup(exercises[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
//TABLE VIEW DELEGATE METHODS
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let id = segue.identifier {
            if id == "ToDetailedExercise" {
                toDetailedExerciseSegue(segue, cell: sender as! ExerciseCell)
            }
        }
    }
    
    func toDetailedExerciseSegue(segue: UIStoryboardSegue, cell: ExerciseCell) {
        var nav = segue.destinationViewController as! UINavigationController
        var detailedExerciseVC = nav.topViewController as! DetailedExerciseViewController
        var indexPath = tableView.indexPathForCell(cell)!
        detailedExerciseVC.exercise = exercises[indexPath.row]
    }
    

}
