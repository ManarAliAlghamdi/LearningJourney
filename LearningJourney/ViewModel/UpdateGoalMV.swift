import SwiftData
import SwiftUI

extension UpdateLearningGoal {
    @Observable
    class ViewModel {
        // ModelContext to handle data operations and persistence
        var modelContext: ModelContext
        
        // Array of time period options, boolean array for selection state, and index for selected period
        var timePeriods = ["Week", "Month", "Year"] // Available time periods for learning goal
        var isSelected = [true, false, false] // Tracks which time period is currently selected
        var durationINdex: Int = 0 // Index of selected time period

        // Tracker instance for managing the user's learning journey
        var tracker: Journey = Journey(period: "Week")
        
        // Skill value is stored and retrieved from UserDefaults, maintaining persistence
        var skillValue: String {
            get {
                UserDefaults.standard.string(forKey: "skill") ?? ""
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "skill")
            }
        }
        
        // Function to update the selected time period, ensuring only one period is selected at a time
        func selectButton(at index: Int) {
            for i in 0..<self.isSelected.count {
                self.isSelected[i] = (i == index) // Set true for selected index, false for others
            }
        }
        
        // Updates the learning journey by creating a new Journey instance and saving it to the database
        func updateLearningJourney(_ period: String, _ dayStatus: Int, _ streak: Int, _ freeze: Int) {
            tracker = Journey(period: period) // Create a new Journey with the selected period
            
            // Insert the tracker into the model context
            modelContext.insert(tracker)
            
            // Save changes if there are unsaved modifications
            if modelContext.hasChanges {
                tracker.tracker[0].dayDate = .now // Set today's date for the start of the journey
                tracker.tracker[0].dayStatus = 0 // Initialize the day status
                
                do {
                    try modelContext.save() // Persist changes to the database
                    print("Tracker initialized and saved successfully.")
                } catch {
                    print("Failed to save tracker: \(error.localizedDescription)")
                }
            }
        }

        // Initializer for setting up the ViewModel with a model context
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }
    }
}
