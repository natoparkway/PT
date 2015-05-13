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
    
    var exercises: [Exercise] = [Exercise]()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    
        exercises.append(Exercise(dictionary: sampleData))
    }
    
    //TABLE VIEW DELEGATE METHODS
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ExerciseCell") as! ExerciseCell
        cell.selectionStyle = .None    //Prevents highlighting
        cell.updateContents(exercises[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //TABLE VIEW DELEGATE METHODS

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
