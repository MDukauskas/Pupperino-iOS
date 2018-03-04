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
    var id: Int?
    var startDate: Date!
    var endDate: Date?
    var updateDate: Date?
    var distance = 0.0
    var duration: TimeInterval = 0.0
    var locations = [CLLocation]()

    open override class func ignoredProperties() -> [String] {
        return ["updateDate"]
    }

    required init() {
        super.init()
        startDate = Date()
        endDate = nil
        updateDate = nil
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
    
    convenience init?(withDictionary dictionary: [String: Any]) {
        self.init()
        
        id = dictionary["id"] as? Int
        
        guard let startTimeString = dictionary["startTime"] as? String else {
            return
        }
        startDate = GenericTools.apiDateFormatter.date(from: startTimeString)

        if let endDateString = dictionary["endTime"] as? String {
            endDate = GenericTools.apiDateFormatter.date(from: endDateString)
        }
        
        if let distance = dictionary["distance"] as? Double {
            self.distance = distance
        } else {
            self.distance = 0
        }
        
        if let duration = dictionary["duration"] as? Double {
            self.duration = duration
        } else {
            self.duration = 0
        }
        
        if let pathsDictionaryList = dictionary["path"] as? [String: Any] {
            
        }
    }
    
    func addDistance(_ distance: Double) {
        self.distance += distance
    }
    
    func updateDuration() {
        guard let previousUpdateDate = updateDate else {
            updateDate = Date()
            return
        }
        
        updateDate = Date()
        let delta = updateDate!.timeIntervalSince(previousUpdateDate)
        self.duration += delta
    }
    
    func addLocation(_ location: CLLocation) {
        locations.append(location)
    }
}
