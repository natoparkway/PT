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
  var curPhysician: PFObject = PFObject(className: "Physician")
    var stateIndex = NSMutableArray()

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
    
    override func viewWillAppear(animated: Bool) {
        onRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @IBAction func onLogout(sender: UIBarButtonItem) {
    PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
      if (error == nil) {
        self.dismissViewControllerAnimated(true, completion: nil)
      }
    }
  }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
  func onRefresh() {
    let patientQuery = PFQuery(className: "Patient")
    patientQuery.whereKey("physician", equalTo: curPhysician)
    patientQuery.orderByAscending("first_name")
    patientQuery.findObjectsInBackgroundWithBlock({ (result: [AnyObject]?, error: NSError?) -> Void in
      if (error == nil) {
        self.patients = result as! [PFObject]
        //  println("the patients are \(self.patients)")
        self.tableView.reloadData()
          
          self.stateIndex.removeAllObjects()
          for (var i = 0; i < self.patients.count; i++) {
              var firstName = self.patients[i]["first_name"] as! String
              let idx = advance(firstName.startIndex, 0)
              var char = firstName[idx]
              var temp = "\(char)"
              var upperChar = temp.capitalizedString
              if !self.stateIndex.containsObject(upperChar){
                  self.stateIndex.addObject(upperChar)
              }
          }
          

      } else {
        println(error?.description)
      }
      self.refreshControl.endRefreshing()
    })
    
  }
    
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return stateIndex.count
  }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        view.contentView.backgroundColor = UIColor(red: 255/255.0, green: 107/255.0, blue: 97/255.0, alpha: 0.8)
        return view
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return stateIndex[section] as! String
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var alphabet = stateIndex[section] as! String
    var states = NSMutableArray()
    
    for (var i = 0; i < patients.count; i++) {
        var firstName = self.patients[i]["first_name"] as! String
        let idx = advance(firstName.startIndex, 0)
        var char = firstName[idx]
        var temp = "\(char)"
        var upperChar = temp.capitalizedString
        if(upperChar == alphabet){
            states.addObject(upperChar)
        }
    }
    return states.count
}
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("PatientCell") as! PatientCell
    var alphabet = stateIndex[indexPath.section] as! String
    var states = NSMutableArray()
    
    for (var i = 0; i < patients.count; i++) {
        var firstName = self.patients[i]["first_name"] as! String
        let idx = advance(firstName.startIndex, 0)
        var char = firstName[idx]
        var temp = "\(char)"
        var upperChar = temp.capitalizedString
        if(upperChar == alphabet){
            states.addObject(self.patients[i])
        }
    }

    if(states.count>0){
        cell.setup(states[indexPath.row] as! PFObject)
    }
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("manageExerciseSegue", sender: indexPath)
  }

    /*
    // MARK: - Navigation
    */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if (segue.identifier == "manageExerciseSegue") {
        var vc = segue.destinationViewController as! ProviderManagePatientExercises
        var indexPath = sender as! NSIndexPath
        
        var alphabet = stateIndex[indexPath.section] as! String
        var states = NSMutableArray()
        
        for (var i = 0; i < patients.count; i++) {
            var firstName = self.patients[i]["first_name"] as! String
            let idx = advance(firstName.startIndex, 0)
            var char = firstName[idx]
            var temp = "\(char)"
            var upperChar = temp.capitalizedString
            if(upperChar == alphabet){
                states.addObject(self.patients[i])
            }
        }

        vc.patient = states[indexPath.row] as! PFObject
      }
      
      if (segue.identifier == "newPatientSegue") {
        var vc = segue.destinationViewController as! ProviderCreateNewPatientViewController
        vc.curPhysician = self.curPhysician
      }
      
      
    }
  

}
