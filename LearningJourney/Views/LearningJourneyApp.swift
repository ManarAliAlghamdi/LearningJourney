import SwiftUI
import SwiftData

@main
struct LearningJourneyApp: App {
    let container: ModelContainer
    @Environment(\.modelContext) var modelContext
    @AppStorage("skill") private var skillValue: String = ""
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.black.ignoresSafeArea()
                if skillValue.isEmpty {
                    Onboarding(modelContext: container.mainContext)
                } else {
                    CurrentDay(modelContext: container.mainContext)
                }
            }
            .background(Color.black.ignoresSafeArea())
            
        }
        .modelContainer(container)
    }
    
    init() {
        do {
            container = try ModelContainer(for: Journey.self)
        } catch {
            fatalError("Failed to create ModelContainer for Movie.")
        }
    }
}
    //    func clearAllData() {
    //        do {
    //            let allJourneys: [Journey] = try modelContext.fetch(FetchDescriptor<Journey>())
    //            let allJourneyTrackers: [JourneyTracker] = try modelContext.fetch(FetchDescriptor<JourneyTracker>())
    //
    //            for journey in allJourneys {
    //                modelContext.delete(journey)
    //            }
    //
    //            for tracker in allJourneyTrackers {
    //                modelContext.delete(tracker)
    //            }
    //
    //            try modelContext.save()
    //            print("All data cleared successfully.")
    //    } catch {
    //            print("Failed to clear data: \(error.localizedDescription)")
    //        }
    //    }
    

