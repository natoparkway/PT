//
//  CreateNewExerciseViewController.swift
//  PT_Helper
//
//  Created by Bryan McLellan on 5/16/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit
import MobileCoreServices
import MediaPlayer
import Foundation

class CreateNewExerciseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  @IBOutlet var exerciseNameField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var picker: UIImagePickerController!
    var moviePlayer: MPMoviePlayerController!
    var PFVideoFile: PFFile!
    var videoURL: String!
    
//    var patientHash = [String:String]()
//  var patients:[PFObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
//        patientNameField.isOptionalDropDown = false
//        let patientQuery = PFQuery(className: "Patient")
//        if let curPhysician = Util.currentPhysician() {
//          patientQuery.whereKey("physician", equalTo: curPhysician)
//          patientQuery.findObjectsInBackgroundWithBlock({ (result: [AnyObject]?, error: NSError?) -> Void in
//            if (error == nil) {
//              self.patients = result as! [PFObject]
//              var patientNames:[String] = []
//            
//              for p in self.patients {
//                let first = p["first_name"] as! String
//                let last = p["last_name"] as! String
//                patientNames.append(first + " " + last)
//                self.patientHash[first + " " + last] = p.objectId!
//              }
//              self.patientNameField.itemList = patientNames
//            } else {
//              println(error?.description)
//            }
//          })
//        }
        // Do any additional setup after loading the view.
    }
    
  @IBAction func saveExercise(sender: AnyObject) {
    var exerciseTemplate = PFObject(className: "ExerciseTemplate")
    exerciseTemplate["name"] = exerciseNameField.text
    // TODO: Figure out how to not hardcode this
    exerciseTemplate["physician"] = Util.currentPhysician()
    exerciseTemplate["video"] = PFVideoFile
    exerciseTemplate.save()
//    var patient = PFObject(className: "Patient")
//    let patientQuery = PFQuery(className: "Patient")
//    var fullName = patientNameField.text
//    var fullNameArr = split(fullName) {$0 == " "}
//    var firstName: String = fullNameArr[0]
//    var lastName: String = fullNameArr[1]
//    patientQuery.whereKey("objectId", equalTo: patientHash[firstName + " " + lastName]!)
//    patientQuery.findObjectsInBackgroundWithBlock { (result:[AnyObject]?, error: NSError?) -> Void in
//      if (error == nil) {
//        var patient = result![0] as! PFObject
//        exercise.addObject(patient, forKey: "patients")
//        exercise.save()
//      } else {
//        self.displayMessage("Patient not found", title: "Alert")
//      }
//    }
    navigationController?.popToRootViewControllerAnimated(true)
  }
  
  func displayMessage(message: String, title: String) {
    var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
    @IBAction func takeVideo(sender: UIButton) {
        picker = UIImagePickerController()
        picker.delegate = self
        
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.mediaTypes = [kUTTypeMovie as NSString]
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        if mediaType.isEqualToString(kUTTypeMovie as String){
            println("hopefully got the movie")
            
            var url = info[UIImagePickerControllerMediaURL] as! NSURL
            
            var path = url.path!
            
            videoURL = url.absoluteString!
            println("the url initially is \(url) and then the videoURL we are saving is \(videoURL)")
           var videoData = NSData(contentsOfURL: url)
           let videoFile = PFFile(name: "ExerciseVideo.mov", data: videoData!)
            PFVideoFile = videoFile
            videoFile.save()
            
            dismissViewControllerAnimated(true, completion: nil)

            
            if( UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)){
                UISaveVideoAtPathToSavedPhotosAlbum(path, nil, nil, nil)
            }
            //var url = info[0]?.objectForKey(UIImagePickerControllerMediaURL) as! NSURL
                //objectForKey(UIImagePickerControllerMediaURL) as NSURL
            
            moviePlayer = MPMoviePlayerController(contentURL: NSURL(string: videoURL!)!)
            
            moviePlayer.view.frame = profileImageView.frame
            self.view.addSubview(moviePlayer.view)
            moviePlayer.prepareToPlay()
            moviePlayer.play()
            
            var PFMovieFile = PFFile()
        
            
        }
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func uploadFromCamera(sender: UIButton) {
        picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        presentViewController(picker, animated: true, completion: nil)
    }

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        profileImageView.image = image
        dismissViewControllerAnimated(true, completion: nil)
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
