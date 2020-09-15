//
//  UIView+.swift
//  Test SendBird
//
//  Created by Đạt on 9/15/20.
//  Copyright © 2020 Tracker. All rights reserved.
//

import UIKit

extension UIView{
    // Remember set masksToBounds = true
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    var crTopLeft: Bool {
        get {
            self.layer.maskedCorners.contains(.layerMinXMinYCorner)
        }
        set {
            if newValue {
                self.layer.maskedCorners.insert(.layerMinXMinYCorner)
            } else {
                self.layer.maskedCorners.remove(.layerMinXMinYCorner)
            }
        }
    }
    
    var crTopRight: Bool {
        get {
            self.layer.maskedCorners.contains(.layerMaxXMinYCorner)
        }
        set {
            if newValue {
                self.layer.maskedCorners.insert(.layerMaxXMinYCorner)
            } else {
                self.layer.maskedCorners.remove(.layerMaxXMinYCorner)
            }
        }
    }
    
    var crBottomLeft: Bool {
        get {
            self.layer.maskedCorners.contains(.layerMinXMaxYCorner)
        }
        set {
            if newValue {
                self.layer.maskedCorners.insert(.layerMinXMaxYCorner)
            } else {
                self.layer.maskedCorners.remove(.layerMinXMaxYCorner)
            }
        }
    }
    
    var crBottomRight: Bool {
        get {
            self.layer.maskedCorners.contains(.layerMaxXMaxYCorner)
        }
        set {
            if newValue {
                self.layer.maskedCorners.insert(.layerMaxXMaxYCorner)
            } else {
                self.layer.maskedCorners.remove(.layerMaxXMaxYCorner)
            }
        }
    }
}
