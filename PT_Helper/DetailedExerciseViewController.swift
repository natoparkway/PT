//
//  DetailedExerciseViewController.swift
//  PT_Helper
//
//  Created by Nathaniel Okun on 5/11/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices
import MediaPlayer
import Foundation
import AVFoundation

class DetailedExerciseViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var exerciseImage: UIImageView!
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var exerciseDescriptionLabel: UILabel!
    let toWorkoutSegue = "ToWorkingOutVC"
    let iphoneWidth = CGFloat(320)
    
    var exercise: PFObject!
    
    //avfoundation stuff from stack overflow
    //var player : AVAudioPlayer! = nil
    var playerLayer : AVPlayerLayer? = nil
    var asset : AVAsset? = nil
    var playerItem: AVPlayerItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        correctWrapAround()
        updateView()
        println("printing what i think is the video file")
        if(exercise["video"] != nil){
        var videoFile = exercise["video"] as! PFFile
        
        
        let videoURL = NSURL(string: videoFile.url!)!
        
//        asset = AVAsset.assetWithURL(videoURL) as? AVAsset
//        playerItem = AVPlayerItem(asset: asset)
//        
//        player = AVPlayer(playerItem: self.playerItem)
//        
//        playerLayer = AVPlayerLayer(player: self.player)
//        playerLayer!.frame = exerciseImage.frame
//        exerciseImage.layer.addSublayer(self.playerLayer)
//        
        
        var player = AVPlayer(URL: videoURL)
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.addChildViewController(playerController)
        self.view.addSubview(playerController.view)
        playerController.view.frame = exerciseImage.frame
        player.play()
        }
        else{
            
        }
        
//        //var videoURL = NSURL(string: exercise["videoURL"] as! String)
//        var videoURL = NSURL(string: videoFile.url!)!
//        println("\(videoURL)")
//        var moviePlayer = MPMoviePlayerController(contentURL: videoURL)
//
//        moviePlayer.contentURL = videoURL
//        moviePlayer.view.frame = exerciseImage.frame
//        self.view.addSubview(moviePlayer.view)
//        moviePlayer.prepareToPlay()
//        moviePlayer.play()
        
        // Do any additional setup after loading the view.
    }
    
    /*
     * Updates view with information contained in exercise instance variable.
     */
    func updateView() {
        let name = exercise["name"] as! String
        //let description = exercise["description"] as! String
        exerciseNameLabel.text = name
        exerciseDescriptionLabel.text = description
      
    }

    //Accounts for wrap around bug
    func correctWrapAround() {
        exerciseNameLabel.preferredMaxLayoutWidth = exerciseNameLabel.frame.size.width
        exerciseDescriptionLabel.preferredMaxLayoutWidth = exerciseNameLabel.frame.size.width
    }
    
    //Workout button was clicked
    @IBAction func workoutButtonClicked(sender: AnyObject) {
        performSegueWithIdentifier(toWorkoutSegue, sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let id = segue.identifier {
            if id == toWorkoutSegue {
                var workingOutVC = segue.destinationViewController as! PatientWorkingOutViewController
                workingOutVC.exercise = exercise
            }
        }

    }
    

}
