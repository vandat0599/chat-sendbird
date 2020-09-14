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

class SBManager{
    private init(){}
    static let shared = SBManager()
    
    func loadOpenChannels(completionHandler: (([SBDOpenChannel], String?) -> Void)?){
        DispatchQueue.global().async {
            guard let query = SBDOpenChannel.createOpenChannelListQuery() else {
                DispatchQueue.main.async {
                    completionHandler?([], "Query nil")
                }
                return
            }
            query.loadNextPage(completionHandler: { (openChannels, error) in
                guard error == nil else {   // Error.
                    return
                }
                DispatchQueue.main.async {
                    completionHandler?(openChannels ?? [], nil)
                }
            })
        }
    }
    
    func createOpenChannel(name: String?, completionHandler: ((SBDOpenChannel?, String?) -> Void)?){
        guard let name = name else {
            DispatchQueue.main.async {
                completionHandler?(nil, "Name nil")
            }
            return
        }
        DispatchQueue.global().async {
            SBDOpenChannel.createChannel(withName: name, channelUrl: nil, coverImage: (UIImage(named: "img_default_cover_image_3")?.pngData())!, coverImageName: "", data: nil, operatorUserIds: nil, customType: nil, progressHandler: nil) { (openChannel, error) in
                guard error == nil else {   // Error.
                    DispatchQueue.main.async {
                        completionHandler?(nil, error?.localizedDescription)
                    }
                    return
                }
                DispatchQueue.main.async {
                    completionHandler?(openChannel, nil)
                }
                
            }
        }
    }
    
    func enterToChannel(_ openChannel: SBDOpenChannel, completionHandler: ((String?) -> Void)?){
        DispatchQueue.global().async {
            openChannel.enter { (error) in
                guard error == nil else {
                    DispatchQueue.main.async {
                        completionHandler?("error: \(String(describing: error?.localizedDescription))")
                    }
                    return
                }
                DispatchQueue.main.async {
                    completionHandler?(nil)
                }
            }
        }
    }
    
    func loadOpenChannelMessage(_ openChannel: SBDOpenChannel, completionHandler: (([SBDBaseMessage]?) -> Void)?){
        DispatchQueue.global().async {
            let previousMessageQuery = openChannel.createPreviousMessageListQuery()
            previousMessageQuery?.loadPreviousMessages(withLimit: 30, reverse: false, completionHandler: { (messages, error) in
                guard error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    completionHandler?(messages)
                }
            })
        }
    }
    
    func sendMessage(_ openChannel: SBDOpenChannel, message: String?, completionHandler: ((SBDUserMessage?, String?) -> Void)?){
        DispatchQueue.global().async {
            guard let message = message else{
                DispatchQueue.main.async {
                    completionHandler?(nil, "Error to read message string")
                }
                return
            }
            let params = SBDUserMessageParams(message: message)
            params!.pushNotificationDeliveryOption = .default

            openChannel.sendUserMessage(with: params!, completionHandler: { (userMessage, error) in
                guard error == nil else {   // Error.
                    DispatchQueue.main.async {
                        completionHandler?(nil, "Something went wrong! Please try again")
                    }
                    return
                }
                DispatchQueue.main.async {
                    completionHandler?(userMessage, nil)
                }
            })
        }
    }
}

