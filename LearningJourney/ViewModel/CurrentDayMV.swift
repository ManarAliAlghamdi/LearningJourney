import SwiftData
import SwiftUI

extension CurrentDay {
    @Observable
    class ViewModel {
        var modelContext: ModelContext // Model context for managing data persistence
        var journeys = [Journey]() // Array to store all journey records
        
        // Returns the most recent journey based on start date
        var lastTracker: Journey? {
            return journeys.sorted { $0.startDate < $1.startDate }.last
        }
        
        // List of status messages for day statuses
        let statusList: [String] = ["Log today\nas Learned", "Day \nFreezed", "Learned \nToday"]
        
        // Retrieves the user's skill value from UserDefaults, providing a default if unset
        var skillValue: String {
            get {
                UserDefaults.standard.string(forKey: "skill") ?? ""
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "skill")
            }
        }
        
        // Fetches the most recent journey entry from the database
        func fetchData() {
            do {
                let descriptor = FetchDescriptor<Journey>(sortBy: [.init(\.startDate, order: .reverse)])
                let allJourneys = try modelContext.fetch(descriptor)
                journeys = allJourneys.prefix(1).map { $0 } // Keep only the latest journey
            } catch {
                print("Fetch failed HERE")
            }
        }

        // Formats and returns the current day in "EEEE, dd MMM" format
        func getCurrentDay() -> String {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, dd MMM"
            return formatter.string(from: date)
        }
        
        // Updates the status of the specified day, adding it to the tracker if not already present
        func updateCurrentDayStatus(on date: Date, status: Int, context: ModelContext) {
            guard let journey = lastTracker else { return }
            
            let dayStart = Calendar.current.startOfDay(for: date)
            if let index = journey.tracker.firstIndex(where: { Calendar.current.isDate($0.dayDate, inSameDayAs: dayStart) }) {
                journey.tracker[index].dayStatus = status
            } else {
                let newTracker = JourneyTracker(dayDate: dayStart, dayStatus: status)
                journey.tracker.append(newTracker)
            }
            
            do {
                try context.save()
                print("Day status updated and saved successfully.")
                lastTracker!.calculateStreakAndFreeze(context: modelContext, lastTracker: lastTracker!)
            } catch {
                print("Failed to save the context: \(error.localizedDescription)")
            }
        }
        
        // Creates a button for logging the day as learned, conditionally styled based on day status
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
        
        // Creates a button and text for freezing a day, showing remaining freeze days
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
                .if(lastDay.dayStatus == 0 || tracker.freezeDays > tracker.freezeLeft || lastDay.dayStatus != 0 ) { view in
                    view.frezzedButton()
                }
                .padding(.vertical)
                
                Text("\(tracker.freezeDays) out of \(tracker.freezeLeft) freezes used")
                    .soSmallCenterGrayText()
            }
        }
        
        // Provides a view when no tracker data is available
        func noTrackerDataView() -> some View {
            Text("No tracker data available")
                .soSmallCenterGrayText()
                .padding(.top)
        }
        
        // Combines the learned and freeze day views, or shows a "no data" view if no tracker exists
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

        // Populates missing days from the journey's start date to today with status 0
        func populateMissingDays() {
            guard let journey = lastTracker else { return }
            
            let today = Calendar.current.startOfDay(for: Date())
            var date = Calendar.current.startOfDay(for: journey.startDate)
            
            while date <= today {
                if !journey.tracker.contains(where: { Calendar.current.isDate($0.dayDate, inSameDayAs: date) }) {
                    let newTracker = JourneyTracker(dayDate: date, dayStatus: 0)
                    journey.tracker.append(newTracker)
                }
                date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            }
            
            do {
                try modelContext.save()
                print("Missing days populated successfully.")
            } catch {
                print("Failed to populate missing days: \(error.localizedDescription)")
            }
        }
        
        // Retrieves the current streak count
        func getStreak() -> Int {
            if let currentTracker = lastTracker {
                return currentTracker.streakDays
            }
            return 0
        }
        
        // Retrieves the current freeze day count
        func getFreeze() -> Int {
            if let currentTracker = lastTracker {
                return currentTracker.freezeDays
            }
            return 0
        }
        
        // Initializes the ViewModel with a model context, fetching data and populating missing days
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchData()
            populateMissingDays()
            
            // Ensures streak and freeze values are updated if lastTracker exists
            if let tracker = lastTracker {
                tracker.calculateStreakAndFreeze(context: modelContext, lastTracker: tracker)
            } else {
                print("No journeys found.")
            }
        }
    }
}
