//
//  ProviderManageExercisesViewController.swift
//  PT_Helper
//
//  Created by Bryan McLellan on 5/13/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class ProviderManageExercisesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sampleData = ["name": "Hip Abduction",
        "exerciseDescription": "Sample description",
        "duration": 30,
        "numRepetitions": 12,
        "daysPerWeek": 3]
  
  var refreshControl = UIRefreshControl()
  var exercises:[PFObject] = []
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
      
      refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
      tableView.insertSubview(refreshControl, atIndex: 0)
      onRefresh()
    }
  
  func onRefresh() {
    var exerciseQuery = PFQuery(className: "ExerciseTemplate")
    if let curPhysician = Util.currentPhysician() {
      exerciseQuery.whereKey("physician", equalTo: curPhysician)
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
  
    //TABLE VIEW DELEGATE METHODS
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ExerciseTemplateCell") as! ExerciseTemplateCell
        cell.selectionStyle = .None    //Prevents highlighting
        var et = exercises[indexPath.row] as! PFObject
        cell.nameLabel.text = et["name"] as! String
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
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
