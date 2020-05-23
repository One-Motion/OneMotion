//
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
//    var db: OpaquePointer?
//    var ProfileList = [Profile]()
//    var fName = ""
//    var lName = ""
//    var DofB = ""
//    var Weight = ""
//    var Height = ""
//    var Email = ""
//    self.saveButton.isEnabled = false

    
    /// The Action Button for editing the Profile photo
    @IBAction func changePhotoButton(_ sender: Any) {
        
        let imagePicked = UIImagePickerController()
        imagePicked.delegate = self
        imagePicked.sourceType = .photoLibrary
        
        self.present(imagePicked, animated: true, completion: nil)
    }
    
    /// Concatanates all the user input from the individual textFields
    /// - Returns: String of the concatanation
    func profileInfo() -> String {
        let data1:String = firstName.text ?? "" 
        let data2: String = lastName.text ?? ""
        let data3: String = DOB.text ?? ""
        let data4: String = weight.text ?? ""
        let data5: String = height.text ?? ""
        let data6: String = email.text ?? ""
        let data7: String = data1 + "\n\n" + data2 + "\n\n" + data3 + "\n\n" + data4 + "\n\n" + data5 + "\n\n" + data6
        
        
        return data7
    }
    
    /// Saves the state of Profile Information
    @IBAction func saveProfileButton(_ sender: Any) {
        let userDefaults = UserDefaults()
        userDefaults.set(profileInfo(), forKey: "profileInfo")
        
        ///For Database Purposes
//        let fName = firstName.text?.trimmingCharacters(in:                    .whitespacesAndNewlines)
//        let lName = lastName.text?.trimmingCharacters(in:                     .whitespacesAndNewlines)
//        var DofB = DOB.text?.trimmingCharacters(in:                           .whitespacesAndNewlines)
//        var Weight = weight.text?.trimmingCharacters(in:                      .whitespacesAndNewlines)
//        var Height = height.text?.trimmingCharacters(in:                      .whitespacesAndNewlines)
//        var Email = email.text?.trimmingCharacters(in:                        .whitespacesAndNewlines)
        var imageData = profilePhoto.image!.jpegData(compressionQuality: 1)
        
        //Storing all data into UserDefaults
        UserDefaults.standard.set(imageData, forKey: "profilePic")
        UserDefaults.standard.set(firstName.text, forKey: "firstName")
        UserDefaults.standard.set(lastName.text, forKey: "lastName")
        UserDefaults.standard.set(DOB.text, forKey: "DOB")
        UserDefaults.standard.set(weight.text, forKey: "weight")
        UserDefaults.standard.set(height.text, forKey: "height")
        UserDefaults.standard.set(email.text, forKey: "email")
        UserDefaults.standard.synchronize()
        
        //Testing the data is saved
        print("Data Saved")
        
        //For Database Purposes
//            let ProfilePhoto = profilePhoto.animationImages
//            if (fName?.isEmpty)! {
//                print("First Name is Empty")
//                saveButton.isEnabled = false
//                return;
//            }
//
//            if (lName?.isEmpty)! {
//                print("Last Name is Empty")
//                saveButton.isEnabled = false
//                return;
//            }
//
//            if (DofB?.isEmpty)! {
//                DofB = nil
//                saveButton.isEnabled = false
//                return;
//            }
//
//            if (Weight?.isEmpty)! {
//                Weight = nil
//                saveButton.isEnabled = false
//                return;
//            }
//
//            if (Height?.isEmpty)! {
//                Height = nil
//                saveButton.isEnabled = false
//                return;
//            }
//
//            if (Email?.isEmpty)! {
//                print("Email is Empty")
//                saveButton.isEnabled = false
//                return;
//            }
//            else {
//                self.saveButton.isEnabled = true
//        }
//
//            var stmt: OpaquePointer?
//
//            let insertQuery = "INSERT INTO PROFILE (FNAME, LNAME, DOB, GENDER, WEIGHT, HEIGHT, EMAIL) VALUES (?,?,?,?,?,?,?);"
//
//            if sqlite3_prepare(db, insertQuery, -1, &stmt, nil) != SQLITE_OK {
//                print("Error binding Query")
//            }
//
//            if sqlite3_bind_text(stmt, 1, fName, -1, nil) != SQLITE_OK {
//                print("Error binding FirstName")
//    //            return;
//            }
//
//            if sqlite3_bind_text(stmt, 2, lName, -1, nil) != SQLITE_OK {
//                print("Error binding lastName")
//    //            return;
//            }
//
//            if sqlite3_bind_text(stmt, 3, DofB, -1, nil) != SQLITE_OK {
//                print("Error binding Date of Birth")
//    //            return;
//            }
//
//            if sqlite3_bind_int(stmt, 4, (Weight! as NSString).intValue) != SQLITE_OK {
//                print("Error binding Weight")
//    //            return;
//            }
//
//            if sqlite3_bind_int(stmt, 4, (Height! as NSString).intValue) != SQLITE_OK {
//                print("Error binding Height")
//    //            return;
//            }
//
//            if sqlite3_bind_text(stmt, 7, Email, -1, nil) != SQLITE_OK {
//                print("Error binding Email")
//    //            return;
//            }
//
//            if sqlite3_step(stmt) != SQLITE_DONE {
//                print("Profile Saved Successfully")
//            }
        }
    
    /// creates a path for selecting a photo from the individuals library
    /// - Parameters:UIImagePickerController, Ararsy of UIImagePickerControllerInfoKey
    ///   - picker: Built In UIImagePickerController
    ///   - info: Array of UIImagePickerController of any type
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let profilePicture = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        profilePhoto.image = profilePicture
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Main Run function
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 10.0
        
//For Database Purposes
//                firstName.delegate = self
//                lastName.delegate = self
//                DOB.delegate = self
//                weight.delegate = self
//                height.delegate = self
//                email.delegate = self
//
//        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("OneMotion.sqlite")
//
//        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
//            print("Error Opening database")
//            return
//        }
//
//        let CreateTableQueuery = "CREATE TABLE IF NOT EXISTS PROFILE(FNAME TEXT PRIMARY KEY, LNAME TEXT, DOB TEXT, GENDER TEXT, WEIGHT INTEGER, HEIGHT INTEGER, EMAIL TEXT);"
//        if sqlite3_exec(db, CreateTableQueuery, nil, nil, nil) != SQLITE_OK {
//            print("Error creating table")
//            return
//        }
//
//        readValues()      //Reading from Database
    }
    
    //For Database Purpose
//    func readValues() {
//
//        ProfileList.removeAll()
//
//        let queryString = "SELECT * FROM PROFILE"
//
//        var stmt: OpaquePointer?
//
//        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
//
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error preparing insert: \(errmsg)")
//            return
//        }
//
//        while(sqlite3_step(stmt) == SQLITE_ROW){
//            let fName = sqlite3_column_int(stmt, 0)
//            let lName = String(cString: sqlite3_column_text(stmt, 1))
//            let DOB = sqlite3_column_int(stmt, 2)
//            let gender = sqlite3_column_int(stmt, 3)
//            let weight = sqlite3_column_int(stmt, 4)
//            let height = sqlite3_column_int(stmt, 5)
//            let email = sqlite3_column_int(stmt, 6)
//
//            ProfileList.append(Profile(fName: String(describing: fName), lName: String(describing: lName), DOB: String(describing: DOB), gender: String(describing: gender),                                 weight: Int(weight), height: Int(height), email: String(describing: email)))
//
//            print(ProfileList)
//        }
//    }
    
//    class Profile {
//
//        var fName: String
//        var lName: String
//        var DOB: String
//        var gender: String
//        var weight: Int
//        var height: Int
//        var email: String
//
//        init(fName: String, lName: String, DOB: String, gender: String, weight: Int, height: Int, email: String) {
//
//            self.fName = fName
//            self.lName = lName
//            self.DOB = DOB
//            self.gender = gender
//            self.weight = weight
//            self.height = height
//            self.email = email
//
//        }
//    }
    
    
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
    
    /// Prepares the Segue for calling features from previous view Controllers
    /// - Parameters:UIStoryBoardSegue, Optionals of any
    ///   - segue: The links between ViewControllers on the StoryBoard
    ///   - sender:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ProfileViewController
        vc.finalProfileData = profileInfo()
    }
}


extension UIViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

