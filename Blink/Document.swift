//
//  Document.swift
//  Blink
//
//  Created by Yudi Zhou on 6/29/19.
//  Copyright © 2019 Yudi Zhou. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    
    private var imageManager: ImageManager?
    
    private var viewController: ImageViewController? {
        return self.windowControllers.first?.contentViewController as? ImageViewController
    }
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class var autosavesInPlace: Bool {
        return false
    }

    override func makeWindowControllers() {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
        self.addWindowController(windowController)
    }
    
    override func read(from url: URL, ofType typeName: String) throws {
        imageManager = ImageManager(url: url)
    }

    func getData() -> ImageManager {
        return imageManager!
    }
    
    private func setInitialWindowSize(windowController: NSWindowController) {
        var frame = windowController.window?.frame
        frame?.size = getResizedScreenBound(scaleFactor: CGFloat(0.75), ratioFactor: CGFloat(1.5))
        windowController.window?.setFrame(frame!, display: true)
    }
    
    private func getResizedScreenBound(scaleFactor: CGFloat, ratioFactor: CGFloat) -> NSSize {
        let rect = NSScreen.main!.frame
        return NSSize(width: rect.size.height * scaleFactor * ratioFactor, height: rect.size.height * scaleFactor)
    }

}

