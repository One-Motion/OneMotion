//
//  StepTrackerViewController.swift
//  OneMotion
//
//  Created by Grace Subianto on 21/05/20.
//  Copyright © 2020 Jason Vainikolo. All rights reserved.
//

import UIKit
import CoreMotion

class StepTrackerViewController: UIViewController {
    
    //labels
    //connections to the UI buttons
    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var avgPaceLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    //colour values for the activateButton
    let stopColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    let startColor = UIColor(red: 0.0, green: 0.75, blue: 0.0, alpha: 1.0)
    
    //variables
    //step tracker data variables
    var numberOfSteps:Int! = 2
    var distance:Double! = 2.4
    var averagePace:Double! = 4.5
    var pace:Double! = 3.7
    //pedometer object
    var pedometer = CMPedometer()
    //timers for the step tracker
    var timer = Timer()
    var timerInterval = 1.0
    var timeElapsed:TimeInterval = 1.0
    
    //button
    //connection to the activate button on the UI
    @IBAction func activateButton(_ sender: UIButton)
    {
        if sender.titleLabel?.text == "Start"
        {
            //calls pedometer object
            pedometer = CMPedometer()
            //starts the timer
            startTimer()
            
            if timerInterval >= 1.0
            {
                self.numberOfSteps += 2
                self.distance += 3.0
                self.pace += 8.0
                self.averagePace += 2.0
            }
            
            //when the step tracker is turned on
            //status is updated
            statusTitle.text = "Pedometer On"
            //activate button shows Stop option and changes to red
            sender.setTitle("Stop", for: .normal)
            sender.backgroundColor = stopColor
        }
        else
        {
            //when the step tracker is turned off
            //step tracker stops collecting data
            pedometer.stopUpdates()
            //the timer is stopped
            stopTimer()
            //status is updated
            statusTitle.text = "Pedometer Off"
            //activate button shows Start option and changes to green
            sender.backgroundColor = startColor
            sender.setTitle("Start", for: .normal)
        }
    }
    
    //timer functions
    func startTimer()
    {
        if timer.isValid
        {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: timerInterval,target: self,selector: #selector(timerAction(timer:)) ,userInfo: nil,repeats: true)
    }
    func stopTimer()
    {
        timer.invalidate()
        displayPedometerData()
    }
    @objc func timerAction(timer:Timer)
    {
        displayPedometerData()
    }
    
    // displays the updated data on the UI
    func displayPedometerData()
    {
        timeElapsed += 1.0
        timerLabel.text = "Timer: " + timeIntervalFormat(interval: timeElapsed)
        
        if let numberOfSteps = self.numberOfSteps
        {
            stepsLabel.text = String(format:"Steps: %i",numberOfSteps)
        }
        
        //distance
        if let distance = self.distance
        {
            distanceLabel.text = String(format:"Distance: %02.02f meters \n %02.02f mi",distance,miles(meters: distance))
        }
        else
        {
            distanceLabel.text = "Distance: N/A"
        }
        
        //pace
        if let pace = self.pace
        {
            print(pace)
            paceLabel.text = paceString(title: "Pace:", pace: pace)
        }
        else
        {
            paceLabel.text = "Pace: N/A "
            paceLabel.text =  paceString(title: "Pace", pace: computedAvgPace())
        }
        
        //average pace
        if let averagePace = self.averagePace
        {
            avgPaceLabel.text = paceString(title: "Avg Pace", pace: averagePace)
        }
        else
        {
            avgPaceLabel.text =  paceString(title: "Avg Pace", pace: computedAvgPace())
        }
    }
    
    //converts seconds to hh:mm:ss as a string
    func timeIntervalFormat(interval:TimeInterval)-> String
    {
        var seconds = Int(interval + 0.5) //round up seconds
        let hours = seconds / 3600
        let minutes = (seconds / 60) % 60
        seconds = seconds % 60
        return String(format:"%02i:%02i:%02i",hours,minutes,seconds)
    }
    // convert a pace in meters per second to a string with
    // the metric m/s and the Imperial minutes per mile
    func paceString(title:String,pace:Double) -> String
    {
        var minPerMile = 0.0
        let factor = 26.8224 //conversion factor
        if pace != 0
        {
            minPerMile = factor / pace
        }
        let minutes = Int(minPerMile)
        let seconds = Int(minPerMile * 60) % 60
        return String(format: "%@: %02.2f m/s \n\t\t %02i:%02i min/mi",title,pace,minutes,seconds)
    }
    
    func computedAvgPace()-> Double
    {
        if let distance = self.distance
        {
            pace = distance / timeElapsed
            return pace
        }
        else
        {
            return 0.0
        }
    }
    
    func miles(meters:Double)-> Double
    {
        let mile = 0.000621371192
        return meters * mile
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        startButton.layer.cornerRadius = 10
        
    }
    
}
