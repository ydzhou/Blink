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
    
    private var document: Document? {
        return view.window?.windowController?.document as? Document
    }
    
    @IBOutlet weak var imageView: NSImageView!
    
    @IBAction func next(sender: Any) {
        imageManager!.iterateNext()
        setImageView()
    }
    
    @IBAction func prev(sender: Any) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        imageManager = document?.getData()
        setImageView()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    private func setImageView() {
        do {
            let (image, imageTitle) = try imageManager!.getCurrentImageData()
            imageView.image = image
            self.view.window?.title = imageTitle
        } catch {
            print("Failed to update image view: \(error.localizedDescription)")
        }
    }
    
}

