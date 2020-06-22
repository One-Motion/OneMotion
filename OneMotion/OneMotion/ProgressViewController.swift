//
//  ProgressViewController.swift
//  OneMotion
//
//  Created by Grace Subianto on 22/05/20.
//  Copyright © 2020 Jason Vainikolo. All rights reserved.
//

import Foundation
import UIKit
import SQLite3

class ProgressViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, WorkoutProtocol {
    // this is the creating of the text view which stores the users workout history
    var tableData: [String] = []
    @IBOutlet weak var textField: UITextView!
    var db: OpaquePointer?
    
    override func viewWillAppear(_ animated: Bool) {
        
        //OPENS THE CONNECTION
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("OneMotion.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error Opening database")
            return
        }
        
        var queryStatement: OpaquePointer? = nil
        let selectQuery = "SELECT * FROM WORKOUT"
        if sqlite3_prepare(db, selectQuery, -1, &queryStatement, nil) == SQLITE_OK{
            
                    if sqlite3_step(queryStatement) == SQLITE_ROW {
                        // 3
                        let title =  String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                        let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                        let typeOfWorkout = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                        
                        let reps = sqlite3_column_int(queryStatement, 3)
                        let sets = sqlite3_column_int(queryStatement, 4)
                        let TimeTaken = sqlite3_column_int(queryStatement,5)
                        
                        
                        
                        //Saves all the gathered Data into a variable
                        print("\nQuery Result:")
                        print("\n\(title) | \(date) | \(typeOfWorkout) | \(reps) | \(sets) | \(TimeTaken)")
                            
                        self.textField.text = "\(title) \n\n \(date) \n\n \(typeOfWorkout) \n\n \(reps) \n\n \(sets) \n\n \(TimeTaken)"
                        
                        print("Successfully gathered Data!")
                    } else {
                        print("\nQuery returned no results.")
                    }
                    } else {
                        // 6
                      let errorMessage = String(cString: sqlite3_errmsg(db))
                      print("\nQuery is not prepared \(errorMessage)")
                    }
                    // 7
                    sqlite3_finalize(queryStatement)
        
        
        
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        self.textField.isEditable = false
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    //this allows the user to open each workout to view the details of the workout -- still under construction. 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.tableData[indexPath.row]
        return cell
    }
    // this function gets the user input data from the text field in the WorkoutViewController and places it into the tableview
    func getData(data: String) {
        self.performSegue(withIdentifier: "Add Segue", sender: self)
        self.tableData.append(data)
    }
    // this function overrides the prepare code and allows the user input to be transferred from one navigation controller to another without losing the information
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Add Segue"
        {
            let vc = segue.destination as! WorkoutViewController
            vc.delegate = self
        }
    }
    
    
}
