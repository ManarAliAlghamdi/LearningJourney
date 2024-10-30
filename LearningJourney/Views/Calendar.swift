import SwiftUI
import SwiftData

struct CalendarHeaderView: View {
    // ViewModel to manage calendar logic and data
    @State private var viewModel: ViewModel

    var body: some View {
        VStack {
            // Header with month navigation
            HStack {
                // Left button to navigate to the previous month if within allowed range
                if !viewModel.isAtMinDate && !viewModel.isAtSystemMonth {
                    Button(action: {
                        viewModel.changeMonth(by: -1) // Decrement month
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 13, weight: .bold, design: .default))
                            .foregroundColor(myColors.AppOrange)
                    }
                }
                
                // Display the current month and year
                Text(viewModel.currentMonthYear)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                // Right button to navigate to the next month if within allowed range
                if !viewModel.isAtMaxDate {
                    Button(action: {
                        viewModel.changeMonth(by: 1) // Increment month
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(myColors.AppOrange)
                    }
                }
                
                Spacer()
                
                // Day navigation to move through the week, each step being 7 days
                HStack {
                    if viewModel.canChangeDay(by: -7) {
                        Button(action: {
                            viewModel.changeDay(by: -7) // Decrement by 7 days
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .medium, design: .default))
                                .foregroundColor(myColors.AppOrange)
                        }
                    }
                    
                    Spacer().frame(width: 35) // Space between left and right navigation buttons
                    
                    if viewModel.canChangeDay(by: 7) {
                        Button(action: {
                            viewModel.changeDay(by: 7) // Increment by 7 days
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20, weight: .medium, design: .default))
                                .foregroundColor(myColors.AppOrange)
                        }
                    }
                }
            }
            
            // Display weekday names (Mon, Tue, ...) in the current week
            HStack(spacing: 15) {
                ForEach(0..<7, id: \.self) { index in
                    let date = viewModel.dayForWeekday(index)
                    let isSystemToday = viewModel.calendar.isDateInToday(date) // Check if today
                    
                    Text(viewModel.weekdayName(for: index))
                        .font(.system(size: 13, weight: isSystemToday ? .semibold : .regular))
                        .foregroundColor(isSystemToday ? .white : myColors.AppGray)
                        .frame(maxWidth: .infinity)
                        .textCase(.uppercase)
                }
            }
            .padding(.vertical, 10)
            
            // Display day numbers in the current week
            HStack {
                ForEach(viewModel.daysInCurrentWeek(), id: \.self) { date in
                    VStack {
                        if viewModel.isWithinMonth(date: date) {
                            // Button to update day status; displays the day number with background styling
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
                            // Placeholder for dates outside the current month
                            Text("")
                                .font(.body)
                                .frame(width: 40, height: 40)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }/*.padding(.horizontal)*/
        }
        .background(Color.black) // Background color for the calendar header
        .onAppear {
            viewModel.setInitialDate() // Initialize the view to the current date
        }
    }
    
    // Custom initializer to pass the model context and initialize the ViewModel
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
}
