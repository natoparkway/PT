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
    var refreshControl = UIRefreshControl()
    let transitionManager = SlideTransitionDelegate()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
        
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        onRefresh()
    }
    
    func onRefresh() {
        var exerciseQuery = PFQuery(className: "Exercise")
        if let curPatient = Util.currentPatient() {
            exerciseQuery.whereKey("patient", equalTo: curPatient)
           // exerciseQuery.includeKey("template")
            exerciseQuery.findObjectsInBackgroundWithBlock({ (result: [AnyObject]?, error: NSError?) -> Void in
                if (error == nil) {
                    println(result)
                    self.exercises = result as! [PFObject]
                    self.tableView.reloadData()
                } else {
                    println(error?.description)
                }
                self.refreshControl.endRefreshing()
            })
        }
    }

  @IBAction func onLogout(sender: UIBarButtonItem) {
    PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
        if (error == nil) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ToWorkout", sender: tableView.cellForRowAtIndexPath(indexPath))

    }
//TABLE VIEW DELEGATE METHODS


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let id = segue.identifier {
            if id == "ToWorkout" {
                toWorkoutViewSegue(segue, sender: sender)
            }
        }
    }

    func toWorkoutViewSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
        var workoutVC = segue.destinationViewController as! WorkoutContainerViewController
        var singleExercise = [PFObject]()
        singleExercise.append(exercises[indexPath.row])
        workoutVC.modalPresentationStyle = .Custom
        workoutVC.transitioningDelegate = transitionManager
        workoutVC.exercises = singleExercise
    }



}
