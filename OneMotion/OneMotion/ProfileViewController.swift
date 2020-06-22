//
//  ProfileViewController.swift
//  OneMotion
//
//  Created by Jason Vainikolo on 13/05/20.
//  Copyright © 2020 Jason Vainikolo. All rights reserved.
//  testing pull

import UIKit
import SQLite3

class ProfileViewController: UIViewController, UITableViewDelegate {
    
    ///IBOutlets in the current ViewController
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileData: UITextView!
    @IBOutlet weak var editButton: UIButton!
//    var finalProfileData: String!
    var db: OpaquePointer?
    
    /// Refreshes the state of the current ViewController with possible updated text in the UserDefaults
    /// - Parameter animated: takes a Boolean parameter
    override func viewWillAppear(_ animated: Bool) {
        
        //OPENS THE CONNECTION
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("OneMotion.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error Opening database")
            return
        }
        
        //Creates table iF it doesn't exist
        let CreateTableQueuery = "CREATE TABLE IF NOT EXISTS PROFILE(ID INTEGER PRIMARY KEY AUTOINCREMENT, FNAME TEXT, LNAME TEXT, DOB TEXT, WEIGHT INTEGER, HEIGHT INTEGER, EMAIL TEXT, PROFILEPIC);"
        if sqlite3_exec(db, CreateTableQueuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
            return
        }
        
        print("Successfully Connected to the Profile table")
        
        //get data from the database
        var queryStatement: OpaquePointer? = nil
        let selectQuery = "SELECT * FROM PROFILE"
        if sqlite3_prepare(db, selectQuery, -1, &queryStatement, nil) == SQLITE_OK{
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                // 3
                let id = sqlite3_column_int(queryStatement, 0)
                let weight = sqlite3_column_int(queryStatement, 5)
                let height = sqlite3_column_int(queryStatement, 6)
                // 4
                
                let name1 = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let name2 = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let name3 = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let name7 = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                let name8 = String(describing: String(cString: sqlite3_column_text(queryStatement, 8)))
                // 5
                
                //Saves all the gathered Data into a variable
                print("\nQuery Result:")
                print("\n\(id) | \(name1) | \(name2) | \(name3) | \(weight) | \(height) | \(name7)")
                self.profileData.text = "\(name1) \n\n \(name2) \n\n \(name3) \n\n \(weight) \n\n \(height) \n\n \(name7)"
                
//              let dataDecoded:NSData = NSData(base64Encoded: name8, options: NSData.Base64DecodingOptions(rawValue: 0))!
                let decodedData = Data(base64Encoded: name8, options: .ignoreUnknownCharacters)!
                let decodedimage:UIImage = UIImage(data: decodedData)!
                self.profilePicture.image = decodedimage
                
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
    
    func delete() {
        let deleteStatementString = "DELETE FROM PROFILE WHERE Id = 1;"
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

    
    ///Main function for current viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileData.isEditable = false
        editButton.layer.cornerRadius = 10.0
//        self.profileData.text = finalProfileData
        
    }
}
