//
//  SendbirdManager.swift
//  Test SendBird
//
//  Created by Đạt on 9/12/20.
//  Copyright © 2020 Tracker. All rights reserved.
//

import UIKit
import SendBirdSDK
import SendBirdUIKit

class SBConnectionManager{
    private init(){}
    static let shared = SBConnectionManager()
        
    func login(userName: String, nickname: String, completionHandler: ((SBDUser?, Error?) -> Void)?){
        DispatchQueue.global().async {
            SBDMain.connect(withUserId: userName, completionHandler: { (user, error) in
                guard error == nil else {   // Error.
                    return
                }
                if nickname != SBDMain.getCurrentUser()?.nickname {
                    UserDefaultHelper.saveCodableObject(CustomSBUser(id: userName, nickname: nickname, profileUrl: user?.profileUrl), key: .sb_user)
                    SBUGlobals.CurrentUser = SBUUser(userId: userName, nickname: nickname, profileUrl: user?.profileUrl)
                    SBDMain.updateCurrentUserInfo(withNickname: nickname, profileUrl: nil, completionHandler: { (error) in
                        DispatchQueue.main.async {
                            completionHandler?(user, nil)
                        }
                    })
                } else {
                    DispatchQueue.main.async {
                        completionHandler?(user, nil)
                    }
                }
            })
        }
    }
    
    func logout(completionHandler: (() -> Void)?){
        
    }
}

