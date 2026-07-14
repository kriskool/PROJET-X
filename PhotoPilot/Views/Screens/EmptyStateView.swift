import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        BaseScreenView(title: "PhotoPilot", subtitle: "Select a section from the sidebar.", symbolName: "sidebar.left")
    }
}

#Preview {
    EmptyStateView()
}
