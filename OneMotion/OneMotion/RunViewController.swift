//
//  RunViewController.swift
//  OneMotion
//
//  Created by Ehsaas Grover on 18/05/20.
//  Copyright © 2020 Ehsaas Grover. All rights reserved.
//

import UIKit
import CoreLocation
import SQLite3

class RunViewController : UIViewController {

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var dataStackView: UIStackView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    var db: OpaquePointer?
    private var locationList: [CLLocation] = []
    
    // This function implements all the variables for when the run begins
    private func startRun() {
           dataStackView.isHidden = false
           playButton.isHidden = true
           stopButton.isHidden = false
           seconds = 0
           distance = Measurement(value: 0, unit: UnitLength.meters)
           locationList.removeAll()
           updateDisplay()
           timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in self.eachSecond()
           }
           startLocationUpdates()
       }
       
    // This function implements all the variables for when the run ends
    private func stopRun() {
        dataStackView.isHidden = true
        playButton.isHidden = false
        stopButton.isHidden = true
        locationManager.stopUpdatingLocation()
    }
       
    private var run: Run?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // This function tells the timer and location tracker to stop when called
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    // Timer function
    func eachSecond() {
        seconds += 1
        updateDisplay()
    }

    // Updates the display according to the distance, time and pace
    private func updateDisplay() {
        
        // Formatting
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance, seconds: seconds, outputUnit: UnitSpeed.minutesPerMile)

        distanceLabel.text = "Distance:  \(formattedDistance)"
        timeLabel.text = "Time:  \(formattedTime)"
        paceLabel.text = "Average Pace:  \(formattedPace)"
        
        self.insertRun(distance: formattedDistance, time: formattedTime, pace: formattedPace)
    }

    func delete() {
        let deleteStatementString = "DELETE FROM RUN;"
        var deleteStatement: OpaquePointer?
          if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) ==
              SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
              print("\nSuccessfully deleted row.")
            } else {
              print("\nCould not delete row.")
            }
          } else {
            print("\nDELETE statement could not be prepared")
          }
          
          sqlite3_finalize(deleteStatement)
    }
    
    func insertRun(distance: String, time: String, pace: String) {
        
        //Opens the Connection
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("OneMotion.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error Opening database")
            return
        }
        
        self.delete()
        
        var insertStmt: OpaquePointer?
        let insertQuery = "INSERT INTO RUN(DISTANCE, TIME, PACE) VALUES (?,?,?)"
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStmt, nil) == SQLITE_OK {
                
            let distance: Double = (distance as NSString).doubleValue
            let time: Double = (time as NSString).doubleValue
            let pace: Double = (pace as NSString).doubleValue
            
            print("\n\(distance) | \(time) | \(pace)")
            
            sqlite3_bind_double(insertStmt, -1, distance)
            sqlite3_bind_double(insertStmt, -1, time)
            sqlite3_bind_double(insertStmt, -1, pace)
            
            if sqlite3_step(insertStmt) == SQLITE_DONE {
                print("Successfully inserted row\n")
            } else {
                print("\nCould not insert row")
            }
        }
        else {
            print("\nInsert Statement not prepared")
        }
        sqlite3_finalize(insertStmt)
        
    }
    
    // Updates the location
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
   
    // Saves the run
    private func saveRun() {
      let newRun = Run(context: CoreDataStack.context)
      newRun.distance = distance.value
      newRun.duration = Int16(seconds)
      newRun.timestamp = Date()

        print(newRun.distance)
        print(newRun.duration)
        print(newRun.timestamp)
        
      for location in locationList {
        let locationObject = Location(context: CoreDataStack.context)
        locationObject.timestamp = location.timestamp
        locationObject.latitude = location.coordinate.latitude
        locationObject.longitude = location.coordinate.longitude
        newRun.addToLocations(locationObject)
      }

      CoreDataStack.saveContext()
      run = newRun
    }
    
    // Action called when the play button is tapped 
    @IBAction func playTapped(_ sender: Any) {
        startRun()
    }
    
    // Action called when the stop button is tapped
    @IBAction func stopTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "End run?",
                                                message: "Do you wish to end your run?",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
          self.stopRun()
//          self.saveRun()
//          self.performSegue(withIdentifier: .details, sender: nil)
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
          self.stopRun()
          _ = self.navigationController?.popToRootViewController(animated: true)
        })

        present(alertController, animated: true)

    }
    
}

//extension RunViewController: SegueHandlerType {
//  enum SegueIdentifier: String {
//    case details = "RunDataViewController"
//  }
//  
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    switch segueIdentifier(for: segue) {
//    case .details:
//      let destination = segue.destination as! RunDataViewController
//      destination.run = run
//    }
//  }
//}


extension RunViewController: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    for newLocation in locations {
      let howRecent = newLocation.timestamp.timeIntervalSinceNow
      guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }

      if let lastLocation = locationList.last {
        let delta = newLocation.distance(from: lastLocation)
        distance = distance + Measurement(value: delta, unit: UnitLength.meters)
      }

      locationList.append(newLocation)
    }
  }
}




