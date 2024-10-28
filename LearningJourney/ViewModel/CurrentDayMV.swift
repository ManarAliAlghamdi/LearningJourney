

import SwiftData
import SwiftUI

extension CurrentDay {
    @Observable
    class ViewModel{
        var modelContext: ModelContext
        var journeys = [Journey]()
        var streak: Int = 0
        var freeze: Int = 0
        var lastTracker: Journey? {
            return journeys.sorted { $0.startDate < $1.startDate }.last
        }
        
        let statusList: [String] = ["Log today\nas Learned", "Day \nFreezed", "Learned \nToday"]
        var skillValue: String {
            get {
                UserDefaults.standard.string(forKey: "skill") ?? ""
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "skill")
            }
        }
        
        func fetchData() {
            do {
                let descriptor = FetchDescriptor<Journey>(sortBy: [.init(\.startDate, order: .reverse)])
                let allJourneys = try modelContext.fetch(descriptor)
                journeys = allJourneys.prefix(1).map { $0 }  // Keep only the latest journey
            } catch {
                print("Fetch failed HERE")
            }
        }

        func updateStreakAndFreeze() {
            if let tracker = lastTracker {
                let result = calculateStreakAndFreeze(for: tracker)
                streak = result.streak
                freeze = result.freeze
            }
        }
        
        
        func calculateStreakAndFreeze(for journey: Journey) -> (streak: Int, freeze: Int) {
            var streak = 0
            var freeze = 0
            let today = Calendar.current.startOfDay(for: Date())
            
            for tracker in journey.tracker {
                let trackerDate = Calendar.current.startOfDay(for: tracker.dayDate)
                
                if Calendar.current.isDate(trackerDate, inSameDayAs: today) {
                    if tracker.dayStatus == 1 {
                        freeze += 1
                    } else if tracker.dayStatus == 2 {
                        streak += 1
                    }
                    continue
                }
                
                switch tracker.dayStatus {
                case 1:
                    freeze += 1
                case 2:
                    streak += 1
                case 0:
                    streak = 0
                default:
                    break
                }
            }
            
            return (streak, freeze)
        }
        
        
        
        
        func getCurrentDay() -> String {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, dd MMM"
            return formatter.string(from: date)
        }
        
        
        func updateCurrentDayStatus(on date: Date, status: Int, context: ModelContext) {
            guard let journey = lastTracker else { return }
            
            let dayStart = Calendar.current.startOfDay(for: date)
            if let index = journey.tracker.firstIndex(where: { Calendar.current.isDate($0.dayDate, inSameDayAs: dayStart) }) {
                journey.tracker[index].dayStatus = status
                if (status == 1){
                    journey.freezeDays += 1
                    journey.streakDays -= 1
                }
                if (status == 2){
                    journey.freezeDays -= 1
                    journey.streakDays += 1
                }
            } else {
                let newTracker = JourneyTracker(dayDate: dayStart, dayStatus: status)
                journey.tracker.append(newTracker)
            }
            
            do {
                try context.save()
                print("Day status updated and saved successfully.")
                // Update streak and freeze values after saving the update
                updateStreakAndFreeze()
            } catch {
                print("Failed to save the context: \(error.localizedDescription)")
            }
        }
        
        
        
        
        
        func learnedButtonView(lastDay: JourneyTracker, viewModel: ViewModel) -> some View {
            Button(action: {
                if lastDay.dayStatus != 1 {
                    viewModel.updateCurrentDayStatus(on: Date(), status: 2, context: viewModel.modelContext)
                }
            }) {
                Text(viewModel.statusList[lastDay.dayStatus])
            }
            .if(lastDay.dayStatus == 0) { view in
                view.logView()
            }
            .if(lastDay.dayStatus == 1) { view in
                view.freezeView()
            }
            .if(lastDay.dayStatus == 2) { view in
                view.learnedView()
            }
            .padding(.top)
        }
        
        // Function to handle the "Freeze day" button and freeze status text
        func freezeDayView(lastDay: JourneyTracker, tracker: Journey, viewModel: ViewModel) -> some View {
            VStack {
                Button(action: {
                    if lastDay.dayStatus != 2 && tracker.freezeDays < tracker.freezeLeft {
                        viewModel.updateCurrentDayStatus(on: Date(), status: 1, context: viewModel.modelContext)
                    }
                }) {
                    Text("Freeze day")
                }
                .if(lastDay.dayStatus == 0 && tracker.freezeDays < tracker.freezeLeft) { view in
                    view.freezeingButton()
                }
                .if(lastDay.dayStatus != 0 || tracker.freezeDays > tracker.freezeLeft) { view in
                    view.frezzedButton()
                }
                .padding(.vertical)
                
                Text("\(tracker.freezeDays) out of \(tracker.freezeLeft) freezes used")
                    .soSmallCenterGrayText()
            }
        }
        
        // Function for when there is no tracker data
        func noTrackerDataView() -> some View {
            Text("No tracker data available")
                .soSmallCenterGrayText()
                .padding(.top)
        }
        
        
        
        func contentForCurrentDay() -> some View {
                if let tracker = lastTracker, let lastDay = tracker.tracker.last {
                    return AnyView(
                        VStack {
                            learnedButtonView(lastDay: lastDay, viewModel: self)
                            freezeDayView(lastDay: lastDay, tracker: tracker, viewModel: self)
                        }
                    )
                } else {
                    return AnyView(noTrackerDataView())
                }
            }
        
        
        
        
        
        func newDay() {
            let today = Calendar.current.startOfDay(for: Date())

            // Safely unwrap `lastTracker`
            if let currentTracker = lastTracker {
                // Check if today's date is already in the tracker array
                if currentTracker.tracker.contains(where: { Calendar.current.isDate($0.dayDate, inSameDayAs: today) }) {
                    print("Already inserted")
                } else {
                    // Insert new JourneyTracker with today's date and default status
                    let newTracker = JourneyTracker(dayDate: today, dayStatus: 0)
                    currentTracker.tracker.append(newTracker)
                    
                    do {
                        try modelContext.save()
                        print("Inserted today's date into the database")
                    } catch {
                        print("Failed to insert date: \(error.localizedDescription)")
                    }
                }
            } else {
                print("No active journey found in `lastTracker`")
            }
        }


        
        func getStreak() -> Int {
            if let currentTracker = lastTracker {
                return currentTracker.streakDays
            }
            return 0
        }

        
        func getFreeze() -> Int{
            if let currentTracker = lastTracker {
                return currentTracker.freezeDays
            }
            return 0
        }

        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchData()
            newDay()
        }
    }
}
