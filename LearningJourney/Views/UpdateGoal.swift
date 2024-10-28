import SwiftUI

struct UpdateLearningGoal: View {
    @Binding var SkillName: String
    
    @Environment(\.presentationMode) var presentationMode
    @State private var timePeriods = ["Week", "Month", "Year"]
    @State private var isSelected = [true, false, false] // Boolean list to track selected state
    
    var body: some View {
        VStack {
            // Custom Navigation Bar
            HStack {
                // Back Button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(myColors.AppOrange)
                    .font(.system(size: 18, weight: .regular))
                }
                
                Spacer()
                
                // Title
                Text("Learning goal")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold))
                
                Spacer()
                
                // Update Button
                Button(action: {
                    // Update action
                }) {
                    Text("Update")
                        .foregroundColor(myColors.AppOrange)
                        .font(.system(size: 17, weight: .semibold, design: .default))
                        .lineSpacing(22 - 17)
                }
            }
            .padding()
            .background(Color.black)
            
            VStack {
                
                Text("I want to learn")
                    .mediumWhiteText()
                    .padding(.top, 20)
                
                ZStack(alignment: .bottom) {
                    TextField("", text: $SkillName)
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
                
                // Dynamic Buttons List
                HStack(spacing: 10) {
                    ForEach(timePeriods.indices, id: \.self) { index in
                        Button(action: {
                            selectButton(at: index)
                        }) {
                            Text(timePeriods[index])
                        }
                        .if(isSelected[index]) { view in
                            view.selectedButton()
                        }
                        .if(!isSelected[index]) { view in
                            view.unselectedButton()
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
            }.padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity ,alignment: .top)

        .background(Color.black.ignoresSafeArea())
    }
    
    
    private func selectButton(at index: Int) {
        for i in 0..<isSelected.count {
            isSelected[i] = (i == index)
        }
    }
    
}


#Preview {
    UpdateLearningGoal(SkillName: .constant("Swift"))
}
