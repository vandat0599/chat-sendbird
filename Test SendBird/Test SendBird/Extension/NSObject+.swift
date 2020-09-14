//
//  NSObject+.swift
//  sshhhh
//
//  Created by Duy Nguyen on 22/3/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation

protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}
