//
//  DisplayRunController.swift
//  OneMotion
//
//  Created by Jason Vainikolo on 22/06/20.
//  Copyright © 2020 Jason Vainikolo. All rights reserved.
//

import Foundation
import UIKit
import SQLite3

class DisplayMyDayController : UIViewController{
    
    @IBOutlet weak var myDayText: UITextView!
    var db: OpaquePointer?
    override func viewWillAppear(_ animated: Bool) {
           
           //OPENS THE CONNECTION
           let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("OneMotion.sqlite")

           if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
               print("Error Opening database")
               return
           }
            var queryStatement: OpaquePointer? = nil
            let selectQuery = "SELECT * FROM MYDAY"
            if sqlite3_prepare(db, selectQuery, -1, &queryStatement, nil) == SQLITE_OK{
        
                if sqlite3_step(queryStatement) == SQLITE_ROW{
                    let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                    let breakfast = sqlite3_column_int(queryStatement, 1)
                    let lunch = sqlite3_column_int(queryStatement, 2)
                    let dinner = sqlite3_column_int(queryStatement, 3)
                let mood = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                    
                    print("\nQuery Result: ")
                    print("\n\(date) | \(breakfast) | \(lunch) | \(dinner) | \(mood)")

                    self.myDayText.text = "\(date) \n\n \(breakfast) \n\n \(lunch) \n\n \(dinner) \n\n \(mood)"
                    print("Successfully gathered Data!")
                } else{
                    print("\nQuery returned no results.")
                }
        }
            else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
                
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myDayText.isEditable = false;
    }
}
