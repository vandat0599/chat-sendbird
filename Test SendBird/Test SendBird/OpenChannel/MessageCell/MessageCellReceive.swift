//
//  MessageCell.swift
//  Test SendBird
//
//  Created by Đạt on 9/14/20.
//  Copyright © 2020 Tracker. All rights reserved.
//

import UIKit
import SDWebImage

class MessageCellReceive: UITableViewCell {

    //MARK: - ui components
    lazy var viewHolder: UIView = {
        let view = UIView()
        view.backgroundColor = .greyMessage
        view.layer.cornerRadius = 15
        view.crTopRight = true
        view.crBottomRight = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var textMessage: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17.0)
        view.numberOfLines = 0
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var imageAvatar: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12.0
        view.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var textName: UILabel = {
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

    func configure(name: String, profileUrl: String, message: String, roleType: MessageReceiveRole, sameTop: Bool, sameBottom: Bool){
        switch roleType {
        case .user:
            viewHolder.backgroundColor = .greyMessage
            textMessage.textColor = .black
        case .admin:
            viewHolder.backgroundColor = .systemRed
            textMessage.textColor = .white
        }
        imageAvatar.sd_setImage(with: URL(string: profileUrl), placeholderImage: UIImage(named: "img_profile_1"))
        textName.text = name
        textMessage.text = message
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
            topConstraint?.constant = Constant.messageMargin
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
            topConstraint?.constant = Constant.messageMargin
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
        NSLayoutConstraint.activate([
            imageAvatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            imageAvatar.bottomAnchor.constraint(equalTo: viewHolder.bottomAnchor, constant: 0),
            imageAvatar.heightAnchor.constraint(equalToConstant: 24.0),
            imageAvatar.widthAnchor.constraint(equalToConstant: 24.0),
        ])
        
        topConstraint = viewHolder.topAnchor.constraint(equalTo: topAnchor, constant: 5)
        bottomConstraint = viewHolder.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        NSLayoutConstraint.activate([
            topConstraint!,
            bottomConstraint!,
            viewHolder.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -50),
            viewHolder.leadingAnchor.constraint(equalTo: imageAvatar.trailingAnchor, constant: 10),
        ])
        
        viewHolder.addSubview(textMessage)
        NSLayoutConstraint.activate([
            textMessage.topAnchor.constraint(equalTo: viewHolder.topAnchor, constant: 8),
            textMessage.bottomAnchor.constraint(equalTo: viewHolder.bottomAnchor, constant: -8),
            textMessage.leadingAnchor.constraint(equalTo: viewHolder.leadingAnchor, constant: 10),
            textMessage.trailingAnchor.constraint(equalTo: viewHolder.trailingAnchor, constant: -10),
        ])
        
        addSubview(textName)
        NSLayoutConstraint.activate([
            textName.leadingAnchor.constraint(equalTo: viewHolder.leadingAnchor, constant: 12),
            textName.bottomAnchor.constraint(equalTo: viewHolder.topAnchor),
            textName.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -50),
        ])
    }

}
