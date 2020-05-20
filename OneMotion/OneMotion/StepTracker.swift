//
//  StepTracker.swift
//  OneMotion
//
//  Created by Grace Subianto on 21/05/20.
//  Copyright © 2020 Jason Vainikolo. All rights reserved.
//
//AM I DOIN G THIS RIGHT

import UIKit
import CoreMotion

class StepTracker: UIViewController {
    
    //declaring and linking the buttons from the main storyboard
    @IBOutlet weak var statusTitle: UILabel!
    //@IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var stepsLabel: UILabel!
    //changes the colours of the start button when clicked
    let stopColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    let startColor = UIColor(red: 0.0, green: 0.75, blue: 0.0, alpha: 1.0)
    
    //declaring values for the pedometer data
    var numberOfSteps:Int! = nil
    var distance:Double! = nil
    
    //declaring pedometer object
    var pedometer = CMPedometer()
    
    //converts the distance travelled from miles to meters as io
    func miles(meters:Double)-> Double{
        let mile = 0.000621371192
        return meters * mile
    }
    
    //declaring and linking the start button to the main storyboard
    @IBAction func activateButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "Start"{
            //calls existing iOS pedometer function
            pedometer = CMPedometer()
            
            pedometer.startUpdates(from: Date(), withHandler: { (pedometerData, error) in
                if let pedData = pedometerData{
                    self.stepsLabel.text = "Steps:\(pedData.numberOfSteps)"
                } else {
                    self.stepsLabel.text = "Steps: None"
                }
            })
            //changes the status label of the pedometer
            statusTitle.text = "Pedometer Is Running"
            //changes the start button text to stop
            sender.setTitle("Stop", for: .normal)
            //changes the start button colour to red
            sender.backgroundColor = stopColor
        } else {
            //stops the pedometer
            pedometer.stopUpdates()
            //changes the status label of the pedometer
            statusTitle.text = "Pedometer Has Stopped"
            //changes the startstop button text to start
            sender.setTitle("Start", for: .normal)
            //changes the startstop button colour to green
            sender.backgroundColor = startColor
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
}


