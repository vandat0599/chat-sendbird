//
//  MessageCell.swift
//  Test SendBird
//
//  Created by Đạt on 9/14/20.
//  Copyright © 2020 Tracker. All rights reserved.
//

import UIKit
import SDWebImage

class MessageCellReceiveImage: UITableViewCell {

    //MARK: - ui components
    lazy var viewHolder: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.crTopRight = true
        view.crBottomRight = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageMessage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageAvatar: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12.0
        view.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var textName: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.textColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - data & state
    var messagePosition = MessagePosition.top
    var messageReceiveRole = MessageReceiveRole.user
    var topConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    
    //MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(name: String, profileUrl: String, imageURL: URL, roleType: MessageReceiveRole, sameTop: Bool, sameBottom: Bool){
        imageMessage.sd_imageTransition = .fade
        imageAvatar.sd_imageTransition = .fade
        imageMessage.sd_setImage(with: imageURL, placeholderImage: UIImage(color: .greyMessage))
        imageAvatar.sd_setImage(with: URL(string: profileUrl), placeholderImage: UIImage(named: "img_profile_1"))
        textName.text = name
        if sameTop && sameBottom{
            messagePosition = .mid
        }else if !sameTop && !sameBottom{
            messagePosition = .alone
        }else if sameTop && !sameBottom{
            messagePosition = .bottom
        }else if !sameTop && sameBottom{
            messagePosition = .top
        }
        textName.isHidden = !(messagePosition == .top || messagePosition == .alone)
        switch messagePosition {
        case .top:
            bottomConstraint?.constant = -1
            topConstraint?.constant = 20.0
            viewHolder.crTopLeft = true
            viewHolder.crBottomLeft = false
        case .mid:
            topConstraint?.constant = 1
            bottomConstraint?.constant = -1
            viewHolder.crTopLeft = false
            viewHolder.crBottomLeft = false
        case .bottom:
            topConstraint?.constant = 1
            viewHolder.crTopLeft = false
            viewHolder.crBottomLeft = true
        case .alone:
            topConstraint?.constant = 20.0
            viewHolder.crTopLeft = true
            viewHolder.crBottomLeft = true
        }
        UIView.animate(withDuration: 0) {
            self.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0, animations: {
            self.layoutIfNeeded()
        }) { (_) in
            if self.messagePosition == .bottom || self.messagePosition == .alone{
                UIView.animate(withDuration: 0.5) {
                    self.imageAvatar.alpha = 1.0
                }
            }else{
                UIView.animate(withDuration: 0.5) {
                    self.imageAvatar.alpha = 0.0
                }
           }
        }
    }
    
    func setupViews() {
        selectionStyle = .none
        addSubview(imageAvatar)
        addSubview(viewHolder)
        viewHolder.addSubview(imageMessage)
        NSLayoutConstraint.activate([
            imageAvatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            imageAvatar.bottomAnchor.constraint(equalTo: viewHolder.bottomAnchor, constant: 0),
            imageAvatar.heightAnchor.constraint(equalToConstant: 24.0),
            imageAvatar.widthAnchor.constraint(equalToConstant: 24.0),
        ])
        
        topConstraint = viewHolder.topAnchor.constraint(equalTo: topAnchor, constant: 1)
        bottomConstraint = viewHolder.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1)
        NSLayoutConstraint.activate([
            topConstraint!,
            bottomConstraint!,
            viewHolder.trailingAnchor.constraint(lessThanOrEqualTo: imageMessage.trailingAnchor, constant: 0),
            viewHolder.leadingAnchor.constraint(equalTo: imageAvatar.trailingAnchor, constant: 10),
        ])
        
        
        NSLayoutConstraint.activate([
            imageMessage.topAnchor.constraint(equalTo: viewHolder.topAnchor, constant: 0),
            imageMessage.bottomAnchor.constraint(equalTo: viewHolder.bottomAnchor, constant: 0),
            imageMessage.leadingAnchor.constraint(equalTo: viewHolder.leadingAnchor, constant: 0),
            imageMessage.widthAnchor.constraint(equalToConstant: Utils.screenSize.width*0.8),
            imageMessage.heightAnchor.constraint(equalToConstant: Utils.screenSize.width*0.8*9/16),
        ])
        
        addSubview(textName)
        NSLayoutConstraint.activate([
            textName.leadingAnchor.constraint(equalTo: viewHolder.leadingAnchor, constant: 12),
            textName.bottomAnchor.constraint(equalTo: viewHolder.topAnchor),
            textName.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Utils.screenSize.width*0.2),
        ])
    }

}
