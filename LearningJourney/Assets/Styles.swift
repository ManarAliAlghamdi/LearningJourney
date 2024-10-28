import SwiftUI

struct SmallGrayText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .regular, design: .default))
            .foregroundColor(myColors.AppGray)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
struct SoSmallGrayText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14, weight: .regular, design: .default))
            .foregroundColor(myColors.AppGray)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SoSmallCenterGrayText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14, weight: .regular, design: .default))
            .foregroundColor(myColors.AppGray)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}


struct LargeWhiteText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 32, weight: .bold, design: .default))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct MediumWhiteText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
struct CenterMediumWhiteText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 24, weight: .semibold, design: .default))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct UnselectedButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 68, height: 37)
            .background(myColors.AppDarkGray)
            .foregroundColor(myColors.AppOrange)
            .cornerRadius(6)
    }
}

struct SelecteButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .semibold, design: .rounded))
            .frame(width: 68, height: 37)
            .background(myColors.AppOrange)
            .foregroundColor(Color.black)
            .cornerRadius(6)
    }
}

struct FreezeView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 41, weight: .semibold))
            .frame(width: 320, height: 320)
            .background(myColors.AppDarkBlue)
            .foregroundColor(myColors.AppBlue)
            .clipShape(Circle())
    }
}

struct LearnedView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 41, weight: .semibold))
            .frame(width: 320, height: 320)
            .background(myColors.AppDarkOrange)
            .foregroundColor(myColors.AppOrange)
            .clipShape(Circle())
    }
}

struct LogView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 41, weight: .semibold))
            .frame(width: 320, height: 320)
            .background(myColors.AppOrange)
            .foregroundColor(Color.black)
            .clipShape(Circle())
    }
}

struct FreezeingButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .semibold))
            .frame(width: 162, height: 52)
            .background(myColors.ApplightBlue)
            .foregroundColor(myColors.AppBlue)
            .cornerRadius(8)
    }
}

struct FrezzedButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .semibold))
            .frame(width: 162, height: 52)
            .background(myColors.AppDarkGray)
            .foregroundColor(myColors.ApplightGray)
            .cornerRadius(8)
    }
}

extension View {
    func smallGrayText() -> some View {
        self.modifier(SmallGrayText())
    }
    
    func soSmallGrayText() -> some View {
        self.modifier(SoSmallGrayText())
    }
    func soSmallCenterGrayText() -> some View {
        self.modifier(SoSmallCenterGrayText())
    }
    
    func largeWhiteText() -> some View {
        self.modifier(LargeWhiteText())
    }
    
    func mediumWhiteText() -> some View {
        self.modifier(MediumWhiteText())
    }
    func centerMediumWhiteText() -> some View {
        self.modifier(CenterMediumWhiteText())
    }
    
    func unselectedButton() -> some View {
        self.modifier(UnselectedButton())
    }
    
    func selectedButton() -> some View {
        self.modifier(SelecteButton())
    }
    
    func freezeView() -> some View {
        self.modifier(FreezeView())
    }
    
    func learnedView() -> some View {
        self.modifier(LearnedView())
    }
    
    func logView() -> some View {
        self.modifier(LogView())
    }
    
    func freezeingButton() -> some View {
        self.modifier(FreezeingButton())
    }
    
    func frezzedButton() -> some View {
        self.modifier(FrezzedButton())
    }
}







struct myColors {
    static let o = UIColor(red: 255.0 / 255.0, green: 159.0 / 255.0, blue: 10.0 / 255.0, alpha: 1)
    static let AppGray = Color(red: 235 / 255, green: 235 / 255, blue: 245 / 255, opacity: 0.3)
    static let AppOrange = Color(red: 255 / 255, green: 159 / 255, blue: 10 / 255)
    static let AppDarkGray = Color(red: 44 / 255, green: 44 / 255, blue: 46 / 255)
    static let ApplightBlue = Color(red: 193 / 255, green: 221 / 255, blue: 255 / 255)
    static let ApplightGray = Color(red: 142 / 255, green: 142 / 255, blue: 147 / 255)
    static let AppDarkBlue = Color(red: 2 / 255, green: 31 / 255, blue: 61 / 255)
    static let AppBlue = Color(red: 10 / 255, green: 132 / 255, blue: 255 / 255)
    static let AppDarkOrange = Color(red: 66 / 255, green: 40 / 255, blue: 0 / 255)
}

extension View {
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            return AnyView(transform(self))
        } else {
            return AnyView(self)
        }
    }
}
