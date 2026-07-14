import Foundation
import Photos

struct PhotoLibraryService {
    enum AuthorizationState: Equatable {
        case authorized
        case denied
    }

    enum PhotoLibraryServiceError: Error, Equatable {
        case accessDenied
    }

    func requestAuthorization() async -> AuthorizationState {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)

        switch status {
        case .authorized, .limited:
            return .authorized
        case .notDetermined:
            let requestedStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            return Self.authorizationState(for: requestedStatus)
        case .denied, .restricted:
            return .denied
        @unknown default:
            return .denied
        }
    }

    func fetchStatistics() async throws -> LibraryStatistics {
        guard await requestAuthorization() == .authorized else {
            throw PhotoLibraryServiceError.accessDenied
        }

        return await Task.detached(priority: .userInitiated) {
            let imageAssets = PHAsset.fetchAssets(with: .image, options: nil)
            let videoAssets = PHAsset.fetchAssets(with: .video, options: nil)
            let allAssets = PHAsset.fetchAssets(with: nil)
            let favoriteAssets = Self.fetchFavoriteAssets()

            let dateRange = Self.dateRange(in: allAssets)

            return LibraryStatistics(
                photoCount: imageAssets.count,
                videoCount: videoAssets.count,
                estimatedLibrarySizeInBytes: Self.estimatedLibrarySize(in: allAssets),
                firstDate: dateRange.first,
                lastDate: dateRange.last,
                albumCount: Self.albumCount(),
                smartAlbumCount: Self.smartAlbumCount(),
                peopleCount: Self.peopleCount(),
                geolocatedPlaceCount: Self.geolocatedPlaceCount(in: allAssets),
                favoriteCount: favoriteAssets.count
            )
        }.value
    }

    private static func authorizationState(for status: PHAuthorizationStatus) -> AuthorizationState {
        switch status {
        case .authorized, .limited:
            return .authorized
        case .notDetermined, .denied, .restricted:
            return .denied
        @unknown default:
            return .denied
        }
    }

    private static func fetchFavoriteAssets() -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "favorite == YES")
        return PHAsset.fetchAssets(with: options)
    }

    private static func dateRange(in assets: PHFetchResult<PHAsset>) -> (first: Date?, last: Date?) {
        var firstDate: Date?
        var lastDate: Date?

        assets.enumerateObjects { asset, _, _ in
            guard let creationDate = asset.creationDate else { return }

            if firstDate == nil || creationDate < firstDate! {
                firstDate = creationDate
            }

            if lastDate == nil || creationDate > lastDate! {
                lastDate = creationDate
            }
        }

        return (firstDate, lastDate)
    }

    private static func albumCount() -> Int {
        PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil).count
    }

    private static func smartAlbumCount() -> Int {
        PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil).count
    }

    private static func peopleCount() -> Int {
        PHPerson.fetchPersons(with: nil).count
    }

    private static func geolocatedPlaceCount(in assets: PHFetchResult<PHAsset>) -> Int {
        var places = Set<CoordinateKey>()

        assets.enumerateObjects { asset, _, _ in
            guard let coordinate = asset.location?.coordinate else { return }
            places.insert(CoordinateKey(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }

        return places.count
    }

    private static func estimatedLibrarySize(in assets: PHFetchResult<PHAsset>) -> Int64? {
        var totalSize: Int64 = 0
        var didFindSize = false

        assets.enumerateObjects { asset, _, _ in
            PHAssetResource.assetResources(for: asset).forEach { resource in
                if let fileSize = resource.value(forKey: "fileSize") as? CLong {
                    totalSize += Int64(fileSize)
                    didFindSize = true
                }
            }
        }

        return didFindSize ? totalSize : nil
    }
}

private struct CoordinateKey: Hashable {
    let latitude: Double
    let longitude: Double

    init(latitude: Double, longitude: Double) {
        self.latitude = (latitude * 10_000).rounded() / 10_000
        self.longitude = (longitude * 10_000).rounded() / 10_000
    }
}
