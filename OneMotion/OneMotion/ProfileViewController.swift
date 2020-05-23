//
//  ProfileViewController.swift
//  OneMotion
//
//  Created by Jason Vainikolo on 13/05/20.
//  Copyright © 2020 Jason Vainikolo. All rights reserved.
//  testing pull

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate {
    
    ///IBOutlets in the current ViewController
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileData: UITextView!
    @IBOutlet weak var editButton: UIButton!
    var finalProfileData: String!

    ///Gets all the Profile Information saved in the UserDefaults
    var fName: String = UserDefaults.standard.string(forKey: "firstName") ?? " "
    var lName: String = UserDefaults.standard.string(forKey: "lastName") ?? " "
    var DofB: String = UserDefaults.standard.string(forKey: "DOB") ?? " "
    var weight: String = UserDefaults.standard.string(forKey: "weight") ?? " "
    var height: String = UserDefaults.standard.string(forKey: "height") ?? " "
    var email: String = UserDefaults.standard.string(forKey: "email") ?? " "
    
    /// Refreshes the state of the current ViewController with possible updated text in the UserDefaults
    /// - Parameter animated: takes a Boolean parameter
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults()
        if let data = userDefaults.object(forKey: "profileInfo") {
            if let message = data as? String {
                self.profileData.text = message
            }
        }
        
        if let pic = userDefaults.object(forKey: "profilePhoto") {
            if let pict = pic as? UIImage {
                self.profilePicture.image = pict
            }
        }
    }
    
    ///Main function for current viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileData.isEditable = false
        editButton.layer.cornerRadius = 10.0
        self.profileData.text = finalProfileData
        
    }
}



