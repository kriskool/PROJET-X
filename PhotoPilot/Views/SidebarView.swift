import SwiftUI

struct SidebarView: View {
    let items: [SidebarItem]
    @Binding var selection: SidebarItem?

    var body: some View {
        List(items, selection: $selection) { item in
            NavigationLink(value: item) {
                Label(item.displayTitle, systemImage: item.symbolName)
            }
        }
        .navigationTitle("PhotoPilot")
    }
}

#Preview {
    SidebarView(items: SidebarItem.allCases, selection: .constant(.dashboard))
}
