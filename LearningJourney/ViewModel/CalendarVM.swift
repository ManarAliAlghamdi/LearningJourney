import Foundation
import SwiftUI
import SwiftData

extension CalendarHeaderView{
    
    @Observable
    class ViewModel{
        var modelContext: ModelContext
        var journeys = [Journey]()
        
        var lastTracker: Journey? {
            return journeys.sorted { $0.startDate < $1.startDate }.last
        }
        
         var currentDate = Date()
         let dateFormatter = DateFormatter()
         let calendar = Calendar.current
       
        func fetchData() {
            do {
                let descriptor = FetchDescriptor<Journey>(sortBy: [.init(\.startDate, order: .reverse)])
                let allJourneys = try modelContext.fetch(descriptor)
                journeys = allJourneys.prefix(1).map { $0 }  // Keep only the latest journey
            } catch {
                print("Fetch failed HERE")
            }
        }
        
         var maxDate: Date {
            var components = DateComponents()
            components.year = calendar.component(.year, from: Date()) + 1
            components.month = calendar.component(.month, from: Date())
            components.day = 1
            return calendar.date(from: components)!
        }

         var minDate: Date {
            var components = DateComponents()
            components.year = calendar.component(.year, from: Date()) - 1
            components.month = calendar.component(.month, from: Date())
            components.day = 1
            return calendar.date(from: components)!
        }
        
         var currentMonthYear: String {
            dateFormatter.dateFormat = "MMMM yyyy"
            return dateFormatter.string(from: currentDate)
        }
        
         func setInitialDate() {
            currentDate = Date()
        }
        
         func changeMonth(by value: Int) {
            if let newDate = calendar.date(byAdding: .month, value: value, to: currentDate) {
                if newDate <= maxDate && newDate >= minDate {
                    currentDate = newDate
                }
            }
        }
        
         func changeDay(by value: Int) {
            if let newDate = calendar.date(byAdding: .day, value: value, to: currentDate), isWithinMonth(date: newDate) {
                currentDate = newDate
            }
        }
        
         func canChangeDay(by value: Int) -> Bool {
            if let newDate = calendar.date(byAdding: .day, value: value, to: currentDate) {
                return isWithinMonth(date: newDate)
            }
            return false
        }
        
         func isWithinMonth(date: Date) -> Bool {
            let currentMonth = calendar.component(.month, from: currentDate)
            let dayMonth = calendar.component(.month, from: date)
            return currentMonth == dayMonth
        }
        
         var isAtSystemMonth: Bool {
            let currentMonth = calendar.component(.month, from: currentDate)
            let currentYear = calendar.component(.year, from: currentDate)
            let systemMonth = calendar.component(.month, from: Date())
            let systemYear = calendar.component(.year, from: Date())
            
            return currentMonth == systemMonth && currentYear == systemYear
        }
        
         var isAtMaxDate: Bool {
            calendar.compare(currentDate, to: maxDate, toGranularity: .month) == .orderedSame
        }
        
            var isAtMinDate: Bool {
            calendar.compare(currentDate, to: minDate, toGranularity: .month) == .orderedSame
        }
        
          func weekdayName(for index: Int) -> String {
            dateFormatter.shortWeekdaySymbols[index]
        }
        
          func dayForWeekday(_ index: Int) -> Date {
            let startOfWeek = calendar.dateInterval(of: .weekOfMonth, for: currentDate)?.start ?? currentDate
            return calendar.date(byAdding: .day, value: index, to: startOfWeek) ?? currentDate
        }
        
          func daysInCurrentWeek() -> [Date] {
            guard let startOfWeek = calendar.dateInterval(of: .weekOfMonth, for: currentDate)?.start else {
                return []
            }
            return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
        }
        
          func dayNumber(for date: Date) -> String {
            dateFormatter.dateFormat = "d"
            return dateFormatter.string(from: date)
        }
        
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

        
        func updateDayStatus(for date: Date) {
            
            guard let journey = lastTracker else { return }
            
            if let index = journey.tracker.firstIndex(where: { calendar.isDate($0.dayDate, inSameDayAs: date) }) {
                
                journey.tracker[index].dayStatus = (journey.tracker[index].dayStatus + 1) % 3
//                if ((journey.tracker[index].dayStatus + 1) % 3)  == 1 {
//
//                }
                
                switch (journey.tracker[index].dayStatus) {
                case 1:
                    print("\((journey.tracker[index].dayStatus)) freesze")
                    journey.freezeDays += 1
                    journey.streakDays -= 1
                    
                case 2:
                    journey.streakDays += 1
                    journey.freezeDays -= 1
                    print("\((journey.tracker[index].dayStatus)) learned")
                default:
                    journey.streakDays -= 1
                    journey.freezeDays -= 1
                    print("\((journey.tracker[index].dayStatus)) on progress")
                }
               
                
                // Cycle through statuses 0, 1, 2
                do {
                    try modelContext.save()
                    currentDate = Date() // Trigger a refresh by updating `currentDate`
                    print("Day status updated.")
                } catch {
                    print("Failed to update day status: \(error.localizedDescription)")
                }
            } else {
                print("Date not found in tracker.")
            }
        }

        
        
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchData()
            
        }
    }
}
