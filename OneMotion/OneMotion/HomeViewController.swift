//  HomeViewController.swift
//  OneMotion
//
//  Created by Jason Vainikolo on 12/05/20.
//  Copyright © 2020 Jason Vainikolo. All rights reserved.

import UIKit
import SQLite3
import UserNotifications

class HomeViewController: UIViewController {
    
    ///Declared Buttons from the main storyboard
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var viewProfileButton: UIButton!
    @IBOutlet weak var addWorkoutButton: UIButton!
    @IBOutlet weak var CreateChallengeButton: UIButton!
    @IBOutlet weak var ViewProgressButton: UIButton!
    @IBOutlet weak var myDayButton: UIButton!
    @IBOutlet weak var StepTrackerButton: UIButton! //added this for the step track
    @IBOutlet weak var GoalButton:  UIButton! //added this for the goals screen - GS
    
    var db: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Calling the Home Page Button Display function
        startButton.layer.cornerRadius = startButton.frame.width / 2            
        HPButton(button: viewProfileButton)
        HPButton(button: addWorkoutButton)
        HPButton(button: CreateChallengeButton)
        HPButton(button: ViewProgressButton)
        HPButton(button: myDayButton)
        HPButton(button: StepTrackerButton) //added this for the step track screen - GS
        HPButton(button: GoalButton) //added this for the goals screen - GS
        
        //Opens the Connection
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("OneMotion.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error Opening database")
            return
        }
        
        //Creates table is it doesn't exist
        let createTableQueuery = "CREATE TABLE IF NOT EXISTS PROFILE(ID INTEGER PRIMARY KEY AUTOINCREMENT, FNAME TEXT, LNAME TEXT, DOB TEXT, GENDER TEXT, WEIGHT INTEGER, HEIGHT INTEGER, EMAIL TEXT, PROFILEPIC TEXT);"
        if sqlite3_exec(db, createTableQueuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
            return
        }
        print("Successfully Connected to Profile Table")
        
        let createWorkoutTableQuery = "CREATE TABLE IF NOT EXISTS WORKOUT(TITLE TEXT PRIMARY KEY, DATE TEXT, TYPEOFWORKOUT TEXT, REPS INTEGER, SETS INTEGER, TIMETAKEN INTEGER);"
        
        if sqlite3_exec(db, createWorkoutTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
            return
        }
        
        print("Successfully Created/Connect to Workout table.")
        
        let createStepTableQuery = "CREATE TABLE IF NOT EXISTS STEPS(STEPS INTEGER, DISTANCE INTEGER);"
        
        if sqlite3_exec(db, createStepTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
            return
        }
        
        print("Successfully Connected to steps table.")
        
        let createChallengeTableQuery = "CREATE TABLE IF NOT EXISTS CHALLENGE(TITLE TEXT PRIMARY KEY, DATE TEXT, TYPEOFWORKOUT TEXT, REPS INTEGER, SETS INTEGER, TIMETAKEN INTEGER);"
        
        if sqlite3_exec(db, createChallengeTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
            return
        }
        print("Successfully Connected to challenge table.")
        
        let createRunTableQuery = "CREATE TABLE IF NOT EXISTS RUN(DISTANCE FLOAT, TIME FLOAT, PACE FLOAT);"
        
        if sqlite3_exec(db, createRunTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
            return
        }
        
        print("Successfully Connected to run table.")
        
        let createMyDayTableQuery = "CREATE TABLE IF NOT EXISTS MYDAY(DATE INTEGER, BREAKFAST INTEGER, LUNCH INTEGER, DINNER INTEGER, MOOD TEXT);"
        
        if sqlite3_exec(db, createMyDayTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
            return
        }
        
        print("Successfully Connected to MyDay table.")
        
        //calls the function responsible for scheduling and prompting notifications - GS
        self.notificationController()
        
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
    
    //a function that controls the notifications feature of the application - GS
    func notificationController()
    {
        
        //Asking phone notification center for permission
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound])
        { granted, error in
        }
        
        ///DailyNotificationController
        //Creates the notification content for daily notifications
        let contentDaily = UNMutableNotificationContent()
        contentDaily.title = "OneMotion Daily Reminder"
        contentDaily.body = "Check in today and add your stats!"
        contentDaily.categoryIdentifier = "alarm"
        contentDaily.userInfo = ["customData": "fizzbuzz"]
        contentDaily.sound = .default
        
        //Creating the notification trigger for daily notifications
        var dateComponentsDaily = DateComponents()
        dateComponentsDaily.calendar = Calendar.current
        dateComponentsDaily.hour = 12 //12:00pm every day
        
        let triggerDaily = UNCalendarNotificationTrigger(dateMatching: dateComponentsDaily, repeats: true)
        
        //Create the unique request
        let uuidStringDaily = UUID().uuidString
        let requestDaily = UNNotificationRequest(identifier: uuidStringDaily, content: contentDaily, trigger: triggerDaily)
        
        //Registers the request in the notification center
        center.add(requestDaily) { (error) in
            //check the error parameter and handle any errors
        }
        
        ///InstantNotificationController
        //Creates the notification content for right when you close the application
        let contentInstant = UNMutableNotificationContent()
        contentInstant.title = "OneMotion Misses You!"
        contentInstant.body = "Have you logged your stats today?"
        contentInstant.categoryIdentifier = "alarm"
        contentInstant.userInfo = ["customData": "fizzbuzz"]
        contentInstant.sound = .default
        
        //Creates the notification triggers
        let dateInstant = Date().addingTimeInterval(10)
        let dateComponentsInstant = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateInstant)
        let triggerInstant = UNCalendarNotificationTrigger(dateMatching: dateComponentsInstant, repeats: true)
        
        //Creates the unique request
        let uuidStringInstant = UUID().uuidString
        let requestInstant = UNNotificationRequest(identifier: uuidStringInstant, content: contentInstant, trigger: triggerInstant)
        
        //Registers the request in the notifcation center
        center.add(requestInstant) { (error) in }
    }
}

