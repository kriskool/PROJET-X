import SwiftUI

@MainActor
final class AppViewModel: ObservableObject {
    @Published var selection: SidebarItem? = .dashboard

    let sidebarItems = SidebarItem.allCases
}
