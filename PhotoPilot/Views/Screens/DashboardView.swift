import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                loadingView
            case .authorized(let statistics):
                statisticsView(statistics)
            case .denied:
                authorizationRequestView
            case .failed(let message):
                failureView(message)
            }
        }
        .task {
            await viewModel.loadStatistics()
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .controlSize(.large)
            Text("Analyse de votre photothèque…")
                .font(.headline)
            Text("PhotoPilot lit les statistiques directement depuis Apple Photos.")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private func statisticsView(_ statistics: LibraryStatistics) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 190), spacing: 16)], spacing: 16) {
                    StatisticCard(title: "Photos", value: statistics.photoCount.formatted(), systemImage: "photo")
                    StatisticCard(title: "Vidéos", value: statistics.videoCount.formatted(), systemImage: "video")
                    StatisticCard(title: "Taille estimée", value: formattedSize(statistics.estimatedLibrarySizeInBytes), systemImage: "internaldrive")
                    StatisticCard(title: "Première date", value: formattedDate(statistics.firstDate), systemImage: "calendar.badge.clock")
                    StatisticCard(title: "Dernière date", value: formattedDate(statistics.lastDate), systemImage: "calendar")
                    StatisticCard(title: "Albums", value: statistics.albumCount.formatted(), systemImage: "rectangle.stack")
                    StatisticCard(title: "Albums intelligents", value: statistics.smartAlbumCount.formatted(), systemImage: "sparkles.rectangle.stack")
                    StatisticCard(title: "Personnes", value: statistics.peopleCount.formatted(), systemImage: "person.2")
                    StatisticCard(title: "Lieux géolocalisés", value: statistics.geolocatedPlaceCount.formatted(), systemImage: "map")
                    StatisticCard(title: "Favoris", value: statistics.favoriteCount.formatted(), systemImage: "heart")
                }
            }
            .padding(32)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var authorizationRequestView: some View {
        VStack(spacing: 18) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 56))
                .foregroundStyle(Color.accentColor)
            Text("Autorisez l’accès à Apple Photos")
                .font(.title2.weight(.semibold))
            Text("PhotoPilot a besoin de lire votre photothèque via PhotoKit pour afficher vos vraies statistiques. Aucune donnée fictive n’est utilisée.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .frame(maxWidth: 460)
            Button("Réessayer") {
                Task {
                    await viewModel.loadStatistics()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private func failureView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(.orange)
            Text("Impossible de lire la photothèque")
                .font(.title3.weight(.semibold))
            Text(message)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Dashboard", systemImage: "house")
                .font(.largeTitle.weight(.bold))
            Text("Statistiques réelles de la photothèque Apple Photos.")
                .foregroundStyle(.secondary)
        }
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date else { return "Indisponible" }
        return date.formatted(date: .abbreviated, time: .omitted)
    }

    private func formattedSize(_ bytes: Int64?) -> String {
        guard let bytes else { return "Indisponible" }
        return ByteCountFormatter.string(fromByteCount: bytes, countStyle: .file)
    }
}

private struct StatisticCard: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(Color.accentColor)
            Text(value)
                .font(.title2.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Text(title)
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    DashboardView()
}
