//
//  MessageCell.swift
//  Test SendBird
//
//  Created by Đạt on 9/14/20.
//  Copyright © 2020 Tracker. All rights reserved.
//

import UIKit

class MessageCellSendImage: UITableViewCell {

    //MARK: - ui components
    lazy var viewHolder: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.crTopLeft = true
        view.crBottomLeft = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageAvatar: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageMessage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - data & state
    var messagePosition = MessagePosition.top
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

    func configure(imageURL: URL, sameTop: Bool, sameBottom: Bool){
        imageMessage.sd_imageTransition = .fade
        imageMessage.sd_setImage(with: imageURL, placeholderImage: UIImage(color: .greyMessage))
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
            topConstraint?.constant = 20.0
            viewHolder.crTopRight = true
            viewHolder.crBottomRight = false
        case .mid:
            topConstraint?.constant = 1
            bottomConstraint?.constant = -1
            viewHolder.crTopRight = false
            viewHolder.crBottomRight = false
        case .bottom:
            topConstraint?.constant = 1
            viewHolder.crTopRight = false
            viewHolder.crBottomRight = true
        case .alone:
            topConstraint?.constant = 20.0
            viewHolder.crTopRight = true
            viewHolder.crBottomRight = true
        }
        UIView.animate(withDuration: 0) {
            self.layoutIfNeeded()
        }
    }
    
    func setupViews() {
        selectionStyle = .none
        addSubview(viewHolder)
        viewHolder.addSubview(imageMessage)
        topConstraint = viewHolder.topAnchor.constraint(equalTo: topAnchor, constant: 1)
        bottomConstraint = viewHolder.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1)
        NSLayoutConstraint.activate([
            topConstraint!,
            bottomConstraint!,
            viewHolder.leadingAnchor.constraint(equalTo: imageMessage.leadingAnchor, constant: 0),
            viewHolder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
        ])
        
        
        NSLayoutConstraint.activate([
            imageMessage.topAnchor.constraint(equalTo: viewHolder.topAnchor, constant: 0),
            imageMessage.bottomAnchor.constraint(equalTo: viewHolder.bottomAnchor, constant: 0),
            imageMessage.trailingAnchor.constraint(equalTo: viewHolder.trailingAnchor, constant: 0),
            imageMessage.widthAnchor.constraint(equalToConstant: Utils.screenSize.width*0.8),
            imageMessage.heightAnchor.constraint(equalToConstant: Utils.screenSize.width*0.8*9/16),
        ])
    }
}
