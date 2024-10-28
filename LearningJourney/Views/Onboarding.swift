import SwiftUI
import SwiftData

struct Onboarding: View {
    
    @State private var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Circle()
                        .fill(myColors.AppGray)
                        .frame(width: 118, height: 118)
                    Text("🔥")
                        .font(.system(size: 55))
                }
                .padding(.top, 60)
                .padding(.bottom, 60)
                
                VStack {
                    Text("Hello Learner!")
                        .largeWhiteText()
                    
                    Spacer().frame(height: 5)
                    Text("This app will help you learn everyday")
                        .smallGrayText()
                    
                    Text("I want to learn")
                        .mediumWhiteText()
                        .padding(.top, 20)
                    
                    ZStack(alignment: .bottom) {
                        TextField("", text: $viewModel.skill)
                            .smallGrayText()
                            .accentColor(myColors.AppOrange)
                        
                            .padding(.horizontal, 10)
                            .padding(.bottom, 5)
                        
                        Spacer().frame(height: 10)
                        
                        Rectangle()
                            .frame(height: 0.5)
                            .foregroundColor(myColors.AppGray)
                    }
                    
                    Text("I want to learn it in a")
                        .mediumWhiteText()
                        .padding(.top, 15)
                    
                    HStack(spacing: 10) {
                        ForEach(viewModel.timePeriods.indices, id: \.self) { index in
                            Button(action: {
                                viewModel.durationINdex = index
                                viewModel.selectButton(at: index)
                            }) {
                                Text(viewModel.timePeriods[index])
                            }
                            .if(viewModel.isSelected[index]) { view in
                                view.selectedButton()
                            }
                            .if(!viewModel.isSelected[index]) { view in
                                view.unselectedButton()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer().frame(height: 30)
                    
                    NavigationLink(
                        destination: CurrentDay(modelContext: viewModel.modelContext).navigationBarBackButtonHidden(true),
                        label: {
                            Text("Start →")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(width: 151, height: 52)
                                .background(myColors.AppOrange)
                                .cornerRadius(8)
                        }
                    )
                    .simultaneousGesture(TapGesture().onEnded {
                        viewModel.initLearningJourney(viewModel.timePeriods[viewModel.durationINdex], 0, 0, 2)
                    })
                    .padding(.top, 20)
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.black)
        }
        .background(Color.black.ignoresSafeArea())
    }
    
    
    
    
    init(modelContext: ModelContext) {
        
            let viewModel = ViewModel(modelContext: modelContext)
            _viewModel = State(initialValue: viewModel)
        
        }
}
