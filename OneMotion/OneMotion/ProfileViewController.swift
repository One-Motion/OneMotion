//
//  ProfileViewController.swift
//  OneMotion
//
//  Created by Jason Vainikolo on 13/05/20.
//  Copyright © 2020 Jason Vainikolo. All rights reserved.
// new changes, new me

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileData: UITextView!
    @IBOutlet weak var editButton: UIButton!
    
    var finalProfileData: String!
//    var image = UIImage(contentsOfFile: "defaultProfilePhoto")
    var fName: String = UserDefaults.standard.string(forKey: "firstName") ?? " "
    var lName: String = UserDefaults.standard.string(forKey: "lastName") ?? " "
    var DofB: String = UserDefaults.standard.string(forKey: "DOB") ?? " "
    var weight: String = UserDefaults.standard.string(forKey: "weight") ?? " "
    var height: String = UserDefaults.standard.string(forKey: "height") ?? " "
    var email: String = UserDefaults.standard.string(forKey: "email") ?? " "
    
    @IBAction func changePhotoButton(_ sender: Any) {
        
        let imagePicked = UIImagePickerController()
        imagePicked.delegate = self
        imagePicked.sourceType = .photoLibrary
        
        self.present(imagePicked, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let profilePic = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        profilePicture.image = profilePic
        
        let imageData: NSData? = profilePicture.image!.pngData()! as NSData
        UserDefaults.standard.set(imageData, forKey: "profilePhoto")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults()
        if let data = userDefaults.object(forKey: "profileInfo") {
            if let message = data as? String {
                self.profileData.text = message
            }
        }
        
//        let profilePic = userDefaults.object(forKey: "profilePhoto") as! NSData
//            profilePicture.image = UIImage(data: profilePic as Data)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        profilePicture.image = image
        profileData.isEditable = false
        editButton.layer.cornerRadius = 10.0
        self.profileData.text = finalProfileData
    }
}



