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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.tableData[indexPath.row]
        return cell
    }
    
    func getData(data: String) {
        self.performSegue(withIdentifier: "Add Segue", sender: self)
        self.tableData.append(data)
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Add Segue"
        {
            let vc = segue.destination as! WorkoutViewController
            vc.delegate = self
        }
    }
    
    
}
