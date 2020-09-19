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
    
    var imageAvatar: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var imageMessage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
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
        imageMessage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "img_placeholder"))
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
            topConstraint?.constant = Constant.messageMargin
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
        topConstraint = viewHolder.topAnchor.constraint(equalTo: topAnchor, constant: 1)
        bottomConstraint = viewHolder.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1)
        NSLayoutConstraint.activate([
            topConstraint!,
            bottomConstraint!,
            viewHolder.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Utils.screenSize.width*0.2),
            viewHolder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
        ])
        
        viewHolder.addSubview(imageMessage)
        
        NSLayoutConstraint.activate([
            imageMessage.topAnchor.constraint(equalTo: viewHolder.topAnchor, constant: 0),
            imageMessage.bottomAnchor.constraint(equalTo: viewHolder.bottomAnchor, constant: 0),
            imageMessage.leadingAnchor.constraint(equalTo: viewHolder.leadingAnchor, constant: 0),
            imageMessage.trailingAnchor.constraint(equalTo: viewHolder.trailingAnchor, constant: 0),
            imageMessage.heightAnchor.constraint(lessThanOrEqualToConstant: Utils.screenSize.width*0.8*9/18),
        ])
    }

}
