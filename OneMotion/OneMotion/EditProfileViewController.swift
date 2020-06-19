//  EditProfileViewController.swift
//  OneMotion
//
//  Created by Jason Vainikolo on 20/05/20.
//  Copyright © 2020 Jason Vainikolo. All rights reserved.
//

import UIKit
import SQLite3

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    ///All the IBOutlets for the UITextFields, UIImageViews, and UIButtons
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var DOB: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    //For Database Purpose
    var db: OpaquePointer?
    
    var profilePic: String = "?"
    
    /// The Action Button for editing the Profile photo
    @IBAction func changePhotoButton(_ sender: Any) {
        
        let imagePicked = UIImagePickerController()
        imagePicked.delegate = self
        imagePicked.sourceType = .photoLibrary
        self.present(imagePicked, animated: true, completion: nil)
    }
    
    /// Saves the state of Profile Information
    @IBAction func saveProfileButton(_ sender: Any) {

        //Opens the Connection
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("OneMotion.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error Opening database")
            return
        }
        
        //cleans the table
        delete()
        
        insertProfile(fName: self.firstName.text ?? " ", lName: self.lastName.text ?? " ", DofB: self.DOB.text ?? " ", Weight: self.weight.text ?? " ", Height: self.height.text ?? " ", Email: self.email.text ?? " ", profilePic: self.profilePic)
        print("Update Successful!")
        }
    
    func insertProfile(fName: String, lName: String, DofB: String, Weight: String, Height: String, Email: String, profilePic: String) {
        var insertStmt: OpaquePointer?
        let insertQuery = "INSERT INTO PROFILE(FNAME, LNAME, DOB, WEIGHT, HEIGHT, EMAIL, PROFILEPIC) VALUES (?,?,?,?,?,?,?);"

        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStmt, nil) == SQLITE_OK {
                
            let firstName: NSString = fName as NSString
            let lastName: NSString = lName as NSString
            let DOB: NSString = DofB as NSString
            let weight: Int32 = (Weight as NSString).intValue
            let height: Int32 = (Height as NSString).intValue
            let email: NSString = Email as NSString
            
            sqlite3_bind_text(insertStmt, 1, firstName.utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 2, lastName.utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 3, DOB.utf8String, -1, nil)
            sqlite3_bind_int(insertStmt, 4, weight)
            sqlite3_bind_int(insertStmt, 5, height)
            sqlite3_bind_text(insertStmt, 6, email.utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 7, profilePic, -1, nil)
            
            if sqlite3_step(insertStmt) == SQLITE_DONE {
                print("\nSuccessfully inserted row")
            } else {
                print("\nCould not insert row")
            }
        } else {
            print("\nInsert Statement not prepared")
        }
        sqlite3_finalize(insertStmt)
    }
    
    /// creates a path for selecting a photo from the individuals library
    /// - Parameters:UIImagePickerController, Ararsy of UIImagePickerControllerInfoKey
    ///   - picker: Built In UIImagePickerController
    ///   - info: Array of UIImagePickerController of any type
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let profilePicture = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.profilePhoto.image = profilePicture
        var imageData: NSData
        imageData = profilePhoto.image!.pngData()! as NSData
        self.profilePic = imageData.base64EncodedString(options: .lineLength64Characters)
        self.dismiss(animated: true, completion: nil)
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
    
    /// Main Run function
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 10.0
    }
    
    /// Dismiss the keyboard when selecting away from the key board
    /// - Parameters:Set<UITouch>, UIEvent
    ///   - touches: A set of UITouch
    ///   - event: calls an optional UIEvent
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        weight.resignFirstResponder()
        height.resignFirstResponder()
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        DOB.resignFirstResponder()
        email.resignFirstResponder()
    }
}

extension UIViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
