//
//  HomeViewController.swift
//  OneMotion
//
//  Created by Jason Vainikolo on 12/05/20.
//  Copyright © 2020 Jason Vainikolo. All rights reserved.
// new me

import UIKit

class HomeViewController: UIViewController {
    
    ///Declared Buttons from the main storyboard
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var viewProfileButton: UIButton!
    @IBOutlet weak var addWorkoutButton: UIButton!
    @IBOutlet weak var createChallengeButton: UIButton!
    @IBOutlet weak var viewProgressButton: UIButton!
    @IBOutlet weak var myDayButton: UIButton!
    @IBOutlet weak var stepTrackerButton: UIButton! //added this for the step track
    @IBOutlet weak var goalButton:  UIButton! //added this for the goals screen - GS
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Calling the Home Page Button Display function
        startButton.layer.cornerRadius = startButton.frame.width / 2            
        HPButton(button: viewProfileButton)
        HPButton(button: addWorkoutButton)
        HPButton(button: createChallengeButton)
        HPButton(button: viewProgressButton)
        HPButton(button: myDayButton)
        HPButton(button: stepTrackerButton) //added this for the step track screen - GS
        HPButton(button: goalButton) //added this for the goals screen - GS
        
    }
    
    /// Adds displat features to the home page buttons
    /// - Parameter button: UIButton
    func HPButton(button: UIButton) {
        
        button.layer.masksToBounds = false
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.titleEdgeInsets.left = 20
        button.backgroundColor = UIColor.white
    }

    
     

}

