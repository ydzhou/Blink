//
//  ImageData.swift
//  Blink
//
//  Created by Yudi Zhou on 6/29/19.
//  Copyright © 2019 Yudi Zhou. All rights reserved.
//

import Cocoa

class ImageData {

    var url: URL
    var creationDate: NSDate
    var modificationDate: NSDate
    var fileName: String
    
    init(_ url: URL, _ creationDate: NSDate, _ modificationDate: NSDate) {
        self.url = url
        self.fileName = url.lastPathComponent
        self.creationDate = creationDate
        self.modificationDate = modificationDate
    }

}
