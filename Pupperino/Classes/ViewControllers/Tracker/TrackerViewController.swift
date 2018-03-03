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

    var exerciseManager: ExerciseManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Exercise"
        
        exerciseManager = ExerciseManager(delegate: self)
    }
    
    // MARK: - UI Actions
    @IBAction func touchUpInsideRecordButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        exerciseManager.toggle()
    }
    
    @IBAction func touchUpInsideStopButton(_ sender: Any) {
        exerciseManager.stop()
        recordButton.isSelected = false
        timeLabel.text = "00:00"
        distanceLabel.text = "0.00m"
    }
}

// MARK: - ExerciseManagerDelegate
extension TrackerViewController: ExerciseManagerDelegate {
    func exerciseManagerFailedToAuthorize(_ manager: ExerciseManager) {
        let alert = UIAlertController(title: "Failed to authorise", message: "To use tracking you need to authorise LocationManager", preferredStyle: .alert)
        present(alert, animated: true)
    }
    
    func exerciseManager(_ manager: ExerciseManager, saved exercise: ExerciseEntity) {
        print("Saved exercise: \(exercise)")
        timeLabel.text = "00:00"
        distanceLabel.text = "0.00m"
    }
    
    func exerciseManager(_ manager: ExerciseManager, didUpdateDuration duration: TimeInterval, distance: Double) {
        updateDuration(duration)
        updateDistance(distance)
    }
    
    private func updateDuration(_ duration: TimeInterval) {
        let totalSeconds = round(duration)
        let minutes = Int(floor(totalSeconds / 60))
        let seconds = Int(totalSeconds) % 60
        timeLabel.text = String(format:"%02d:%02d", minutes, seconds)
    }
    
    private func updateDistance(_ distance: Double) {
        distanceLabel.text = String(format:"%.2fm", distance)
    }
}
