//
//  MessagePosition.swift
//  Test SendBird
//
//  Created by Đạt on 9/15/20.
//  Copyright © 2020 Tracker. All rights reserved.
//

import Foundation

enum MessagePosition {
    case top, bottom, mid, alone
}

enum MessageReceiveRole{
    case user, admin
}

enum MessageReceiveType{
    case text, image, file, url
}

class MessageConstant{
    static var heroImageId = "messageImage"
}
