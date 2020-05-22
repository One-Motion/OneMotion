//
//  GoalsViewController.swift
//  OneMotion
//
//  Created by Grace Subianto on 22/05/20.
//  Copyright © 2020 Jason Vainikolo. All rights reserved.
//

import UIKit

class GoalsViewController: UIViewController{
    
    @IBOutlet weak var workoutGoalsButton: UIButton!
    @IBOutlet weak var caloriesGoalButton: UIButton!
    @IBOutlet weak var runsGoalsButton: UIButton!
    @IBOutlet weak var stepsGoalsButton: UIButton!
    @IBOutlet weak var overviewButton: UIButton!
    
    func GPButton(button: UIButton) {
        
        button.layer.masksToBounds = false
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.titleEdgeInsets.left = 20
        button.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GPButton(button: workoutGoalsButton)
        GPButton(button: caloriesGoalButton)
        GPButton(button: runsGoalsButton)
        GPButton(button: stepsGoalsButton)
        overviewButton.layer.cornerRadius = 10
    }
}
