//
//  AppDelegate.swift
//  Blink
//
//  Created by Zhou, Yudi on 6/27/19.
//  Copyright © 2019 Zhou, Yudi. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        let url = URL(fileURLWithPath: filename)
        print(url)
        openFileInNewWindow(sender, url)
        return true
    }
    
    @IBAction func open(_ sender: Any) {
        let url = openImageURL()
        if (url != nil) {
            openFileInNewWindow(sender, url!)
        }
    }
    
    private func openFileInNewWindow(_ sender: Any, _ url: URL) {
        var mainWindow: NSWindow? = nil
        let storyboard = NSStoryboard(name: "Main",bundle: nil)
        let viewController: MainViewController = storyboard.instantiateController(withIdentifier: "MainViewController") as! MainViewController
        mainWindow = NSWindow(contentViewController: viewController)
        mainWindow?.makeKeyAndOrderFront(self)
        let windowController = NSWindowController(window: mainWindow)
        windowController.showWindow(self)
        viewController.openImages(url: url)
        var frame = mainWindow?.frame
        frame!.size = NSMakeSize(CGFloat(1600), CGFloat(1200))
        mainWindow?.setFrame(frame!, display: true)
    }
    
    private func openImageURL() -> URL? {
        let dialog = NSOpenPanel()
        
        if (dialog.runModal() == .OK) {
            return dialog.url!
        }
        
        return nil
    }

}

