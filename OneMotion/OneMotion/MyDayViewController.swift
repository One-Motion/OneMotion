//
//  ViewController.swift
//  OneMotion
//
//  Created by Ehsaas Grover on 21/05/20.
//  Copyright © 2020 Ehsaas Grover. All rights reserved.
//

import UIKit

class MyDayViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    

    @IBOutlet weak var dateSelecter: UITextField!
    @IBOutlet weak var mood: UITextField!
    @IBOutlet weak var saveDetails: UIButton!
    @IBOutlet weak var breakfast: UITextField!
    @IBOutlet weak var lunch: UITextField!
    @IBOutlet weak var dinner: UITextField!
    
        let moods = ["Happy", "Neutral", "Sad", "Angry","Stressed","Anxious","Excited"]
        let pickerView = UIPickerView()
        let datePicker = UIDatePicker()
        
    override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            createDatePicker()
            
            pickerView.delegate = self
            pickerView.dataSource = self
            mood.inputView = pickerView
            mood.textAlignment = .center
            
        breakfast.delegate = self
        lunch.delegate = self
        dinner.delegate = self
                            
        }

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


        func createDatePicker(){
            
            // allignment
            dateSelecter.textAlignment = .center

            
            //toolbear
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            
            //bar button
            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
            toolbar.setItems([doneBtn], animated: true)
            
            //assign toolbar to keyboard
            dateSelecter.inputAccessoryView = toolbar
            
            
            //asign datepicker to textfield
            dateSelecter.inputView = datePicker
            
            
            //date picker mode
            datePicker.datePickerMode = .date
        }
      
        
        @objc func donePressed(){
            
            //formatting
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            
            dateSelecter.text = formatter.string(from: datePicker.date)
            self.view.endEditing(true)
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            breakfast.resignFirstResponder()
            lunch.resignFirstResponder()
            dinner.resignFirstResponder()
        }
        

        
    @IBAction func saveButton(_ sender: Any) {
        print("Saved")
    }
    
        
    }



    
    


