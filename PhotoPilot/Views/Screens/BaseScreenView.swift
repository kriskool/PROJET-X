import SwiftUI

struct BaseScreenView: View {
    let title: String
    let subtitle: String
    let symbolName: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: symbolName)
                .font(.system(size: 44))
                .foregroundStyle(.secondary)

            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)

            Text(subtitle)
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    BaseScreenView(title: "Dashboard", subtitle: "Ready for development.", symbolName: "house")
}
