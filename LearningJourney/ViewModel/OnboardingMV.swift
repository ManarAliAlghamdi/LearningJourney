import SwiftData
import SwiftUI

extension Onboarding {
    @Observable
    class ViewModel {
        // ModelContext to handle data management and persistence
        var modelContext: ModelContext
        
        // Variables to store the user's skill, time periods for selection, and selected duration index
        var skill: String = "" // Holds the learning skill entered by the user
        var timePeriods = ["Week", "Month", "Year"] // Array of available time periods
        var isSelected = [true, false, false] // Boolean array to track selected time period
        var durationINdex: Int = 0 // Index of the currently selected time period
        var tracker: Journey = Journey(period: "Week") // Tracker for managing the learning journey
        
        // Skill value stored and retrieved from UserDefaults for persistence
        var skillValue: String {
            get {
                UserDefaults.standard.string(forKey: "skill") ?? ""
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "skill")
            }
        }
        
        // Initializer that sets the model context, required for data management
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }
        
        // Initializes the learning journey by creating a new Journey instance and saving it to the database
        func initLearningJourney(_ period: String, _ dayStatus: Int, _ streak: Int, _ freeze: Int) {
            tracker = Journey(period: period) // Create new Journey with the selected period
            
            // Insert tracker into the model context
            modelContext.insert(tracker)
            
            // Save changes if there are unsaved modifications
            if modelContext.hasChanges {
                tracker.tracker[0].dayDate = .now // Set the start date of the journey to today
                tracker.tracker[0].dayStatus = 0 // Initialize day status
                
                do {
                    try modelContext.save() // Persist changes
                    print("Tracker initialized and saved successfully.")
                    skillValue = skill // Save skill to UserDefaults
                } catch {
                    print("Failed to save tracker: \(error.localizedDescription)")
                }
            }
        }

        // Updates the selected time period, ensuring only one period is selected at a time
        func selectButton(at index: Int) {
            for i in 0 ..< isSelected.count {
                isSelected[i] = (i == index) // Set true for selected index, false for others
            }
        }
    }
}
