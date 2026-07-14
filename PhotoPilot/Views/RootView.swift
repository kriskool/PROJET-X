import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = AppViewModel()

    var body: some View {
        NavigationSplitView {
            SidebarView(items: viewModel.sidebarItems, selection: $viewModel.selection)
        } detail: {
            DetailView(selection: viewModel.selection)
        }
        .navigationTitle(viewModel.selection?.title ?? "PhotoPilot")
    }
}

#Preview {
    RootView()
}
