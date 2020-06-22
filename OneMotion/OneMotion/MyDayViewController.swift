//
//  ViewController.swift
//  OneMotion
//
//  Created by Ehsaas Grover on 21/05/20.
//  Copyright © 2020 Ehsaas Grover. All rights reserved.
//

import UIKit
import SQLite3

class MyDayViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    

    @IBOutlet weak var dateSelecter: UITextField!
    @IBOutlet weak var mood: UITextField!
    @IBOutlet weak var saveDetails: UIButton!
    @IBOutlet weak var breakfast: UITextField!
    @IBOutlet weak var lunch: UITextField!
    @IBOutlet weak var dinner: UITextField!
    
    var db: OpaquePointer?
    let moods = ["Happy", "Neutral", "Sad",                 "Angry","Stressed","Anxious","Excited"]
    let pickerView = UIPickerView()
    let datePicker = UIDatePicker()
        
    override func viewDidLoad() {
            super.viewDidLoad()
            createDatePicker()
            
            pickerView.delegate = self
            pickerView.dataSource = self
            mood.inputView = pickerView
            mood.textAlignment = .center
            
        breakfast.delegate = self
        lunch.delegate = self
        dinner.delegate = self
                            
        }

    func insertMyDay(recordedDate: String, breakfast: String, lunch: String, dinner: String, mood: String) {
        
        var insertStmt: OpaquePointer?
        let insertQuery = "INSERT INTO MYDAY(DATE, BREAKFAST, LUNCH, DINNER, MOOD) VALUES (?,?,?,?,?)"
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStmt, nil) == SQLITE_OK {
                
            let RecordedDate: NSString = recordedDate as NSString
            let Breakfast: Int32 = (breakfast as NSString).intValue
            let Lunch: Int32 = (lunch as NSString).intValue
            let Dinner: Int32 = (dinner as NSString).intValue
            let Mood: NSString = mood as NSString
            
            sqlite3_bind_text(insertStmt, 1, RecordedDate.utf8String, -1, nil)
            sqlite3_bind_int(insertStmt, 2, Breakfast)
            sqlite3_bind_int(insertStmt, 3, Lunch)
            sqlite3_bind_int(insertStmt, 4, Dinner)
            sqlite3_bind_text(insertStmt, 2, Mood.utf8String, -1, nil)
            
            
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
    
    func delete() {
        let deleteStatementString = "DELETE FROM PROFILE;"
        var deleteStatement: OpaquePointer?
          if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) ==
              SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
              print("\nSuccessfully deleted row.")
            } else {
              print("\nCould not delete row.")
            }
          } else {
            print("\nDELETE statement could not be prepared")
          }
          
          sqlite3_finalize(deleteStatement)
    }
    
        // Setting up the picker view
        public func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return moods.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return moods[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            mood.text = moods[row]
            mood.resignFirstResponder()
        }

        // Implementing the date picker
        func createDatePicker(){
            
            // Allignment
            dateSelecter.textAlignment = .center

            
            // Toolbear
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            
            // Bar button
            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
            toolbar.setItems([doneBtn], animated: true)
            
            // Assign toolbar to keyboard
            dateSelecter.inputAccessoryView = toolbar
            
            
            // Assign datepicker to textfield
            dateSelecter.inputView = datePicker
            
            
            // Date picker mode
            datePicker.datePickerMode = .date
        }
      
        // When done button is pressed
        @objc func donePressed(){
            
            //Formatting
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            
            dateSelecter.text = formatter.string(from: datePicker.date)
            self.view.endEditing(true)
        }
        
        // When the breakfast, lunch and dinner options are pressed
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            breakfast.resignFirstResponder()
            lunch.resignFirstResponder()
            dinner.resignFirstResponder()
        }

    // Action for when save button is pressed
    @IBAction func saveButton(_ sender: Any) {
        
        //Opens the Connection
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("OneMotion.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error Opening database")
            return
        }
        
        //cleans the table
        self.delete()
        
        self.insertMyDay(recordedDate: self.dateSelecter.text ?? " ", breakfast: self.breakfast.text ?? " ", lunch: self.lunch.text ?? " ", dinner: self.dinner.text ?? " ", mood: self.mood.text ?? " ")
        print("Saved")
    }
    
        
    }



    
    


