//
//  ProfileViewController.swift
//  OneMotion
//
//  Created by Jason Vainikolo on 13/05/20.
//  Copyright © 2020 Jason Vainikolo. All rights reserved.
// new edit, new changes

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileData: UITextView!
    @IBOutlet weak var editButton: UIButton!
    var finalProfileData: String!

    var fName: String = UserDefaults.standard.string(forKey: "firstName") ?? " "
    var lName: String = UserDefaults.standard.string(forKey: "lastName") ?? " "
    var DofB: String = UserDefaults.standard.string(forKey: "DOB") ?? " "
    var weight: String = UserDefaults.standard.string(forKey: "weight") ?? " "
    var height: String = UserDefaults.standard.string(forKey: "height") ?? " "
    var email: String = UserDefaults.standard.string(forKey: "email") ?? " "
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults()
        if let data = userDefaults.object(forKey: "profileInfo") {
            if let message = data as? String {
                self.profileData.text = message
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileData.isEditable = false
        editButton.layer.cornerRadius = 10.0
        self.profileData.text = finalProfileData
        
//    profileData.text = fName + "\n\n" + lName + "\n\n" + DofB + "\n\n" + weight + "\n\n" + height + "\n\n" + email
    }
}



