import SwiftData
import SwiftUI

struct CurrentDay: View {
    // State property to hold the ViewModel instance
    @State private var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // Display the current date at the top
                Text(viewModel.getCurrentDay())
                    .soSmallGrayText()
                
                Spacer().frame(height: 1) // Small spacer for layout adjustment
                
                // Learning skill section with navigation to update learning goal
                HStack {
                    Text("Learning \(viewModel.skillValue)") // Display current learning skill
                        .largeWhiteText()
                    Spacer()
                    // Navigation link to UpdateLearningGoal view
                    NavigationLink(destination: UpdateLearningGoal(modelContext: viewModel.modelContext).navigationBarBackButtonHidden(true)) {
                        ZStack {
                            Circle()
                                .fill(myColors.AppGray)
                                .frame(width: 44, height: 44) // Icon button with background circle
                            Text("🔥")
                                .font(.system(size: 24)) // Emoji icon for learning goal update
                        }
                    }
                }
                
                VStack {
                    // Calendar header displaying days and navigation
                    CalendarHeaderView(modelContext: viewModel.modelContext)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // Divider line below calendar
                    Rectangle()
                        .frame(height: 1)
                        .frame(width: 345)
                        .foregroundColor(myColors.AppDarkGray)
                    
                    // Streak and freeze day counters
                    HStack {
                        VStack {
                            // Display streak count with emoji
                            Text("  \(viewModel.getStreak())🔥")
                                .centerMediumWhiteText()
                            Text("Day streak") // Label for streak
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(myColors.AppGray)
                                .padding(.bottom, 10)
                        }
                        
                        // Divider between streak and freeze counters
                        Rectangle()
                            .frame(height: 70)
                            .frame(width: 1)
                            .foregroundColor(myColors.AppDarkGray)
                        
                        VStack {
                            // Display freeze count with emoji
                            Text("  \(viewModel.getFreeze())🧊")
                                .centerMediumWhiteText()
                            Text("Day freezed") // Label for freeze days
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(myColors.AppGray)
                                .padding(.bottom, 10)
                        }
                    }
                }
                .frame(width: 400, height: 230, alignment: .top) // Main frame for counters
                .background(
                    RoundedRectangle(cornerRadius: 9)
                        .stroke(myColors.AppGray, lineWidth: 1) // Border for counters section
                )
                
                // Dynamic content for the current day's status
                viewModel.contentForCurrentDay()
            }
            .onAppear {
                viewModel.fetchData() // Load data when the view appears
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.black) // Background color for the main view
        }
        .tint(myColors.AppOrange) // Tint color for navigation elements
        .background(Color.black.ignoresSafeArea()) // Full-screen black background
    }
    
    // Custom initializer to inject modelContext and initialize the ViewModel
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
}
