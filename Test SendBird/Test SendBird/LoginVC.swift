//
//  LoginVC.swift
//  Test SendBird
//
//  Created by Đạt on 9/12/20.
//  Copyright © 2020 Tracker. All rights reserved.
//

import UIKit
import SendBirdSDK

class LoginVC: UIViewController {

    //MARK: - ui components
    lazy var buttonLogin: UIButton = {
        let view = UIButton()
        view.setTitle("Login", for: .normal)
        view.backgroundColor = .systemBlue
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 17)
        view.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonCreateChannelTapped))
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var textFieldUserName: UITextField = {
       let view = UITextField()
        view.placeholder = "UserName"
        view.font = .systemFont(ofSize: 17)
        view.textColor = .black
        view.borderStyle = .roundedRect
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var textFieldNickName: UITextField = {
       let view = UITextField()
        view.placeholder = "NickName"
        view.font = .systemFont(ofSize: 17)
        view.textColor = .black
        view.borderStyle = .roundedRect
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    

    //MARK: - data
    var openChannels:[SBDBaseChannel] = []

    //MARK: - app lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        layoutButtonLogin()
        layoutLoginForm()
    }
}

    //MARK: - others

//MARK: - setup views
extension LoginVC{
    
    func setupView(){
        title = "Login"
        view.backgroundColor = .white
    }
    
    func layoutButtonLogin(){
        view.addSubview(buttonLogin)
        NSLayoutConstraint.activate([
            buttonLogin.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            buttonLogin.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            buttonLogin.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func layoutLoginForm(){
        view.addSubview(textFieldUserName)
        view.addSubview(textFieldNickName)
        NSLayoutConstraint.activate([
            textFieldUserName.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -10),
            textFieldUserName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textFieldUserName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textFieldNickName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 10),
            textFieldNickName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textFieldNickName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
}


//MARK: - actions
extension LoginVC{
    @objc func buttonCreateChannelTapped(){
        print("Login")
        progressHub.show()
        guard !(textFieldUserName.text?.isEmpty ?? true),
            !(textFieldNickName.text?.isEmpty ?? true),
            let userName = textFieldUserName.text,
            let nickName = textFieldNickName.text else{
            progressHub.hide()
            print("null")
            return
        }
        
        SBConnectionManager.shared.login(userName: userName, nickname: nickName) { (user, error) in
            guard let user = user else {
                progressHub.hide()
                chatAlert.showBasic(title: "Error!!", message: error?.localizedDescription, viewController: self)
                return
            }
            print("\(String(describing: user.nickname)) : Logged in")
            progressHub.hide()
            let vc = HomeVC()
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.present(vc, animated: true, completion: nil)
        }
    }
}

