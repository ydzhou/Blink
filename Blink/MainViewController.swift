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
    
    private var images: [URL]!
    private var imageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openImages()
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func keyDown(with event: NSEvent) {
        if (event.keyCode == 123) {
            previousImage()
        }
        else if (event.keyCode == 124) {
            nextImage()
        } else {
            super.keyDown(with: event)
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
        let image = NSImage(contentsOf: images[index])
        if (image == nil) {
            print("Failed to retrieve image")
            return
        }
        imageView.image = image
    }
    
    private func loadAllImagesUnderCurrentDirectory(url: URL) {
        images = [URL]()
        
        let fileManager:  FileManager = FileManager()
        do {
            print(url.deletingLastPathComponent())
            let items = try fileManager.contentsOfDirectory(at: url.deletingLastPathComponent(), includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for item in items {
                let ext = item.pathExtension.lowercased()
                if (ext == "jpg" || ext == "png") {
                    images.append(item)
                }
                if (item == url) {
                    imageIndex = images.count - 1
                }
            }
            
        } catch {
            print("Error while enumerating files: \(error.localizedDescription)")
        }
    }


}

