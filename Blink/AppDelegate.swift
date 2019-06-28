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
    
    @IBAction func open(_ sender: AnyObject) {
        var myWindow: NSWindow? = nil
        let storyboard = NSStoryboard(name: "Main",bundle: nil)
        let controller: MainViewController = storyboard.instantiateController(withIdentifier: "MainViewController") as! MainViewController
        myWindow = NSWindow(contentViewController: controller)
        myWindow?.makeKeyAndOrderFront(self)
        let vc = NSWindowController(window: myWindow)
        vc.showWindow(self)
    }

}

