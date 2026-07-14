import Foundation

struct LibraryStatistics: Equatable {
    let photoCount: Int
    let videoCount: Int
    let estimatedLibrarySizeInBytes: Int64?
    let firstDate: Date?
    let lastDate: Date?
    let albumCount: Int
    let smartAlbumCount: Int
    let peopleCount: Int
    let geolocatedPlaceCount: Int
    let favoriteCount: Int

    static let empty = LibraryStatistics(
        photoCount: 0,
        videoCount: 0,
        estimatedLibrarySizeInBytes: nil,
        firstDate: nil,
        lastDate: nil,
        albumCount: 0,
        smartAlbumCount: 0,
        peopleCount: 0,
        geolocatedPlaceCount: 0,
        favoriteCount: 0
    )
}
