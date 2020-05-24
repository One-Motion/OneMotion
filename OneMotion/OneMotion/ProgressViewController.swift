//
//  ProgressViewController.swift
//  OneMotion
//
//  Created by Grace Subianto on 22/05/20.
//  Copyright © 2020 Jason Vainikolo. All rights reserved.
//

import Foundation
import UIKit

class ProgressViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, WorkoutProtocol {
    // this is the creating of the table view which stores the users workout history
    var tableData: [String] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    //this allows the user to open each workout to view the details of the workout -- still under construction. 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.tableData[indexPath.row]
        return cell
    }
    // this function gets the user input data from the text field in the WorkoutViewController and places it into the tableview
    func getData(data: String) {
        self.performSegue(withIdentifier: "Add Segue", sender: self)
        self.tableData.append(data)
        self.tableView.reloadData()
    }
    // this function overrides the prepare code and allows the user input to be transferred from one navigation controller to another without losing the information
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Add Segue"
        {
            let vc = segue.destination as! WorkoutViewController
            vc.delegate = self
        }
    }
    
    
}
