//
//  AssetCacheFinder.swift
//
//
//  Created by Kenneth Endfinger on 10/23/21.
//

import Foundation

struct AssetCacheFinder {
    static func find() -> [URL] {
        var results: [URL] = []

        if let rootAssetCacheURL = assetCacheDataURLAtRoot(URL(fileURLWithPath: "/")) {
            results.append(rootAssetCacheURL)
        }

        if let homeAssetCacheURL = assetCacheDataURLAtRoot(FileManager.default.homeDirectoryForCurrentUser) {
            results.append(homeAssetCacheURL)
        }

        guard let mountedVolumeURLs = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: nil, options: .skipHiddenVolumes) else {
            return results
        }

        for url in mountedVolumeURLs {
            guard let assetCacheURL = assetCacheDataURLAtRoot(url) else {
                continue
            }
            results.append(assetCacheURL)
        }

        return results
    }

    static func assetCacheDataURLAtRoot(_ root: URL) -> URL? {
        var actualRootPath = root.path
        if root.path.hasSuffix("/") {
            actualRootPath = String(root.path.prefix(root.path.count - 1))
        }
        let assetCacheDataURL = URL(fileURLWithPath: "\(actualRootPath)/Library/Application Support/Apple/AssetCache/Data")
        let assetCacheDatabaseURL = URL(fileURLWithPath: "\(assetCacheDataURL.path)/AssetInfo.db")
        if FileManager.default.fileExists(atPath: assetCacheDatabaseURL.path) {
            return assetCacheDataURL
        }
        return nil
    }
}
