import SwiftUI

enum SidebarItem: String, CaseIterable, Identifiable {
    case dashboard
    case dailyReview
    case events
    case projects
    case people
    case places
    case collections
    case search
    case libraryHealth
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .dashboard: "Dashboard"
        case .dailyReview: "Daily Review"
        case .events: "Events"
        case .projects: "Projects"
        case .people: "People"
        case .places: "Places"
        case .collections: "Collections"
        case .search: "Search"
        case .libraryHealth: "Library Health"
        case .settings: "Settings"
        }
    }

    var displayTitle: String {
        "\(emoji) \(title)"
    }

    var emoji: String {
        switch self {
        case .dashboard: "🏠"
        case .dailyReview: "📅"
        case .events: "📆"
        case .projects: "📂"
        case .people: "👥"
        case .places: "📍"
        case .collections: "🏷"
        case .search: "🔎"
        case .libraryHealth: "📈"
        case .settings: "⚙️"
        }
    }

    var symbolName: String {
        switch self {
        case .dashboard: "house"
        case .dailyReview: "calendar.badge.clock"
        case .events: "calendar"
        case .projects: "folder"
        case .people: "person.2"
        case .places: "mappin.and.ellipse"
        case .collections: "tag"
        case .search: "magnifyingglass"
        case .libraryHealth: "chart.line.uptrend.xyaxis"
        case .settings: "gearshape"
        }
    }
}
