//
//  TrackerViewController.swift
//  Pupperino
//
//  Created by Paulius Cesekas on 02/03/2018.
//  Copyright © 2018 StudioLitas. All rights reserved.
//

import UIKit
import CoreLocation

class TrackerViewController: UIViewController {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    var locationManager: CLLocationManager!
    var isTracking: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
    }
    
    // MARK: - UI Actions
    @IBAction func touchUpInsideRecordButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if isTracking {
            locationManager.stopUpdatingLocation()
            ExerciseManager.shared.pause()
        } else {
            ExerciseManager.shared.start()
            locationManager.startUpdatingLocation()
        }
        
        isTracking = !isTracking
    }
    
    @IBAction func touchUpInsideStopButton(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        ExerciseManager.shared.stop()
    }
}

// MARK: - CLLocationManagerDelegate
extension TrackerViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error - \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        ExerciseManager.shared.addLocations(locations)
        
        timeLabel.text = "\(round((ExerciseManager.shared.activeExercise?.duration)!))"
    }
    
    
}
