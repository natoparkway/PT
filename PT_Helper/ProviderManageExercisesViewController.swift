//
//  ProviderManageExercisesViewController.swift
//  PT_Helper
//
//  Created by Bryan McLellan on 5/13/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class ProviderManageExercisesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var refreshControl = UIRefreshControl()
    var cellClicked: Int = 10
  var exercises:[PFObject] = []
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
      var image = UIImage(named: "Dumbell Black")
      self.tabBarController!.tabBarItem.image = UIImage(named: "Dumbell Black")

      refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
      tableView.insertSubview(refreshControl, atIndex: 0)
      onRefresh()
    }
  
  func onRefresh() {
    var exerciseQuery = PFQuery(className: "ExerciseTemplate")
    if let curPhysician = Util.currentPhysician() {
      exerciseQuery.whereKey("physician", equalTo: curPhysician)
      exerciseQuery.includeKey("template")
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
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 60
  }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ExerciseTemplateCell") as! ExerciseTemplateCell
      cell.selectionStyle = .None    //Prevents highlighting
        var et = exercises[indexPath.row]
        cell.nameLabel.text = (et["name"] as! String)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        cellClicked = indexPath.row
        println("cell clicked is tryna be \(indexPath.row) but really is \(cellClicked)")
      //  performSegueWithIdentifier("ExerciseTemplateDetailViewController", sender: tableView.cellForRowAtIndexPath(indexPath))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        println("tryna segue")
        if(segue.identifier == "ExerciseTemplateDetailViewController"){
                var indexPath = tableView.indexPathForCell(sender as! ExerciseTemplateCell)
            
                var vc = segue.destinationViewController as! ExerciseTemplateDetailViewController
            println("cell clicked is \(indexPath!.row)")
                println("the exercise i am passing in is \(exercises[indexPath!.row])")
                vc.exerciseTemplate = exercises[indexPath!.row]
            
        }
    }
    

}
