import SwiftUI
import SwiftData

struct CalendarHeaderView: View {
    @State private var viewModel: ViewModel

    var body: some View {
        VStack {
            HStack {
                if !viewModel.isAtMinDate && !viewModel.isAtSystemMonth {
                    Button(action: {
                        viewModel.changeMonth(by: -1)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 13, weight: .bold, design: .default))
                            .foregroundColor(myColors.AppOrange)
                    }
                }
                
                Text(viewModel.currentMonthYear)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                if !viewModel.isAtMaxDate {
                    Button(action: {
                        viewModel.changeMonth(by: 1)
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(myColors.AppOrange)
                    }
                }
                
                Spacer()
                
                HStack {
                    if viewModel.canChangeDay(by: -7) {
                        Button(action: {
                            viewModel.changeDay(by: -7)
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .medium, design: .default))
                                .foregroundColor(myColors.AppOrange)
                        }
                    }
                    
                    Spacer().frame(width: 35)
                    
                    if viewModel.canChangeDay(by: 7) {
                        Button(action: {
                            viewModel.changeDay(by: 7)
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20, weight: .medium, design: .default))
                                .foregroundColor(myColors.AppOrange)
                        }
                    }
                }
            }
            
            HStack(spacing: 15) {
                ForEach(0..<7, id: \.self) { index in
                    let date = viewModel.dayForWeekday(index)
                    let isSystemToday = viewModel.calendar.isDateInToday(date)
                    
                    Text(viewModel.weekdayName(for: index))
                        .font(.system(size: 13, weight: isSystemToday ? .semibold : .regular))
                        .foregroundColor(isSystemToday ? .white : myColors.AppGray)
                        .frame(maxWidth: .infinity)
                        .textCase(.uppercase)
                }
            }
            .padding(.vertical, 10)
            
            HStack() {
                ForEach(viewModel.daysInCurrentWeek(), id: \.self) { date in
                    VStack {
                        if viewModel.isWithinMonth(date: date) {
                            Button(action: {
                                viewModel.updateDayStatus(for: date)
                            }) {
                                Text(viewModel.dayNumber(for: date))
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(viewModel.dayTextColor(for: date))
                                    .frame(width: 40, height: 44)
                                    .background(viewModel.dayBackground(for: date))
                                    .clipShape(Circle())
                            }
                        } else {
                            Text("")
                                .font(.body)
                                .frame(width: 40, height: 40)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }/*.padding(.horizontal)*/
        }
        .background(Color.black)
        .onAppear {
            viewModel.setInitialDate()
        }
    }
    
    
    init(modelContext: ModelContext) {
        
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
        
    }
}
