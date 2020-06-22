//
//  StepTrackerViewController.swift
//  OneMotion
//
//  Created by Grace Subianto on 21/05/20.
//  Copyright © 2020 Jason Vainikolo. All rights reserved.
// new comment

import UIKit
import CoreMotion
import SQLite3

//Some of the code for the Step Tracker is commented out due to Xcode lack of capability for step movement simulation.
//They are instead replaced with code marked by "code for demo" to check that the values are passing through all classes as they should be. In Sprint 2 we will be testing the code on an actual device, and then the greyed out code will be used instead of the code for demo.

class StepTrackerViewController: UIViewController {
    
    //connections to the storyboard interface buttons
    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var avgPaceLabel: UILabel!
    @IBOutlet weak var startButton: UIButton! //declaration of start button for layout
    
    
    var db: OpaquePointer?
    
    //constant colour values for the activateButton after activation
    let STOP_COLOR = UIColor(red: 204/255, green: 0/255, blue: 0/255, alpha: 1.0)
    let START_COLOR = UIColor(red: 0/255, green: 153/255, blue: 0/255, alpha: 1.0)
    
    //initialisation of step tracker data variables
    //    var numberOfSteps:Int! = nil
    //    var distance:Double! = nil
    //    var pace:Double! = nil
    //    var averagePace:Double! = nil
    
    //code for demo - initialisation of step tracker data variables
    //this is due to Xcode being unable to simulate individual step movement
    var numberOfSteps:Int! = 0
    var distance:Double! = 0.0
    var pace:Double! = 0.0
    var averagePace:Double! = 0.0
    var demoSteps:Int! = 0
    
    //initialisation of pedometer object
    var pedometer = CMPedometer()
    
    //initialisation of timers for the step tracker
    var timer = Timer()
    var timerInterval = 1.0
    var timeElapsed:TimeInterval = 1.0
    
    //connection of the activate button to the storyboard UI
    @IBAction func activateButton(_ sender: UIButton)
    {
        //when the step tracker is turned on
        if sender.titleLabel?.text == "Start"
        {
            //calls pedometer object
            pedometer = CMPedometer()
            //the timer starting functoin is called
            startTimer()
            //status label is updated to show the pedometer is on
            statusTitle.text = "Step Tracker Is On"
            //activate button shows Stop option and changes to red
            sender.setTitle("Stop", for: .normal)
            sender.backgroundColor = STOP_COLOR
            
            //retrieves updated data from pedomter object when tracker is running
//                        pedometer.startUpdates(from: Date(), withHandler: { (pedometerData, error) in
//                            if let pedData = pedometerData{
//                                self.numberOfSteps = Int(pedData.numberOfSteps)
//
//                                if let distance = pedData.distance{
//                                    self.distance = Double(distance)
//                                }
//                                if let averageActivePace = pedData.averageActivePace {
//                                    self.averagePace = Double(averageActivePace)
//                                }
//                                if let currentPace = pedData.currentPace {
//                                    self.pace = Double(currentPace)
//                                }
//                            } else {
//                                self.numberOfSteps = nil
//                            }
//                        })
            
            //code for demo - set variables to show information is passing through classes correctly
            //this is due to Xcode being unable to simulate individual step movement
            if timerInterval >= 1.0
            {
                self.numberOfSteps = 0
                self.distance = 1.3
                self.pace = 0.2
                self.averagePace = 0.1
            }
        }
        else //when the step tracker is turned off
        {
            
            //step tracker stops collecting data
            pedometer.stopUpdates()
            //the timer stopping functoin is called
            stopTimer()
            //status label is updated to show the tracker is off
            statusTitle.text = "Step Tracker Is Off"
            //activate button shows Start option and changes to green
            sender.backgroundColor = START_COLOR
            sender.setTitle("Start", for: .normal)
            
            //Opens the Connection
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("OneMotion.sqlite")

            if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                print("Error Opening database")
                return
            }
            
            self.insertStep(steps: String(self.numberOfSteps), distance: String(self.distance))
        }
    }
    
    func insertStep(steps: String, distance: String){
        var insertStmt: OpaquePointer?
        let insertQuery = "INSERT INTO STEPS(STEPS, DISTANCE) VALUES (?,?);"
        
    if sqlite3_prepare_v2(db, insertQuery, -1, &insertStmt, nil) == SQLITE_OK {
            
        let Steps: NSString = steps as NSString
        let Distance: NSString = distance as NSString
        
        sqlite3_bind_text(insertStmt, 1, Steps.utf8String, -1, nil)
        sqlite3_bind_text(insertStmt, 2, Distance.utf8String, -1, nil)
        
        if sqlite3_step(insertStmt) == SQLITE_DONE {
            print("\nSuccessfully inserted row")
        } else {
            print("\nCould not insert row")
        }
    }
    else {
        print("\nInsert Statement not prepared")
    }
    sqlite3_finalize(insertStmt)
        
        
    }
    
    //timer function starts timing from when the user clicks the activation button
    func startTimer()
    {
        if timer.isValid
        {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: timerInterval,target: self,selector: #selector(timerAction(timer:)) ,userInfo: nil,repeats: true)
    }
    
    //timer function stops timing from when the user clicks the stop button
    func stopTimer()
    {
        timer.invalidate()
        displayPedometerData()
    }
    
    //while the timer is running the displayPedometerData functio is called to change the label data values
    @objc func timerAction(timer:Timer)
    {
        displayPedometerData()
    }
    
    //displays the updated data on the storyboard interface
    func displayPedometerData()
    {
        timeElapsed += 1.0
        timerLabel.text = "Timer: " + timeIntervalFormat(interval: timeElapsed)
        
        
        //displays the number of steps the user has taken
        self.numberOfSteps += 1 //code for demo
        if let NUMBER_OF_STEPS = self.numberOfSteps
        {
            stepsLabel.text = String(format:"Steps: %i",NUMBER_OF_STEPS)
        }
        
        //displays the distance the user has travelled
        self.distance += 0.12 //code for demo
        if let DISTANCE = self.distance
        {
            distanceLabel.text = String(format:"Distance: %02.02f meters \n %02.02f mi",DISTANCE,miles(meters: DISTANCE))
        }
        else
        {
            distanceLabel.text = "Distance: Unavailable"
        }
        
        
        //displays the users pace
        self.pace += 0.04 //code for demo
        if let PACE = self.pace
        {
            //print(pace)
            paceLabel.text = paceString(title: "Pace", pace: PACE)
        }
        else
        {
            paceLabel.text = "Pace: Unavailable "
            paceLabel.text =  paceString(title: "Pace", pace: calculateAveragePace())
        }
        
        
        //displays the users average pace
        self.averagePace += 0.03 //code for demo
        if let AVERAGE_PACE = self.averagePace
        {
            avgPaceLabel.text = paceString(title: "Avg Pace", pace: AVERAGE_PACE)
        }
        else
        {
            avgPaceLabel.text =  paceString(title: "Avg Pace", pace: calculateAveragePace())
        }
    }
    
    //converts the seconds of the timer into hh:mm:ss format as a string
    func timeIntervalFormat(interval:TimeInterval)-> String
    {
        var seconds = Int(interval + 0.5) //round up seconds
        let HOURS = seconds / 3600
        let MINUTES = (seconds / 60) % 60
        seconds = seconds % 60
        return String(format:"%02i:%02i:%02i",HOURS,MINUTES,seconds)
    }
    
    //converts the pace of the user in meters per second to string formatting
    func paceString(title:String,pace:Double) -> String
    {
        var minPerMile = 0.0
        let FACTOR = 26.8224 //conversion factor
        if pace != 0
        {
            minPerMile = FACTOR / pace
        }
        let MINUTES = Int(minPerMile)
        let SECONDS = Int(minPerMile * 60) % 60
        return String(format: "%@: %02.2f m/s \n\t\t %02i:%02i min/mi",title,pace,MINUTES,SECONDS)
    }
    
    //calculates the avergae pace of the user
    func calculateAveragePace()-> Double
    {
        if let DISTANCE = self.distance
        {
            pace = DISTANCE / timeElapsed
            return pace
        }
        else
        {
            return 0.0
        }
    }
    
    //converts miles to meters
    func miles(meters:Double)-> Double
    {
        let MILE = 0.000621371192
        return meters * MILE
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        startButton.layer.cornerRadius = 10 //rounds the corners of the activate button
        
    }
    
}
