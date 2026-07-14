import SwiftUI

struct LibraryHealthView: View {
    var body: some View {
        BaseScreenView(title: "Library Health", subtitle: "Monitor the state of the photo library.", symbolName: "chart.line.uptrend.xyaxis")
    }
}

#Preview {
    LibraryHealthView()
}
