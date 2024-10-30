import SwiftUI
import SwiftData

@main
struct LearningJourneyApp: App {
    // Declare a ModelContainer to manage the data context for the app
    let container: ModelContainer
    @Environment(\.modelContext) var modelContext // Environment property for accessing the model context
    @AppStorage("skill") private var skillValue: String = "" // Persistent storage for skill selection
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Background color set to black to cover the full screen area
                Color.black.ignoresSafeArea()
                
                // Conditionally show Onboarding or CurrentDay view based on whether skillValue is set
                if skillValue.isEmpty {
                    // Display onboarding flow if no skill is set
                    Onboarding(modelContext: container.mainContext)
                } else {
                    // Display main CurrentDay view if skill has been set
                    CurrentDay(modelContext: container.mainContext)
                }
            }
            .background(Color.black.ignoresSafeArea()) // Ensure the background covers any safe area space
        }
        .modelContainer(container) // Attach the model container to the app's environment
    }
    
    // Initialize the ModelContainer, handling potential errors with a fatal error message
    init() {
        do {
            container = try ModelContainer(for: Journey.self) // Initialize container for Journey model
        } catch {
            fatalError("Failed to create ModelContainer for Journey.") // Critical error message if initialization fails
        }
    }
}
