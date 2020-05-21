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

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var DOB: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    var db: OpaquePointer?
    var ProfileList = [Profile]()
    var fNameText = ""
    var lNameText = ""
    var DofB = ""
    var Weight = ""
    var Height = ""
    var Email = ""
//    self.saveButton.isEnabled = false
    
    
    @IBAction func changePhotoButton(_ sender: Any) {
        
        let imagePicked = UIImagePickerController()
        imagePicked.delegate = self
        imagePicked.sourceType = .photoLibrary
        
        self.present(imagePicked, animated: true, completion: nil)
    }
    
    @IBAction func saveProfileButton(_ sender: Any) {
        
        let fName = firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let lName = lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var DofB = DOB.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var Weight = weight.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var Height = height.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var Email = email.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        UserDefaults.standard.set(firstName.text, forKey: "firstName")
        UserDefaults.standard.set(lastName.text, forKey: "lastName")
        UserDefaults.standard.set(DOB.text, forKey: "DOB")
        UserDefaults.standard.set(weight.text, forKey: "weight")
        UserDefaults.standard.set(height.text, forKey: "height")
        UserDefaults.standard.set(email.text, forKey: "email")
        
            let ProfilePhoto = profilePhoto.animationImages
            
            if (fName?.isEmpty)! {
                print("First Name is Empty")
                saveButton.isEnabled = false
                return;
            }
            
            if (lName?.isEmpty)! {
                print("Last Name is Empty")
                saveButton.isEnabled = false
                return;
            }
            
            if (DofB?.isEmpty)! {
                DofB = nil
                saveButton.isEnabled = false
                return;
            }
            
            if (Weight?.isEmpty)! {
                Weight = nil
                saveButton.isEnabled = false
                return;
            }
            
            if (Height?.isEmpty)! {
                Height = nil
                saveButton.isEnabled = false
                return;
            }
            
            if (Email?.isEmpty)! {
                print("Email is Empty")
                saveButton.isEnabled = false
                return;
            }
            else {
                self.saveButton.isEnabled = true
        }
            
            var stmt: OpaquePointer?
            
            let insertQuery = "INSERT INTO PROFILE (FNAME, LNAME, DOB, GENDER, WEIGHT, HEIGHT, EMAIL) VALUES (?,?,?,?,?,?,?)"
            
            if sqlite3_prepare(db, insertQuery, -1, &stmt, nil) != SQLITE_OK {
                print("Error binding Query")
            }
            
            if sqlite3_bind_text(stmt, 1, fName, -1, nil) != SQLITE_OK {
                print("Error binding FirstName")
    //            return;
            }
            
            if sqlite3_bind_text(stmt, 2, lName, -1, nil) != SQLITE_OK {
                print("Error binding lastName")
    //            return;
            }
            
            if sqlite3_bind_text(stmt, 3, DofB, -1, nil) != SQLITE_OK {
                print("Error binding Date of Birth")
    //            return;
            }
            
            if sqlite3_bind_int(stmt, 4, (Weight! as NSString).intValue) != SQLITE_OK {
                print("Error binding Weight")
    //            return;
            }
            
            if sqlite3_bind_int(stmt, 4, (Height! as NSString).intValue) != SQLITE_OK {
                print("Error binding Height")
    //            return;
            }
            
            if sqlite3_bind_text(stmt, 7, Email, -1, nil) != SQLITE_OK {
                print("Error binding Email")
    //            return;
            }
            
            if sqlite3_step(stmt) != SQLITE_DONE {
                print("Profile Saved Successfully")
            }
            
                print("button was pressed")
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        profilePhoto.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//                firstName.delegate = self
//                lastName.delegate = self
//                DOB.delegate = self
//                weight.delegate = self
//                height.delegate = self
//                email.delegate = self
        
//        saveButton.layer.cornerRadius÷ = 10.0


        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("OneMotion.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error Opening database")
            return
        }
        
        let CreateTableQueuery = "CREATE TABLE IF NOT EXISTS PROFILE(FNAME TEXT PRIMARY KEY, LNAME TEXT, DOB TEXT, GENDER TEXT, WEIGHT INTEGER, HEIGHT INTEGER, EMAIL TEXT)"
        if sqlite3_exec(db, CreateTableQueuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
            return
        }
        
        readValues()
    }
    
    func readValues() {
        
        ProfileList.removeAll()
        
        let queryString = "SELECT * FROM PROFILE"
        
        var stmt: OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let fName = sqlite3_column_int(stmt, 0)
            let lName = String(cString: sqlite3_column_text(stmt, 1))
            let DOB = sqlite3_column_int(stmt, 2)
            let gender = sqlite3_column_int(stmt, 3)
            let weight = sqlite3_column_int(stmt, 4)
            let height = sqlite3_column_int(stmt, 5)
            let email = sqlite3_column_int(stmt, 6)
            
            ProfileList.append(Profile(fName: String(describing: fName), lName: String(describing: lName), DOB: String(describing: DOB), gender: String(describing: gender),                                 weight: Int(weight), height: Int(height), email: String(describing: email)))
            
            print(ProfileList)
        }
    }
    
    class Profile {
        
        var fName: String
        var lName: String
        var DOB: String
        var gender: String
        var weight: Int
        var height: Int
        var email: String
        
        init(fName: String, lName: String, DOB: String, gender: String, weight: Int, height: Int, email: String) {
            
            self.fName = fName
            self.lName = lName
            self.DOB = DOB
            self.gender = gender
            self.weight = weight
            self.height = height
            self.email = email
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        weight.resignFirstResponder()
        height.resignFirstResponder()
    }
    
    
//    @IBAction func saveTapped(_ sender: Any) {
//        self.fNameText = firstName.text!
//        self.lNameText = lastName.text!
//        self.DofB = DOB.text!
//        self.Weight = weight.text!
//        self.Height = height.text!
//        self.Email = email.text!
//
//        UserDefaults.standard.set(fNameText, forKey: "firstName")
//        UserDefaults.standard.set(lNameText, forKey: "lastName")
//        UserDefaults.standard.set(DofB, forKey: "DOB")
//        UserDefaults.standard.set(Weight, forKey: "weight")
//        UserDefaults.standard.set(Height, forKey: "height")
//        UserDefaults.standard.set(Email, forKey: "email")
//

////        performSegue(withIdentifier: "saveProfile", sender: self)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ProfileViewController
//        vc.finalProfileData = self.fNameText + "\n\n" + self.lNameText
    }
}
extension UIViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
