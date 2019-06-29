//
//  ViewController.swift
//  Blink
//
//  Created by Zhou, Yudi on 6/27/19.
//  Copyright © 2019 Zhou, Yudi. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    @IBOutlet weak var imageView: NSImageView!
    
    private var images: [ImageModel]!
    private var imageIndex: Int = 0
    
    @IBAction func sortByName(_ sender: Any) {
        let target = images[imageIndex].url
        sortAllImagesByFileName()
        updateImageIndex(target: target)
    }
    
    @IBAction func sortByModificationDate(_ sender: Any) {
        let target = images[imageIndex].url
        sortAllImagesByModificationDate()
        updateImageIndex(target: target)
    }
    
    @IBAction func sortByCreationDate(_ sender: Any) {
        let target = images[imageIndex].url
        sortAllImagesByCreationDate()
        updateImageIndex(target: target)
    }
    
    @IBAction func next(_ sender: Any) {
        nextImage()
    }
    
    @IBAction func previous(_ sender: Any) {
        previousImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func openImages() {
        let dialog = NSOpenPanel()
        
        if (dialog.runModal() == .OK) {
            loadAllImagesUnderCurrentDirectory(url: dialog.url!)
        } else {
            return
        }
        
        displayImagePerIndex(index: imageIndex)
    }
    
    func openImages(url: URL) {
        loadAllImagesUnderCurrentDirectory(url: url)
        displayImagePerIndex(index: imageIndex)
    }
    
    private func nextImage() {
        if (imageIndex == images.count - 1) {
            imageIndex = 0
        } else {
            imageIndex = imageIndex + 1
        }
        displayImagePerIndex(index: imageIndex)
    }
    
    private func previousImage() {
        if (imageIndex == 0) {
            imageIndex = images.count - 1
        } else {
            imageIndex = imageIndex - 1
        }
        displayImagePerIndex(index: imageIndex)
    }
    
    private func displayImagePerIndex(index: Int) {
        let image = NSImage(contentsOf: images[index].url)
        if (image == nil) {
            print("Failed to retrieve image")
            return
        }
        self.view.window?.title = images[index].fileName
        imageView.image = image
    }
    
    private func loadAllImagesUnderCurrentDirectory(url: URL) {
        images = [ImageModel]()
        
        if url.hasDirectoryPath {
            deepLoadAllImages(url: url)
            sortAllImagesByModificationDate()
        } else {
            deepLoadAllImages(url: url.deletingLastPathComponent())
            sortAllImagesByModificationDate()
            updateImageIndex(target: url)
        }
    }
    
    private func deepLoadAllImages(url: URL) {
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
    
    private func createImageData(url: URL, resourceValues: URLResourceValues) throws -> ImageModel {
        return ImageModel(
            url,
            resourceValues.creationDate! as NSDate,
            resourceValues.contentModificationDate! as NSDate
        )
    }

    private func sortAllImagesByFileName() {
        images = images.sorted (by: { $0.fileName < $1.fileName })
    }
    
    private func sortAllImagesByModificationDate() {
        images = images.sorted(by: { $0.modificationDate.compare($1.modificationDate as Date) == ComparisonResult.orderedAscending })
    }
    
    private func sortAllImagesByCreationDate() {
        images = images.sorted(by: { $0.creationDate.compare($1.creationDate as Date) == ComparisonResult.orderedAscending })
    }
    
    private func updateImageIndex(target: URL) {
        for (index, image) in images.enumerated() {
            if (image.url == target) {
                imageIndex = index
            }
        }
    }

}

