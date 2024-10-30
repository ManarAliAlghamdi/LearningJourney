import Foundation
import SwiftUI
import SwiftData

extension CalendarHeaderView {
    
    @Observable
    class ViewModel {
        // ModelContext property to manage data within the SwiftData framework
        var modelContext: ModelContext
        var journeys = [Journey]() // Array to hold all journey records
        
        // Returns the most recent journey based on start date
        var lastTracker: Journey? {
            return journeys.sorted { $0.startDate < $1.startDate }.last
        }
        
        var currentDate = Date() // Holds the currently selected date
        let dateFormatter = DateFormatter() // DateFormatter to handle date format conversions
        let calendar = Calendar.current // Calendar instance for date manipulations
        
        // Fetches the latest journey entry from the database and assigns it to journeys array
        func fetchData() {
            do {
                let descriptor = FetchDescriptor<Journey>(sortBy: [.init(\.startDate, order: .reverse)])
                let allJourneys = try modelContext.fetch(descriptor)
                journeys = allJourneys.prefix(1).map { $0 } // Keep only the latest journey
            } catch {
                print("Fetch failed HERE")
            }
        }
        
        // Defines the maximum date limit (one year ahead of the current month)
        var maxDate: Date {
            var components = DateComponents()
            components.year = calendar.component(.year, from: Date()) + 1
            components.month = calendar.component(.month, from: Date())
            components.day = 1
            return calendar.date(from: components)!
        }
        
        // Defines the minimum date limit (one year behind the current month)
        var minDate: Date {
            var components = DateComponents()
            components.year = calendar.component(.year, from: Date()) - 1
            components.month = calendar.component(.month, from: Date())
            components.day = 1
            return calendar.date(from: components)!
        }
        
        // Formats the current date as "Month Year" (e.g., "October 2024")
        var currentMonthYear: String {
            dateFormatter.dateFormat = "MMMM yyyy"
            return dateFormatter.string(from: currentDate)
        }
        
        // Sets the initial date to today's date for display purposes
        func setInitialDate() {
            currentDate = Date()
        }
        
        // Changes the month by a specified value, constrained within min and max date boundaries
        func changeMonth(by value: Int) {
            if let newDate = calendar.date(byAdding: .month, value: value, to: currentDate) {
                if newDate <= maxDate && newDate >= minDate {
                    currentDate = newDate
                }
            }
        }
        
        // Changes the day by a specified value, ensuring the new date remains within the current month
        func changeDay(by value: Int) {
            if let newDate = calendar.date(byAdding: .day, value: value, to: currentDate), isWithinMonth(date: newDate) {
                currentDate = newDate
            }
        }
        
        // Checks if a day change keeps the date within the current month
        func canChangeDay(by value: Int) -> Bool {
            if let newDate = calendar.date(byAdding: .day, value: value, to: currentDate) {
                return isWithinMonth(date: newDate)
            }
            return false
        }
        
        // Checks if a date is within the same month as the current date
        func isWithinMonth(date: Date) -> Bool {
            let currentMonth = calendar.component(.month, from: currentDate)
            let dayMonth = calendar.component(.month, from: date)
            return currentMonth == dayMonth
        }
        
        // Checks if the current date matches the system's current month and year
        var isAtSystemMonth: Bool {
            let currentMonth = calendar.component(.month, from: currentDate)
            let currentYear = calendar.component(.year, from: currentDate)
            let systemMonth = calendar.component(.month, from: Date())
            let systemYear = calendar.component(.year, from: Date())
            return currentMonth == systemMonth && currentYear == systemYear
        }
        
        // Determines if the current date is at the maximum allowable date
        var isAtMaxDate: Bool {
            calendar.compare(currentDate, to: maxDate, toGranularity: .month) == .orderedSame
        }
        
        // Determines if the current date is at the minimum allowable date
        var isAtMinDate: Bool {
            calendar.compare(currentDate, to: minDate, toGranularity: .month) == .orderedSame
        }
        
        // Returns the abbreviated name of a weekday for a given index (e.g., "Mon")
        func weekdayName(for index: Int) -> String {
            dateFormatter.shortWeekdaySymbols[index]
        }
        
        // Gets the date corresponding to a specific weekday index in the current week
        func dayForWeekday(_ index: Int) -> Date {
            let startOfWeek = calendar.dateInterval(of: .weekOfMonth, for: currentDate)?.start ?? currentDate
            return calendar.date(byAdding: .day, value: index, to: startOfWeek) ?? currentDate
        }
        
        // Returns an array of dates for each day in the current week
        func daysInCurrentWeek() -> [Date] {
            guard let startOfWeek = calendar.dateInterval(of: .weekOfMonth, for: currentDate)?.start else {
                return []
            }
            return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
        }
        
        // Retrieves the day number for a specific date
        func dayNumber(for date: Date) -> String {
            dateFormatter.dateFormat = "d"
            return dateFormatter.string(from: date)
        }
        
        // Determines the background color for a specific date based on its status in the journey tracker
        func dayBackground(for date: Date) -> Color {
            if let journey = lastTracker,
               let tracker = journey.tracker.first(where: { calendar.isDate($0.dayDate, inSameDayAs: date) }) {
                switch tracker.dayStatus {
                case 1:
                    return myColors.AppDarkBlue
                case 2:
                    return myColors.AppDarkOrange
                case 0 where calendar.isDateInToday(date):
                    return myColors.AppOrange
                default:
                    return Color.clear
                }
            } else {
                return Color.clear
            }
        }
        
        // Determines the text color for a specific date based on its status
        func dayTextColor(for date: Date) -> Color {
            if let journey = lastTracker,
               let tracker = journey.tracker.first(where: { calendar.isDate($0.dayDate, inSameDayAs: date) }) {
                switch tracker.dayStatus {
                case 1:
                    return myColors.AppBlue
                case 2:
                    return myColors.AppOrange
                case 0 where calendar.isDateInToday(date):
                    return .white
                default:
                    return .white
                }
            } else {
                return .white
            }
        }
        
        // Updates the status of a day in the journey tracker, cycling through statuses 0, 1, and 2
        func updateDayStatus(for date: Date) {
            guard let journey = lastTracker else { return }

            // Find the index of the tracker entry for the specified date
            if let index = journey.tracker.firstIndex(where: { calendar.isDate($0.dayDate, inSameDayAs: date) }) {
                // Check if freezeDays exceed or meet the freezeLeft limit
                if journey.freezeDays >= journey.freezeLeft {
                    // Only cycle between statuses 0 and 2 (skip 1) if freeze days have reached or exceeded the limit
                    journey.tracker[index].dayStatus = journey.tracker[index].dayStatus == 0 ? 2 : 0
                } else {
                    // Cycle through statuses 0, 1, and 2 as usual if freeze days are within the limit
                    journey.tracker[index].dayStatus = (journey.tracker[index].dayStatus + 1) % 3
                }

                // Save the updated status to the database
                do {
                    try modelContext.save()
                    currentDate = Date() // Trigger a refresh by updating `currentDate`
                    lastTracker!.calculateStreakAndFreeze(context: modelContext, lastTracker: lastTracker!)
                    print("Day status updated.")
                } catch {
                    print("Failed to update day status: \(error.localizedDescription)")
                }
            } else {
                print("Date not found in tracker.")
            }
        }

        // Initializes the ViewModel with a model context and fetches initial data
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchData()
        }
    }
}
