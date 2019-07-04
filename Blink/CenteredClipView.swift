//
//  CenteredClipView.swift
//  Blink
//
//  Created by Yudi Zhou on 6/30/19.
//  Copyright © 2019 Yudi Zhou. All rights reserved.
//

import Cocoa

class CenteredClipView:NSClipView
{
    var isForceCenter = false;
    
    override func constrainBoundsRect(_ proposedBounds: NSRect) -> NSRect {
        
        var rect = super.constrainBoundsRect(proposedBounds)
        if let containerView = self.documentView {
            
            if (rect.size.width > containerView.frame.size.width || isForceCenter) {
                rect.origin.x = (containerView.frame.width - rect.width) / 2
            }
            
            if(rect.size.height > containerView.frame.size.height || isForceCenter) {
                rect.origin.y = (containerView.frame.height - rect.height) / 2
            }
        }
        
        return rect
    }
}
