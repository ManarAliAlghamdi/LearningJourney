//
//  JourneyDetailsModel.swift
//  LearningJourney
//
//  Created by Manar Alghmadi on 22/10/2024.
//


import Foundation
import SwiftData
import SwiftDate
@Model
class JourneyTracker {
    
    var dayDate: Date
    var dayStatus: Int
    
    init(dayDate: Date = .now, dayStatus: Int = 0) {
        self.dayDate = dayDate
        self.dayStatus = dayStatus
    }
    
    // Make this a static method
    static func populateJourneyTrackers() -> [JourneyTracker] {
        var trackers: [JourneyTracker] = []
        let today = Date()
        for i in 1...6 { // Start from 1 to skip the current day
            let pastDate = today - i.days
            let status = Int.random(in: 1...2)
            let tracker = JourneyTracker(dayDate: pastDate, dayStatus: status)
            trackers.append(tracker)
        }
        
        return trackers
    }

}
