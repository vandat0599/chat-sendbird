//
//  AppDelegate.swift
//  Test SendBird
//
//  Created by Đạt on 9/12/20.
//  Copyright © 2020 Tracker. All rights reserved.
//

import UIKit
import SendBirdSDK
import SendBirdUIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SBDMain.initWithApplicationId("BEF7BFDB-6D0C-4DC4-AA22-EF9F6DC5215F")
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = getViewControllerFromAccount()
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func getViewControllerFromAccount() -> UIViewController{
        let user:CustomSBUser? = UserDefaultHelper.getCodableObject(key: .sb_user)
        if user != nil{
            SBUGlobals.CurrentUser = SBUUser(userId: (user?.id!)!, nickname: user?.nickname!, profileUrl: user?.profileUrl!)
            SBDMain.updateCurrentUserInfo(withNickname: user?.nickname, profileUrl: user?.profileUrl, completionHandler: nil)
            return HomeVC()
        }
        return LoginVC()
        
    }
}

