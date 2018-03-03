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

class ExerciseManager {
    
    // MARK: - Declarations
    static var shared = ExerciseManager()
    
    private(set) var activeExercise: ExerciseEntity?
    private var isPaused = true
    
    func start() {
        if activeExercise == nil {
            activeExercise = ExerciseEntity()
        }
        
        isPaused = false
    }
    
    func pause() {
        if activeExercise == nil || isPaused {
            print("Trying to pause exercise while it is not started")
            return
        }
        
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
            realm.add(activeExercise)
        }
    }
}
