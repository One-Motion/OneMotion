//
//  ProfileViewController.swift
//  OneMotion
//
//  Created by Jason Vainikolo on 13/05/20.
//  Copyright © 2020 Jason Vainikolo. All rights reserved.
// new edit

import UIKit


class ProfileViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileData: UITextView!
    var finalProfileData: String = ""
    
    var fName: String = UserDefaults.standard.string(forKey: "firstName") ?? " "
    var lName: String = UserDefaults.standard.string(forKey: "lastName") ?? " "
    var DofB: String = UserDefaults.standard.string(forKey: "DOB") ?? " "
    var weight: String = UserDefaults.standard.string(forKey: "weight") ?? " "
    var height: String = UserDefaults.standard.string(forKey: "height") ?? " "
    var email: String = UserDefaults.standard.string(forKey: "email") ?? " "
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    profileData.text = fName + "\n\n" + lName + "\n\n" + DofB + "\n\n" + weight + "\n\n" + height + "\n\n" + email
        
        
    }
    

    

    

    

 
    
    
}



