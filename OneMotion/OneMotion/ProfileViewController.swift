//
//  ProfileViewController.swift
//  OneMotion
//
//  Created by Jason Vainikolo on 13/05/20.
//  Copyright © 2020 Jason Vainikolo. All rights reserved.
// new changes

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileData: UITextView!
    @IBOutlet weak var editButton: UIButton!
    var finalProfileData: String = ""
    
    var fName: String = UserDefaults.standard.string(forKey: "firstName") ?? " "
    var lName: String = UserDefaults.standard.string(forKey: "lastName") ?? " "
    var DofB: String = UserDefaults.standard.string(forKey: "DOB") ?? " "
    var weight: String = UserDefaults.standard.string(forKey: "weight") ?? " "
    var height: String = UserDefaults.standard.string(forKey: "height") ?? " "
    var email: String = UserDefaults.standard.string(forKey: "email") ?? " "
    
    func profileInfo() -> String {
        
        let data =  self.fName + "\n\n" + self.lName + "\n\n" + self.DofB + "\n\n" + self.weight + "\n\n" + self.height + "\n\n" + self.email
        
        return data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileData.isEditable = false
        editButton.layer.cornerRadius = 10.0
        profileData.text = profileInfo()
        
//    profileData.text = fName + "\n\n" + lName + "\n\n" + DofB + "\n\n" + weight + "\n\n" + height + "\n\n" + email
        
        
    }
    

    

    

    

 
    
    
}



