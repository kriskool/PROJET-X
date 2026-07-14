import SwiftUI

struct DetailView: View {
    let selection: SidebarItem?

    var body: some View {
        switch selection {
        case .dashboard:
            DashboardView()
        case .dailyReview:
            DailyReviewView()
        case .events:
            EventsView()
        case .projects:
            ProjectsView()
        case .people:
            PeopleView()
        case .places:
            PlacesView()
        case .collections:
            CollectionsView()
        case .search:
            SearchView()
        case .libraryHealth:
            LibraryHealthView()
        case .settings:
            SettingsView()
        case .none:
            EmptyStateView()
        }
    }
}

#Preview {
    DetailView(selection: .dashboard)
}
