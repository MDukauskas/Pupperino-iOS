//
//  ExerciseEntity.swift
//  Pupperino
//
//  Created by Paulius Cesekas on 02/03/2018.
//  Copyright © 2018 StudioLitas. All rights reserved.
//

import Foundation
import CoreLocation
import Realm
import RealmSwift

class ExerciseEntity: Object {
    var startDate: Date!
    var endDate: Date?
    var updateDate: Date!
    var distance = 0.0
    var duration: TimeInterval = 0.0
    var locations = [CLLocation]()

    required init() {
        super.init()
        startDate = Date()
        endDate = nil
        updateDate = Date()
        distance = 0.0
        duration = 0.0
        locations = [CLLocation]()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        fatalError("init(realm:schema:) has not been implemented")
    }
    
    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
    
    func addDistance(_ distance: Double) {
        self.distance += distance
    }
    
    func updateDuration() {
        let previousUpdateDate = updateDate
        updateDate = Date()
        self.duration += updateDate.timeIntervalSince(previousUpdateDate!)
    }
    
    func addLocation(_ location: CLLocation) {
        locations.append(location)
    }
}
