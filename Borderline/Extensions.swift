//
//  Extensions.swift
//  Borderline
//
//  Created by James Dassoulas on 2016-11-16.
//  Copyright © 2016 Jetliner. All rights reserved.
//

import Foundation
import UIKit
extension UIButton {
    /**
     Creates an edge inset for a button
     :param: top CGFLoat
     :param: left CGFLoat
     :param: bottom CGFLoat
     :param: right CGFLoat
     */
    func setInset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        self.titleEdgeInsets =  UIEdgeInsetsMake(top, left, bottom, right)
    }
}

extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSLinkAttributeName, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
