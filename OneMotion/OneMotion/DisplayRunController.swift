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

class DisplayRunController : UIViewController{
    
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
            let selectQuery = "SELECT * FROM RUN"
            if sqlite3_prepare(db, selectQuery, -1, &queryStatement, nil) == SQLITE_OK{
        
                if sqlite3_step(queryStatement) == SQLITE_ROW{
                    let distance = sqlite3_column_double(queryStatement, 1)
                    let time = sqlite3_column_double(queryStatement,2)
                    let pace = sqlite3_column_double(queryStatement,3)
                
                    print("\nQuery Result: ")
                    print("\n\(distance) | \(time) | \(pace)")

                    self.textField.text = "\(distance) \n\n \(time) \n\n \(pace)"
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
        self.textField.isEditable = false;
    }
        
        
        
        
        
        
        
        
        
        
        
}
