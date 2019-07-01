//
//  ImageReader.swift
//  Blink
//
//  Created by Yudi Zhou on 6/30/19.
//  Copyright © 2019 Yudi Zhou. All rights reserved.
//

import Cocoa

class ImageManager {
    
    private var images: [ImageData]!
    private var imageIndex: Int = 0
    
    init(url: URL) {
        load(url: url)
    }
    
    func load(url: URL) {
        images = [ImageData]()
        
        if url.hasDirectoryPath {
            deepLoadAllImages(url: url)
        } else {
            deepLoadAllImages(url: url.deletingLastPathComponent())
            updateImageIndex(target: url)
        }
    }
    
    func getCurrentImageData() throws -> (NSImage, String) {
        return try generateData(index: imageIndex)
    }
    
    func iterateNext() {
        if (imageIndex == images.count - 1) {
            imageIndex = 0
        } else {
            imageIndex = imageIndex + 1
        }
    }
    
    func iteratePrev() {
        if (imageIndex == 0) {
            imageIndex = images.count - 1
        } else {
            imageIndex = imageIndex - 1
        }
    }
    
    func sortByFileName() {
        images = images.sorted (by: { $0.url.absoluteString < $1.url.absoluteString })
    }
    
    func sortByModificationDate() {
        images = images.sorted(by: { $0.modificationDate.compare($1.modificationDate as Date) == ComparisonResult.orderedAscending })
    }
    
    func sortByCreationDate() {
        images = images.sorted(by: { $0.creationDate.compare($1.creationDate as Date) == ComparisonResult.orderedAscending })
    }
    
    private func deepLoadAllImages(url: URL) {
        print(url.absoluteString)
        do {
            let resourceKeys : [URLResourceKey] = [.creationDateKey, .contentModificationDateKey]
            let fileEnumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: resourceKeys, options: [.skipsHiddenFiles])!
            for case let itemUrl as URL in fileEnumerator {
                if isDocumentValid(url: itemUrl) {
                    let resourceValues = try itemUrl.resourceValues(forKeys: Set(resourceKeys))
                    try images.append(createImageData(url: itemUrl, resourceValues: resourceValues))
                }
            }
        } catch {
            print("Error while loading files: \(error.localizedDescription)")
        }
    }
    
    private func shallowLoadAllImages(url: URL) {
        do {
            let resourceKeys : [URLResourceKey] = [.creationDateKey, .contentModificationDateKey]
            let urls = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: resourceKeys, options: .skipsHiddenFiles)
            for itemUrl in urls {
                if self.isDocumentValid(url: itemUrl) {
                    let resourceValues = try itemUrl.resourceValues(forKeys: Set(resourceKeys))
                    try images.append(createImageData(url: itemUrl, resourceValues: resourceValues))
                }
            }
        } catch {
            print("Error while loading files: \(error.localizedDescription)")
        }
    }
    
    private func isDocumentValid(url: URL) -> Bool {
        let ext = url.pathExtension.lowercased()
        if (ext == "jpg" || ext == "png" || ext == "jpeg") {
            return true
        }
        return false
    }
    
    private func createImageData(url: URL, resourceValues: URLResourceValues) throws -> ImageData {
        return ImageData(
            url,
            resourceValues.creationDate! as NSDate,
            resourceValues.contentModificationDate! as NSDate
        )
    }
    
    private func updateImageIndex(target: URL) {
        for (index, image) in images.enumerated() {
            if (image.url == target) {
                imageIndex = index
            }
        }
    }
    
    private func generateData(index: Int) throws -> (NSImage, String) {
        guard
            let image = NSImage(contentsOf: images[index].url)
        else {
            print("Failed to retrieve image")
            throw ImageManagerError.failedToGenerateImage
        }
        return (image, images[index].fileName)
    }

}

enum ImageManagerError : Error {
    case failedToGenerateImage
}
