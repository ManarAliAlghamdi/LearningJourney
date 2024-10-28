import SwiftData
import SwiftUI
struct CurrentDay: View {
    @State private var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(viewModel.getCurrentDay())
                    .soSmallGrayText()
                Spacer().frame(height: 1)
                
                HStack {
                    Text("Learning \(viewModel.skillValue)")
                        .largeWhiteText()
                    Spacer()
                    NavigationLink(destination: UpdateLearningGoal(SkillName: $viewModel.skillValue).navigationBarBackButtonHidden(true)) {
                        ZStack {
                            Circle()
                                .fill(myColors.AppGray)
                                .frame(width: 44, height: 44)
                            Text("🔥")
                                .font(.system(size: 24))
                        }
                    }
                }
                VStack {
                    CalendarHeaderView(modelContext: viewModel.modelContext)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    Rectangle()
                        .frame(height: 1)
                        .frame(width: 345)
                        .foregroundColor(myColors.AppDarkGray)
                    
                    HStack {
                        VStack {
                            Text("  \(viewModel.getStreak())🔥")
                                .centerMediumWhiteText()
                            Text("Day streak")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(myColors.AppGray)
                                .padding(.bottom, 10)
                        }
                        
                        Rectangle()
                            .frame(height: 70)
                            .frame(width: 1)
                            .foregroundColor(myColors.AppDarkGray)
                        
                        VStack {
                            Text("  \(viewModel.getFreeze())🧊")
                                .centerMediumWhiteText()
                            Text("Day freezed")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(myColors.AppGray)
                                .padding(.bottom, 10)
                        }
                    }
                }
                .frame(width: 367, height: 230, alignment: .top)
                .background(
                    RoundedRectangle(cornerRadius: 9).stroke(myColors.AppGray, lineWidth: 1)
                )
                
                viewModel.contentForCurrentDay()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.black)
        }
        .onAppear {
            viewModel.updateStreakAndFreeze()
        }
        .tint(myColors.AppOrange)
        .background(Color.black.ignoresSafeArea())
    }
    
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
}
