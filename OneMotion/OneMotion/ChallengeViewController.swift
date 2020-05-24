//
//  ChallengeViewController.swift
//  OneMotion
//
//  Created by Mridula Manderwad on 19/05/20.
//  Copyright © 2020 Grace Subianto. All rights reserved.
// Test

import UIKit

class ChallengeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
       
    //these are the setups to all the public variables
    @IBOutlet weak var repNumber: UITextField!
    @IBOutlet weak var setNumber: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var timetaken: UITextField!
    @IBOutlet weak var workout: UITextField!
    //setting up my view picker with the options that the user can choose
    
    let workouts = ["Sit-Up", "Push-Up", "Squats", "Pull-Ups"]
    let pickerView = UIPickerView()
    let datePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createDatePicker()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        workout.inputView = pickerView
        workout.textAlignment = .center
        
        repNumber.delegate = self
        setNumber.delegate = self
        timetaken.delegate = self
               
        
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return workouts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return workouts[row]
    }
    // this function shows the different options that the user can select from,
    //it also contains the first responder feature that hides the keyboard when the user clicks outside of the keyboard
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        workout.text = workouts[row]
        workout.resignFirstResponder()
    }

    //this function creates the date picker and formatts it for a user friendly version
    // it has been edited to display only what is required to the user to save their workout
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
  
    // this function sets the done pressed button to save the data the user has selected from the createdatepicker dunction
    @objc func donePressed(){
        
        //formatting
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        date.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    //this function hides the keyboard when the user touches outside of the popup keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        repNumber.resignFirstResponder()
        setNumber.resignFirstResponder()
        timetaken.resignFirstResponder()
    }
    
    //this button is still under construction.
    @IBAction func saveWorkout(_ sender: Any) {
        // this button will essentially send the workout challenge created to another user of the app
    }
    
}



