import SwiftUI

struct DailyReviewView: View {
    var body: some View {
        BaseScreenView(title: "Daily Review", subtitle: "Review today's photo library activity.", symbolName: "calendar.badge.clock")
    }
}

#Preview {
    DailyReviewView()
}
