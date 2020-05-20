//
//  EditProfileViewController.swift
//  OneMotion
//
//  Created by Jason Vainikolo on 20/05/20.
//  Copyright © 2020 Jason Vainikolo. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var DOB: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var email: UITextField!
    var fNameText = ""
    var lNameText = ""
    var DofB = ""
    var Weight = ""
    var Height = ""
    var Email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                firstName.delegate = self
                lastName.delegate = self
                DOB.delegate = self
                weight.delegate = self
                height.delegate = self
                email.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        weight.resignFirstResponder()
        height.resignFirstResponder()
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
        self.fNameText = firstName.text!
        self.lNameText = lastName.text!
        self.DofB = DOB.text!
        self.Weight = weight.text!
        self.Height = height.text!
        self.Email = email.text!
        
        performSegue(withIdentifier: "saveProfile", sender: self)
    }
    
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
