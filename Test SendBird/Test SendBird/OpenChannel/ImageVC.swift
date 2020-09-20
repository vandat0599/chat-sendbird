//
//  ImageVC.swift
//  Test SendBird
//
//  Created by Đạt on 9/19/20.
//  Copyright © 2020 Tracker. All rights reserved.
//

import UIKit

class ImageVC: UIViewController {
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(color: .greyMessage)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var buttonClose: UIButton = {
        let view = UIButton()
        view.setTitle("", for: .normal)
        view.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        view.tintColor = .systemBlue
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonCloseTapped))
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        return view
    }()
    
    var image: UIImage?

    //MARK: - init
   init?(image: UIImage) {
       self.image = image
       super.init(nibName: nil, bundle: nil)
   }

   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(buttonClose)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            
            buttonClose.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8.0),
            buttonClose.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0.0),
        ])
        imageView.image = image
    }
    
    
    @objc func buttonCloseTapped(){
        self.dismiss(animated: true, completion: nil)
    }

}
