# LearningJourney
LearningJourney is a SwiftUI app designed to help users track their learning progress, manage goals, and visualize their journey over time. The app includes features like streak tracking, freeze days, and an onboarding experience to guide users in setting up their goals. It follows the MVVM architecture, integrates SwiftData for data persistence, and SwiftDate for flexible date manipulation.

## Features

- **Daily Progress Tracking:** Track and update your learning progress daily using the `CurrentDay` view.
- **Streak Tracking:** Keep track of consecutive learning days, with an automatic reset if a day is missed.
- **Freeze Days:** Pause your streak when needed with freeze days, which prevent streak loss without breaking continuity.
- **Onboarding Experience:** A user-friendly onboarding process, designed in the `Onboarding.swift` file, to get users started with their learning goals.
- **Data Persistence with SwiftData:** All data, including daily goals, progress, streaks, and freeze days, are stored securely for seamless app experiences.

## Getting Started

### Prerequisites

- **macOS**: macOS 12.0 or later
- **Xcode**: Xcode 14.0 or later
- **Swift 5.5** or later
- **SwiftDate**: A third-party library to handle date calculations
- **SwiftData**: Used for data persistence

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/LearningJourney.git
   cd LearningJourney
   ```

2. Open the project in Xcode:
   ```bash
   open LearningJourney.xcodeproj
   ```

3. Install dependencies (if any) using Swift Package Manager.

4. Build and run the project on a simulator or device.

### Usage

1. **Onboarding**: The onboarding screen will guide you through the initial setup of your learning goals and preferred tracking options.
2. **Track Progress**: Use the daily tracking screen to mark your progress. Goals are visually represented with icons that change with each quarter of completion.
3. **Freeze Days**: When needed, activate freeze days to pause your streak without affecting your progress.
4. **Custom Calendar**: Visualize your journey on the calendar view. Days are color-coded based on your completion status, providing a clear view of your achievements over time.

## Project Structure

- `Models`: Contains the data models, such as `Journey` (with `streakDays`, `freezeDays`, `freezeLeft`) and methods for calculating durations and freeze periods.
- `Views`: Contains SwiftUI views for displaying progress, goals, calendar, and onboarding screens.
- `ViewModels`: Manages data flow and logic using the MVVM pattern.
- `Helpers`: Additional utility classes or extensions, such as `SwiftDate` extensions for date calculations.

## Customization

The app offers several customization options:
- **Colors**: You can update colors in the style file to match your brand.
- **Button Styles**: Customize button sizes, colors, and shapes using the `selectedButton` and `unselectedButton` styles or the `freezeView`, `learnedView`, and `logView` configurations.
- **Icons**: Modify or add icons in the progress tracking section based on personal preference.

## Views Images



<img width="180" alt="onBordingView" src="https://github.com/user-attachments/assets/6c3c7807-ec1c-4513-ba70-617980bbc36a">
<img width="180" alt="onProgresView" src="https://github.com/user-attachments/assets/84bcae03-6f2b-4733-924a-a3c8c5248695">
<img width="180" alt="FreezedDayView" src="https://github.com/user-attachments/assets/3912f863-f599-49b2-bac3-d0753f5681ef">
<img width="180" alt="loggedView" src="https://github.com/user-attachments/assets/85075b00-49c1-480e-a246-1a032b1b0355">
<img width="180" alt="updateView" src="https://github.com/user-attachments/assets/e4b56155-3173-482e-9678-f2f4e2348068">





