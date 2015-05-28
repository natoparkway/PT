//
//  ExerciseTemplateDetailViewController.swift
//  PT_Helper
//
//  Created by Bryan McLellan on 5/27/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ExerciseTemplateDetailViewController: UIViewController {

    var exerciseTemplate: PFObject = PFObject(className: "ExerciseTemplate")
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var templateNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        println("the exercise template is \(exerciseTemplate)")
        var videoFile = exerciseTemplate["video"] as? PFFile
        if(videoFile != nil){
            let videoURL = NSURL(string: videoFile!.url!)!
            var player = AVPlayer(URL: videoURL)
            let playerController = AVPlayerViewController()
            playerController.player = player
            self.addChildViewController(playerController)
            self.view.addSubview(playerController.view)
            playerController.view.frame = CGRect(x: videoImageView.frame.origin.x, y: videoImageView.frame.origin.y, width: videoImageView.frame.width, height: videoImageView.frame.height)
            
            templateNameLabel.text = exerciseTemplate["name"] as! String
        }
        else{
            var temp = exerciseTemplate["name"] as! String
            temp += " (No Video Attached)"
            templateNameLabel.text = temp
        }

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
