import SwiftUI
import SwiftData

struct Onboarding: View {
    
    // State property to manage the ViewModel instance
    @State private var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // Icon at the top with a background circle
                ZStack {
                    Circle()
                        .fill(myColors.AppGray)
                        .frame(width: 118, height: 118) // Circular gray background
                    Text("🔥")
                        .font(.system(size: 55)) // Emoji icon for onboarding
                }
                .padding(.top, 60)
                .padding(.bottom, 60)
                
                VStack {
                    // Greeting text for the user
                    Text("Hello Learner!")
                        .largeWhiteText()
                    
                    Spacer().frame(height: 5) // Small spacer for layout
                    
                    // Description text for the app’s purpose
                    Text("This app will help you learn everyday")
                        .smallGrayText()
                    
                    // Prompt text for entering the learning goal
                    Text("I want to learn")
                        .mediumWhiteText()
                        .padding(.top, 20)
                    
                    // Text field for entering the skill
                    ZStack(alignment: .bottom) {
                        TextField("", text: $viewModel.skill)
                            .smallGrayText()
                            .accentColor(myColors.AppOrange) // Orange accent for the cursor
                            .padding(.horizontal, 10)
                            .padding(.bottom, 5)
                        
                        Spacer().frame(height: 10) // Spacer for layout adjustment
                        
                        // Underline for the text field
                        Rectangle()
                            .frame(height: 0.5)
                            .foregroundColor(myColors.AppGray)
                    }
                    
                    // Prompt text for selecting the learning duration
                    Text("I want to learn it in a")
                        .mediumWhiteText()
                        .padding(.top, 15)
                    
                    // Buttons for selecting the time period (e.g., week, month, year)
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
                    
                    Spacer().frame(height: 30) // Spacer for layout
                    
                    // Navigation link to start the journey and navigate to CurrentDay view
                    NavigationLink(
                        destination: CurrentDay(modelContext: viewModel.modelContext).navigationBarBackButtonHidden(true),
                        label: {
                            Text("Start →")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(width: 151, height: 52)
                                .background(myColors.AppOrange)
                                .cornerRadius(8) // Rounded corners for the button
                        }
                    )
                    .simultaneousGesture(TapGesture().onEnded {
                        // Initialize learning journey with selected duration on start
                        viewModel.initLearningJourney(viewModel.timePeriods[viewModel.durationINdex], 0, 0, 2)
                    })
                    .padding(.top, 20) // Padding above the "Start" button
                }
                .padding() // Padding for inner VStack
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // Full-screen alignment
            .background(Color.black) // Background color for onboarding screen
        }
        .background(Color.black.ignoresSafeArea()) // Full-screen black background
    }
    
    // Custom initializer to pass the model context and initialize the ViewModel
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
}
