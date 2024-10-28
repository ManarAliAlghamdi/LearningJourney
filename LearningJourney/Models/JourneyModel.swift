import Foundation
import SwiftData
import SwiftDate

@Model
class Journey{
    var period: String
    var startDate: Date
    var endDate: Date
    var streakDays: Int
    var freezeDays: Int
    var freezeLeft: Int
    @Relationship(deleteRule: .cascade) var tracker: [JourneyTracker]
    
    init( period: String, startDate: Date = .now, streakDays: Int = 0, freezeDays: Int = 0, freezeLeft: Int = 0) {
        self.period = period
        self.startDate = startDate
        self.streakDays = streakDays
        self.freezeDays = freezeDays
        self.freezeLeft = freezeLeft
        self.endDate = startDate
        
        
        self.tracker = [JourneyTracker(dayDate: .now, dayStatus: 0)]
        self.freezeLeft = getFreezeDays(period: period)
        self.endDate = calculateEndDate(startDate: startDate, period: period)
    }
    
    func calculateEndDate(startDate: Date, period: String) -> Date {
        switch period {
        case "Week":
            return (startDate + 1.weeks).date
        case "Month":
            return (startDate + 1.months).date
        case "Year":
            return (startDate + 1.years).date
        default:
            return startDate
        }
    }
    
    func getFreezeDays(period: String) -> Int {
        switch period {
        case "Week":
            return 2
        case "Month":
            return 6
        case "Year":
            return 60
        default:
            return 0
        }
    }
}
