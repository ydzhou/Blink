//
//  ViewController.swift
//  Blink
//
//  Created by Yudi Zhou on 6/29/19.
//  Copyright © 2019 Yudi Zhou. All rights reserved.
//

import Cocoa

class ImageViewController: NSViewController {
    private var imageManager: ImageManager?
    
    var isActualSize = false
    
    private var document: Document? {
        return view.window?.windowController?.document as? Document
    }
    
    @IBOutlet var scrollView: NSScrollView!
    
    @IBOutlet var imageView: NSImageView!
    
    @IBAction func outputViewFrame(sender: NSMenuItem) {
        print(self.imageView.frame, self.imageView.bounds)
        print(self.scrollView.frame, self.scrollView.bounds)
        print(self.scrollView.contentView.frame, self.scrollView.contentView.bounds)
    }
    
    @IBAction func next(sender: NSMenuItem) {
        imageManager!.iterateNext()
        setImageView()
    }
    
    @IBAction func prev(sender: NSMenuItem) {
        imageManager!.iteratePrev()
        setImageView()
    }
    
    @IBAction func sortByName(sender: NSMenuItem) {
        imageManager?.sortByFileName()
    }
    
    @IBAction func sortByCreationDate(sender: NSMenuItem) {
        imageManager?.sortByCreationDate()
    }
    
    @IBAction func sortByModificationDate(sender: NSMenuItem) {
        imageManager?.sortByModificationDate()
    }
    
    @IBAction func fitSizeToView(sender: NSMenuItem) {
        self.isActualSize = false
        setImageViewSize(image: self.imageView.image!)
    }
    
    @IBAction func actualSize(sender: NSMenuItem) {
        self.isActualSize = true
        setImageViewSize(image: self.imageView.image!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.autoresizingMask = [.width, .height]
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        imageManager = document?.getData()
        self.scrollView.documentView = self.imageView
        setImageView()
    }
    
    private func setImageView() {
        do {
            let (image, imageTitle) = try imageManager!.getCurrentImageData()
            setImageViewSize(image: image)
            imageView.image = image
            self.view.window?.title = imageTitle
        } catch {
            print("Failed to update image view: \(error.localizedDescription)")
        }
    }
    
    private func setImageViewSize(image: NSImage) {
        var imageViewSize: NSSize?
        let clipView = self.scrollView.contentView as! CenteredClipView
        if self.isActualSize {
            self.imageView.imageScaling = NSImageScaling.scaleNone
            imageViewSize = NSSize(width: image.size.width, height: image.size.height)
            clipView.autoresizesSubviews = false
            clipView.isForceCenter = true
        } else {
            self.imageView.imageScaling = NSImageScaling.scaleProportionallyDown
            imageViewSize = NSSize(width: scrollView.contentSize.width, height: scrollView.contentSize.height)
            clipView.autoresizesSubviews = true
        }
        imageView.setFrameSize(imageViewSize!)
        clipView.isForceCenter = false
    }
    
}

