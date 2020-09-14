//
//  MessageCell.swift
//  Test SendBird
//
//  Created by Đạt on 9/14/20.
//  Copyright © 2020 Tracker. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    //MARK: - ui components
    lazy var viewHolder: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var textMessage: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17.0)
        view.numberOfLines = 0
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var imageAvatar: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    //MARK: - init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(message: String){
        textMessage.text = message
    }
    
    func setupViews() {
        selectionStyle = .none
        addSubview(viewHolder)
        
        NSLayoutConstraint.activate([
            viewHolder.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            viewHolder.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            viewHolder.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 50),
            viewHolder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
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
