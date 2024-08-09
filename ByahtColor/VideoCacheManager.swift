//
//  VideoCacheManager.swift
//  ByahtColor
//
//  Created by jaem on 8/8/24.
//

import Foundation

class VideoCacheManager {
    static let shared = VideoCacheManager()
    private let cacheLimit: Int64 = 100 * 1024 * 1024 // 100MB
    private let fileManager = FileManager.default

    private init() {}

    func getLocalFilePath(for url: URL) -> URL {
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let fileName = url.lastPathComponent
        return cachesDirectory.appendingPathComponent(fileName)
    }

    func cacheVideo(from url: URL, completion: @escaping (URL?) -> Void) {
        let localFilePath = getLocalFilePath(for: url)

        if fileManager.fileExists(atPath: localFilePath.path) {
            completion(localFilePath)
        } else {
            URLSession.shared.downloadTask(with: url) { tempLocalUrl, _, error in
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    do {
                        try self.manageCacheSize()
                        try self.fileManager.copyItem(at: tempLocalUrl, to: localFilePath)
                        completion(localFilePath)
                    } catch {
                        print("Error caching video: \(error)")
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }.resume()
        }
    }

    private func manageCacheSize() throws {
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let cachedFiles = try fileManager.contentsOfDirectory(at: cachesDirectory, includingPropertiesForKeys: [.creationDateKey, .fileSizeKey], options: .skipsHiddenFiles)

        var totalCacheSize: Int64 = 0
        var fileInfoList: [(url: URL, size: Int64, creationDate: Date)] = []

        for fileURL in cachedFiles {
            let attributes = try fileManager.attributesOfItem(atPath: fileURL.path)
            if let fileSize = attributes[.size] as? Int64,
               let creationDate = attributes[.creationDate] as? Date {
                totalCacheSize += fileSize
                fileInfoList.append((url: fileURL, size: fileSize, creationDate: creationDate))
            }
        }

        if totalCacheSize > cacheLimit {
            fileInfoList.sort { $0.creationDate < $1.creationDate } // 오래된 파일 순으로 정렬
            for fileInfo in fileInfoList {
                try fileManager.removeItem(at: fileInfo.url)
                totalCacheSize -= fileInfo.size
                if totalCacheSize <= cacheLimit {
                    break
                }
            }
        }
    }
}
