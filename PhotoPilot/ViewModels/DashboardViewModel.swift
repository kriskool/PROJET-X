import Combine
import Foundation

@MainActor
final class DashboardViewModel: ObservableObject {
    enum State: Equatable {
        case loading
        case authorized(LibraryStatistics)
        case denied
        case failed(String)
    }

    @Published private(set) var state: State = .loading

    private let photoLibraryService: PhotoLibraryService

    init(photoLibraryService: PhotoLibraryService = PhotoLibraryService()) {
        self.photoLibraryService = photoLibraryService
    }

    func loadStatistics() async {
        state = .loading

        do {
            let statistics = try await photoLibraryService.fetchStatistics()
            state = .authorized(statistics)
        } catch PhotoLibraryService.PhotoLibraryServiceError.accessDenied {
            state = .denied
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
