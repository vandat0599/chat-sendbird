//
//  MessageCellUser.swift
//  Test SendBird
//
//  Created by Đạt on 9/14/20.
//  Copyright © 2020 Tracker. All rights reserved.
//

import UIKit

class MessageCellUser: UITableViewCell {

    var viewHolder = UIView()
    var textMessage: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(message: String){
        textMessage.text = message
    }
    
    func setupViews() {
        selectionStyle = .none
        textMessage.font = .systemFont(ofSize: 17.0)
        textMessage.numberOfLines = 0
        textMessage.textColor = .black
        viewHolder.backgroundColor = UIColor(red: 242.0/255, green: 242.0/255, blue: 242.0/255, alpha: 1.0)
        viewHolder.layer.cornerRadius = 15
        viewHolder.translatesAutoresizingMaskIntoConstraints = false
        addSubview(viewHolder)
        viewHolder.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        viewHolder.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        viewHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        viewHolder.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -50).isActive = true
        viewHolder.addSubview(textMessage)
        textMessage.translatesAutoresizingMaskIntoConstraints = false
        textMessage.topAnchor.constraint(equalTo: viewHolder.topAnchor, constant: 8).isActive = true
        textMessage.bottomAnchor.constraint(equalTo: viewHolder.bottomAnchor, constant: -8).isActive = true
        textMessage.leadingAnchor.constraint(equalTo: viewHolder.leadingAnchor, constant: 10).isActive = true
        textMessage.trailingAnchor.constraint(equalTo: viewHolder.trailingAnchor, constant: -10).isActive = true
    }

}
