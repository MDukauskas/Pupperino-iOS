//
//  ExerciseManager.swift
//  Pupperino
//
//  Created by Paulius Cesekas on 02/03/2018.
//  Copyright © 2018 StudioLitas. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

protocol ExerciseManagerDelegate {
    func exerciseManagerFailedToAuthorize(_ manager: ExerciseManager)
    func exerciseManager(_ manager: ExerciseManager, didUpdateDuration duration: TimeInterval, distance: Double)
    func exerciseManager(_ manager: ExerciseManager, saved exercise: ExerciseEntity)
}

class ExerciseManager: NSObject {
    
    // MARK: - Declarations
    private var delegate: ExerciseManagerDelegate!
    private var locationManager: CLLocationManager!
    private var timer: Timer!

    private var activeExercise: ExerciseEntity?
    private var isPaused = true

    init(delegate: ExerciseManagerDelegate) {
        super.init()
        self.delegate = delegate
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(tick),
                                     userInfo: nil,
                                     repeats: true)
        timer.fire()
    }
    
    func start() {
        if activeExercise == nil {
            activeExercise = ExerciseEntity()
        } else {
            activeExercise?.updateDuration()
        }

        isPaused = false
    }
    
    func toggle() {
        if isPaused {
            start()
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
            pause()
        }
    }
    
    func pause() {
        if activeExercise == nil || isPaused {
            print("Trying to pause exercise while it is not started")
            return
        }
        
        activeExercise?.updateDate = nil
        isPaused = true
    }
    
    func stop() {
        if activeExercise == nil || isPaused {
            print("Trying to stop exercise while it is not started")
            return
        }

        isPaused = true
        save()
        activeExercise = nil
    }
    
    func addLocations(_ locations: [CLLocation]) {
        guard let activeExercise = activeExercise, !isPaused else {
            print("Trying to add location while exercise is not started")
            return
        }
        
        for location in locations {
            if location.horizontalAccuracy > 0 {
                let locations = activeExercise.locations
                // TODO: don't use previous location if tracking was paused
                if let lastLocation = locations.last {
                    let delta = location.distance(from: lastLocation)
                    activeExercise.addDistance(delta)
                }
                
                activeExercise.addLocation(location)
            }
        }

        activeExercise.updateDuration()
    }
    
    // MARK: helpers
    
    private func save() {
        guard let activeExercise = activeExercise else {
            return
        }
        
        guard let realm = try? Realm() else {
            return
        }
        
        try? realm.write {
            activeExercise.endDate = Date()
            realm.add(activeExercise)
        }
        
        delegate.exerciseManager(self, saved: activeExercise)
    }
    
    @objc private func tick() {
        guard !isPaused, let activeExercise = activeExercise else {
            return
        }
        
        activeExercise.updateDuration()

        delegate.exerciseManager(self, didUpdateDuration: activeExercise.duration, distance: activeExercise.distance)
    }
}

extension ExerciseManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            break
            
        default:
            delegate.exerciseManagerFailedToAuthorize(self)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error - \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        addLocations(locations)
    }
}
