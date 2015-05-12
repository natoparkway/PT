//
//  DetailedExerciseViewController.swift
//  PT_Helper
//
//  Created by Nathaniel Okun on 5/11/15.
//  Copyright (c) 2015 Nathaniel Okun. All rights reserved.
//

import UIKit

class DetailedExerciseViewController: UIViewController {

    @IBOutlet weak var exerciseImage: UIImageView!
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var exerciseDescriptionLabel: UILabel!
    let iphoneWidth = CGFloat(320)
    
    var exercise:Exercise!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        correctWrapAround()
        updateView()
        // Do any additional setup after loading the view.
    }
    
    /*
     * Updates view with information contained in exercise instance variable.
     */
    func updateView() {
        exerciseNameLabel.text = exercise.name
        exerciseDescriptionLabel.text = exercise.exerciseDescription
    }
    
    //Accounts for wrap around bug
    func correctWrapAround() {
        exerciseNameLabel.preferredMaxLayoutWidth = exerciseNameLabel.frame.size.width
        exerciseDescriptionLabel.preferredMaxLayoutWidth = exerciseNameLabel.frame.size.width
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateContents(exerciseData: Exercise) {
        exercise = exerciseData

    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    

}
