//
//  ChatAlert.swift
//  Test SendBird
//
//  Created by Đạt on 9/12/20.
//  Copyright © 2020 Tracker. All rights reserved.
//

import UIKit
import KRProgressHUD

class chatAlert: UIView {
    static func showBasic(title: String?,
                          message: String?,
                          viewController: UIViewController,
                          handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: handler))
        viewController.present(alert, animated: true)
    }
    
    static func showTwoActions(title: String?,
                              message: String?,
                              firstAction: String?,
                              secondAction: String?,
                              firstHandler: ((UIAlertAction) -> Void)?,
                              secondHandler: ((UIAlertAction) -> Void)?,
                              viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: firstAction, style: .default, handler: firstHandler))
        alert.addAction(UIAlertAction(title: secondAction, style: .default, handler: secondHandler))
        viewController.present(alert, animated: true)
    }
    
    static func showWithTextField(title: String?,
                                  message: String?,
                                  yesAction: String?,
                                  noAction: String?,
                                  placeholder: String?,
                                  yesHandler: ((String?) -> Void)?,
                                  noHandler: (() -> Void)?,
                                  viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message  , preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = placeholder
        }
        let yesAlertAction = UIAlertAction(title: yesAction, style: .default, handler: { alert -> Void in
            let name = (alertController.textFields?[0])?.text
            yesHandler?(name)
        })
        let noAlertAction = UIAlertAction(title: noAction, style: .default, handler: { alert -> Void in
            noHandler?()
        })
        alertController.addAction(noAlertAction)
        alertController.addAction(yesAlertAction)
        viewController.present(alertController, animated: true)
    }
}

class progressHub {
    static func show(message: String? = nil) {
        KRProgressHUD.show(withMessage: message)
    }
    
    static func hide(completion: (() -> Void)? = nil) {
        KRProgressHUD.dismiss({
            completion?()
        })
    }
}

class Utils{
    static func getKeyboardAnimationOptions(notification: Notification) -> (height: CGFloat?, duration: Double?, curve: UIView.AnimationOptions) {
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        
        let animationCurveRawNSN = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = (animationCurveRawNSN?.uintValue) ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        let keyboardFrameBegin = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height
        
        return (height: keyboardFrameBegin, duration: duration, curve: animationCurve)
    }
    
    static var screenSize: CGSize = {
        UIScreen.main.bounds.size
    }()
}

struct Constant{
    static var messageMargin:CGFloat = 20.0
}
