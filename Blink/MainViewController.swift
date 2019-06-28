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
        
        openImages()
        
        /*
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
        */
        
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
            displayImagePerIndex(index: imageIndex)
        } else {
            return
        }
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
        imageView.image = image
    }
    
    private func loadAllImagesUnderCurrentDirectory(url: URL) {
        images = [ImageModel]()
        
        let fileManager:  FileManager = FileManager()
        do {
            print(url.deletingLastPathComponent())
            let urls = try fileManager.contentsOfDirectory(at: url.deletingLastPathComponent(), includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for currentUrl in urls {
                if isDocumentValid(url: currentUrl) {
                    try images.append(createImageData(url: currentUrl, fileManager: fileManager))
                }
            }
            sortAllImagesByFileName()
            updateImageIndex(target: url)
        } catch {
            print("Error while loading files: \(error.localizedDescription)")
        }
    }
    
    private func isDocumentValid(url: URL) -> Bool {
        let ext = url.pathExtension.lowercased()
        if (ext == "jpg" || ext == "png") {
            return true
        }
        return false
    }
    
    private func createImageData(url: URL, fileManager: FileManager) throws -> ImageModel {
        let attributes = try fileManager.attributesOfItem(atPath: url.path)
        let creationDate = attributes[FileAttributeKey.creationDate] as! NSDate
        let modificationDate = attributes[FileAttributeKey.modificationDate] as! NSDate
        return ImageModel(url, creationDate, modificationDate)
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

