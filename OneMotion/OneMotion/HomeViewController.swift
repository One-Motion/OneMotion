//
//  HomeViewController.swift
//  OneMotion
//
//  Created by Jason Vainikolo on 12/05/20.
//  Copyright © 2020 Jason Vainikolo. All rights reserved.
// new me

import UIKit
import SQLite3
import UserNotifications

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
    
    var db: OpaquePointer?
    
    
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
        
        //Opens the Connection
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("OneMotion.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error Opening database")
            return
        }
        
        //Creates table is it doesn't exist
        let CreateTableQueuery = "CREATE TABLE IF NOT EXISTS PROFILE(ID INTEGER PRIMARY KEY AUTOINCREMENT, FNAME TEXT, LNAME TEXT, DOB TEXT, GENDER TEXT, WEIGHT INTEGER, HEIGHT INTEGER, EMAIL TEXT, PROFILEPIC TEXT);"
        if sqlite3_exec(db, CreateTableQueuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
            return
        }
        print("Successfully Connected1")
        
        
        ///DailyNotificationController - GS
        //Asking for permission
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound])
        { granted, error in
        }
        //Create the notification content
        let content = UNMutableNotificationContent()
        content.title = "OneMotion Daily Reminder"
        content.body = "Check in today and add your stats!"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        //Create the notification triggers
//        let date = Date().addingTimeInterval(10)
//        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        //Creating the notification trigger for daily notifications
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.weekday = 2  // Monday
        dateComponents.hour = 9 //12:00 hours
        dateComponents.minute = 3 //minute of the hour
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        //Register the request
        center.add(request) { (error) in }
        
        ///InstantNotificationCOntroller - GS
        //Asking for permission
        //Create the notification content
        let contentInstant = UNMutableNotificationContent()
        contentInstant.title = "OneMotion Misses You!"
        contentInstant.body = "Have you logged your stats today?"
        contentInstant.categoryIdentifier = "alarm"
        contentInstant.userInfo = ["customData": "fizzbuzz"]
        contentInstant.sound = .default
        //Create the notification triggers
        let dateInstant = Date().addingTimeInterval(10)
        let dateComponentsInstant = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateInstant)
        let triggerInstant = UNCalendarNotificationTrigger(dateMatching: dateComponentsInstant, repeats: true)
        //Create the request
        let uuidStringInstant = UUID().uuidString
        let requestInstant = UNNotificationRequest(identifier: uuidStringInstant, content: contentInstant, trigger: triggerInstant)
        //Register the request
        center.add(requestInstant) { (error) in }
        
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
