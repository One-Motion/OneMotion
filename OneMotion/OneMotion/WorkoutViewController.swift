//
//  WorkoutViewController.swift
//  OneMotion
//
//  Created by Mridula Manderwad on 19/05/20.
//  Copyright © 2020 Grace Subianto. All rights reserved.
//

import UIKit
import SQLite3

class WorkoutViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    // this is a protocol set into place that allows the system to transfer data from one navigation controller to another
    var delegate: WorkoutProtocol? = nil
    
    //this is the set up of all the variables that the user would input into the text fields.

    @IBOutlet weak var repNumber: UITextField!
    @IBOutlet weak var setNumber: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var timetaken: UITextField!
    @IBOutlet weak var workoutTitle: UITextField!
    @IBOutlet weak var titleText: UITextField!
    
    //For the DataBase
    var db: OpaquePointer?
    
    //creating a list of workouts that the user can select from
    let workouts = ["Sit-Up", "Push-Up", "Squats", "Pull-Ups"]
    let pickerView = UIPickerView()
    let datePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createDatePicker()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        workoutTitle.inputView = pickerView
        workoutTitle.textAlignment = .center
        
        repNumber.delegate = self
        setNumber.delegate = self
        timetaken.delegate = self
               
        
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func workoutInfo(title: String, workoutDate: String, typeOfWorkout: String, reps: Int, sets: Int, workoutTime: Int) {
        
        let createTableQuery = "CREATE TABLE IF NOT EXISTS WORKOUT(TITLE TEXT PRIMARY KEY, DATE TEXT, TYPEOFWORKOUT TEXT, #REPS INTEGER, #SETS INTEGER, TIMETAKEN INTEGER);"
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
            return
        }
        print("Successfully Connected to Workout table.")
        
        //get data from the database
//        var queryStatement: OpaquePointer? = nil
//        let selectQuery = "SELECT * FROM WORKOUT"
//        
        
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return workouts.count
    }
    // this is the display for the user to select which workout they have completed.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return workouts[row]
    }
    // this function hides the picker view when the user clicks outside of the picker view or the user selects whcich workout they have completed
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        workoutTitle.text = workouts[row]
        workoutTitle.resignFirstResponder()
    }

    // this function creates and formatts the date picker which allows the user to select what date they have completed their workout
    func createDatePicker(){
        
        // allignment
        date.textAlignment = .center

        
        //toolbear
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        //assign toolbar to keyboard
        date.inputAccessoryView = toolbar
        
        
        //asign datepicker to textfield
        date.inputView = datePicker
        
        //date picker mode
        datePicker.datePickerMode = .date
    }
  
    // this function hides the date picker view whenthe user clicks the done button
    @objc func donePressed(){
        
        //formatting
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        date.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    // this function hides the keyboard once the user clicks outside of the popup keyboard that they input their workout information in
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        repNumber.resignFirstResponder()
        setNumber.resignFirstResponder()
        timetaken.resignFirstResponder()
    }
    
    // this button saves their workout information into the tableview and calls upon the get data function which is part of another function that allows the system to send text field user input from one navifation controller to another.
    @IBAction func Save(_ sender: Any) {
        
        print("done")
        self.dismiss(animated: true, completion: nil)
        self.delegate?.getData(data: titleText.text!)
        
        
        
    }
}

