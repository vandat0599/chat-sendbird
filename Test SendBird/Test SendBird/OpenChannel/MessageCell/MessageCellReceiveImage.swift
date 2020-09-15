//
//  MessageCell.swift
//  Test SendBird
//
//  Created by Đạt on 9/14/20.
//  Copyright © 2020 Tracker. All rights reserved.
//

import UIKit

class MessageCellReceiveImage: UITableViewCell {

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

    func configure(message: String, roleType: MessageReceiveRole, sameTop: Bool, sameBottom: Bool){
        switch roleType {
        case .user:
            viewHolder.backgroundColor = .greyMessage
            textMessage.textColor = .black
        case .admin:
            viewHolder.backgroundColor = .systemRed
            textMessage.textColor = .white
        }
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
    }
    
    func setupViews() {
        selectionStyle = .none
        addSubview(viewHolder)
        topConstraint = viewHolder.topAnchor.constraint(equalTo: topAnchor, constant: 5)
        bottomConstraint = viewHolder.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        NSLayoutConstraint.activate([
            topConstraint!,
            bottomConstraint!,
            viewHolder.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -50),
            viewHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
        ])
        
        viewHolder.addSubview(textMessage)
        
        NSLayoutConstraint.activate([
            textMessage.topAnchor.constraint(equalTo: viewHolder.topAnchor, constant: 8),
            textMessage.bottomAnchor.constraint(equalTo: viewHolder.bottomAnchor, constant: -8),
            textMessage.leadingAnchor.constraint(equalTo: viewHolder.leadingAnchor, constant: 10),
            textMessage.trailingAnchor.constraint(equalTo: viewHolder.trailingAnchor, constant: -10),
        ])
        
    }

}
