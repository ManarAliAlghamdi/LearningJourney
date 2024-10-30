import SwiftUI
import SwiftData

struct UpdateLearningGoal: View {
    // State property for managing the ViewModel instance
    @State private var viewModel: ViewModel
    
    // Environment variable to handle view presentation mode for dismissing the view
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                // Custom Navigation Bar
                HStack {
                    // Back button to dismiss the view
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left") // Chevron icon for back navigation
                            Text("Back")
                        }
                        .foregroundColor(myColors.AppOrange)
                        .font(.system(size: 18, weight: .regular))
                    }
                    
                    Spacer()
                    
                    // Title for the navigation bar
                    Text("Learning goal")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                    
                    Spacer()
                    
                    // Update button to save changes in learning goal
                    Button(action: {
                        viewModel.updateLearningJourney(viewModel.timePeriods[viewModel.durationINdex], 0, 0, 2)
                    }) {
                        Text("Update")
                            .foregroundColor(myColors.AppOrange)
                            .font(.system(size: 17, weight: .semibold, design: .default))
                            .lineSpacing(22 - 17) // Custom line spacing for button text
                    }
                }
                .padding()
                .background(Color.black) // Background color for the custom navigation bar
                
                VStack {
                    // Prompt text for entering the learning goal
                    Text("I want to learn")
                        .mediumWhiteText()
                        .padding(.top, 20)
                    
                    // Text field to input the skill/goal
                    ZStack(alignment: .bottom) {
                        TextField(viewModel.skillValue, text: $viewModel.skill)
                            .smallGrayText()
                            .accentColor(myColors.AppOrange) // Orange accent for cursor
                            .padding(.horizontal, 10)
                            .padding(.bottom, 5)
                        
                        Spacer().frame(height: 10) // Spacer for layout adjustment
                        
                        // Underline for the text field
                        Rectangle()
                            .frame(height: 0.5)
                            .foregroundColor(myColors.AppGray)
                    }
                    
                    // Prompt text for selecting the duration
                    Text("I want to learn it in a")
                        .mediumWhiteText()
                        .padding(.top, 15)
                    
                    // Dynamic button list for time period options (e.g., week, month, year)
                    HStack(spacing: 10) {
                        ForEach(viewModel.timePeriods.indices, id: \.self) { index in
                            Button(action: {
                                viewModel.durationINdex = index
                                viewModel.selectButton(at: index) // Update selected button
                            }) {
                                Text(viewModel.timePeriods[index])
                            }
                            .if(viewModel.isSelected[index]) { view in
                                view.selectedButton() // Style for selected button
                            }
                            .if(!viewModel.isSelected[index]) { view in
                                view.unselectedButton() // Style for unselected button
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // Align buttons to the leading edge
                    
                }
                .padding(.horizontal) // Padding for the main VStack
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // Full-screen alignment
            .background(Color.black.ignoresSafeArea()) // Full-screen black background
        }
    }
    
    // Custom initializer to inject model context and initialize the ViewModel
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
}
