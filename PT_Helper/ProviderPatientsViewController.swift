//
//  ProviderPatientsViewController.swift
//  PT_Helper
//
//  Created by Sherman Leung on 5/14/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class ProviderPatientsViewController: UIViewController {

  @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//      var sdf = PFUser.currentUser()!["physician"]
//      println(sdf)
//      let curPhysician = PFUser.currentUser()!["physician"]!.fetch() as! PFObject
//      var name = curPhysician["first_name"] as! String
//      println("logged in as " + name)

        // Do any additional setup after loading the view.
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
