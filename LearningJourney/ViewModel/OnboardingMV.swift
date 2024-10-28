
import SwiftData
import SwiftUI

extension Onboarding {
    @Observable
    class ViewModel{
        var modelContext: ModelContext
        
        
         var skill: String = ""
         var timePeriods = ["Week", "Month", "Year"]
         var isSelected = [true, false, false]
         var durationINdex: Int = 0
         var tracker: Journey = Journey(period: "Week") 

        
        var skillValue: String {
                    get {
                        UserDefaults.standard.string(forKey: "skill") ?? ""
                    }
                    set {
                        UserDefaults.standard.set(newValue, forKey: "skill")
                    }
                }
                
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            
            
        }
     
        
        
        func initLearningJourney(_ period: String, _ dayStatus: Int, _ streak: Int, _ freeze: Int) {
            tracker = Journey(period: period)
            
            modelContext.insert(tracker)
            
            if modelContext.hasChanges {
                tracker.tracker[0].dayDate = .now
                       tracker.tracker[0].dayStatus = 0
                   do {
                    try modelContext.save()
                    print("Tracker initialized and saved successfully.")
                       skillValue = skill
                } catch {
                    print("Failed to save tracker: \(error.localizedDescription)")
                }
            }
        }

         func selectButton(at index: Int) {
            for i in 0 ..< isSelected.count {
                isSelected[i] = (i == index)
            }
        }
    }
}
