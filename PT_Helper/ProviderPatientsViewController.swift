//
//  ProviderPatientsViewController.swift
//  PT_Helper
//
//  Created by Sherman Leung on 5/14/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class ProviderPatientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  var patients: [PFObject] = []
  var refreshControl = UIRefreshControl()
  @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
      tableView.dataSource = self
      refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
      tableView.insertSubview(refreshControl, atIndex: 0)
      onRefresh()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func onRefresh() {
    let patientQuery = PFQuery(className: "Patient")
    if let curPhysician = Util.currentPhysician() {
      patientQuery.whereKey("physician", equalTo: curPhysician)
      patientQuery.findObjectsInBackgroundWithBlock({ (result: [AnyObject]?, error: NSError?) -> Void in
        if (error == nil) {
          self.patients = result as! [PFObject]
          self.tableView.reloadData()
        } else {
          println(error?.description)
        }
        self.refreshControl.endRefreshing()
      })
    }
  }
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return patients.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("PatientCell") as! PatientCell
    cell.setup(patients[indexPath.row])
    return cell
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
