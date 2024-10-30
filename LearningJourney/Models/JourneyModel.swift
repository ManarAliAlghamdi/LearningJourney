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
    
    
    
    func calculateStreakAndFreeze(context: ModelContext, lastTracker: Journey?) {
        // Ensure lastTracker is not nil before proceeding
        guard let journey = lastTracker else {
            print("No last tracker found.")
            return
        }
        
        var streak = 0     // Keeps track of the current streak of logged days
        var freeze = 0     // Counts the number of frozen days
        let today = Calendar.current.startOfDay(for: Date())   // Today's date at the start of the day
        let startDate = Calendar.current.startOfDay(for: journey.startDate)   // The journey's start date at the start of the day
        
        // Loop through each day from startDate to today
        var date = startDate
        while date <= today {
            // Check if there is a tracker entry for the current date
            if let tracker = journey.tracker.first(where: { Calendar.current.isDate($0.dayDate, inSameDayAs: date) }) {
                // If today's date and status is 0, skip (do nothing)
                if Calendar.current.isDateInToday(date) && tracker.dayStatus == 0 {
                    // Do nothing for today if it's unlogged (status 0)
                } else if tracker.dayStatus == 1 {
                    // If dayStatus is 1, count as a freeze day
                    freeze += 1
                } else if tracker.dayStatus == 2 {
                    // If dayStatus is 2, count as a streak day
                    streak += 1
                } else if tracker.dayStatus == 0 {
                    // If dayStatus is 0, reset the streak because the user did nothing on this day
                    streak = 0
                }
            } else {
                // If there's no tracker entry for this day, reset the streak
                streak = 0
            }
            
            // Move to the next day
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
        
        // Update the lastTracker's streakDays and freezeDays properties
        if streak > 0 {
            journey.streakDays = streak - 1
        }
        journey.freezeDays = freeze
        
        // Save the updated streak and freeze counts to the database
        do {
            try context.save()
            print("Day status updated and saved successfully.")
        } catch {
            print("Failed to save the context: \(error.localizedDescription)")
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
