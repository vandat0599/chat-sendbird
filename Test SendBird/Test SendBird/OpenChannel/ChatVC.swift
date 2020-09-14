//
//  ChatVC.swift
//  Test SendBird
//
//  Created by Đạt on 9/14/20.
//  Copyright © 2020 Tracker. All rights reserved.
//

import UIKit
import SendBirdSDK

class ChatVC: UIViewController {

    //MARK: - ui components
    lazy var messageTableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.registerClass(cellType: MessageCell.self)
        view.registerClass(cellType: MessageCellUser.self)
        view.registerClass(cellType: MessageCellAdmin.self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var chatSendView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var buttonSend: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
        view.setImage(UIImage(systemName: "arrowtriangle.right"), for: .disabled)
        view.isEnabled = false
        view.tintColor = .systemBlue
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonSendMessageTapped))
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var buttonMedia: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "circle.grid.2x2.fill"), for: .normal)
        view.tintColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var buttonImage: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "person.crop.square.fill"), for: .normal)
        view.tintColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var buttonFile: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "folder.fill.badge.plus"), for: .normal)
        view.tintColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var buttonExpand: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        view.tintColor = .systemBlue
        view.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonExpandChatTapped))
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var textFieldChat: UITextField = {
       let view = UITextField()
        view.placeholder = "Aa"
        view.font = .systemFont(ofSize: 17)
        view.textColor = .black
        view.borderStyle = .none
        view.layer.cornerRadius = 18
        view.backgroundColor = UIColor(red: 242.0/255, green: 242.0/255, blue: 242.0/255, alpha: 1.0)
        view.setLeftPaddingPoints(15)
        view.setRightPaddingPoints(15)
        view.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - data & state
    private let openChannel: SBDOpenChannel
    private var messageData: [SBDBaseMessage] = []
    var bottomConstaintChatBox: NSLayoutConstraint?
    var leadingConstraintMesageTextFieldCollapse: NSLayoutConstraint?
    var leadingConstraintMesageTextFieldExpanded: NSLayoutConstraint?
    var chatTextFieldExpaned = false{
        didSet{
            animateExpandChatTextField(expand: chatTextFieldExpaned)
        }
    }
    
    //MARK: - init
    init?(openChannel: SBDOpenChannel) {
        self.openChannel = openChannel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - applifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SBDMain.add(self, identifier: self.description)
        setupView()
        layoutChatSendView()
        layoutChatTableView()
        loadPreviousMessage()
        
    }
    
    //MARK: - others
    func loadPreviousMessage(){
        progressHub.show()
        SBManager.shared.loadOpenChannelMessage(self.openChannel) { (messages) in
            self.messageData = messages!
            self.messageTableView.reloadData()
            self.messageTableView.layoutIfNeeded()
            self.scrollToBottom()
            progressHub.hide()
        }
    }
    
    private func sendMessage(){
        guard !(textFieldChat.text!.isEmpty), let message = textFieldChat.text else{ return }
        SBManager.shared.sendMessage(openChannel, message: message) { (message, error) in
            if error != nil{
                chatAlert.showBasic(title: "Error!!", message: error, viewController: self)
            }else{
                self.messageData.append(message!)
                self.messageTableView.insertRows(at: [IndexPath(row: self.messageData.count - 1, section: 0)], with: .none)
                self.scrollToBottom(animation: true)
                self.textFieldChat.text = ""
                self.buttonSend.isEnabled = false
                self.chatTextFieldExpaned = false
            }
        }
    }
    
    func scrollToBottom(animation: Bool = false) {
        if self.messageData.count == 0 {
            return
        }
        self.messageTableView.scrollToRow(at: IndexPath(row: self.messageData.count - 1, section: 0), at: .bottom, animated: animation)
    }
    
    private func animateExpandChatTextField(expand: Bool){
        if expand{
            self.leadingConstraintMesageTextFieldCollapse?.isActive = false
            self.leadingConstraintMesageTextFieldExpanded?.isActive = true
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }) { (_) in
                UIView.animate(withDuration: 0.2) {
                    self.buttonExpand.isHidden = false
                    self.buttonMedia.isHidden = true
                    self.buttonImage.isHidden = true
                    self.buttonFile.isHidden = true
                }
            }
        }else{
            UIView.animate(withDuration: 0.2, animations: {
                self.buttonExpand.isHidden = true
                self.buttonMedia.isHidden = false
                self.buttonImage.isHidden = false
                self.buttonFile.isHidden = false
            }) { (_) in
                self.leadingConstraintMesageTextFieldExpanded?.isActive = false
                self.leadingConstraintMesageTextFieldCollapse?.isActive = true
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}

//MARK: - setup views
extension ChatVC{
    
    func setupView(){
        title = openChannel.name
        view.backgroundColor = .white
        navigationController?.title = "Open"
        let settingOpenChannelBarButton = UIBarButtonItem(image: UIImage(systemName: "exclamationmark.circle.fill"), style: .plain, target: self, action: #selector(self.buttonSettingOpenChannelTapped))
        self.navigationItem.rightBarButtonItem = settingOpenChannelBarButton
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    func layoutChatTableView(){
        view.addSubview(messageTableView)
        messageTableView.dataSource = self
        messageTableView.delegate = self
        NSLayoutConstraint.activate([
            messageTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            messageTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            messageTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            messageTableView.bottomAnchor.constraint(equalTo: chatSendView.topAnchor, constant: -10),
        ])
    }
    
    func layoutChatSendView(){
        view.addSubview(chatSendView)
        bottomConstaintChatBox = chatSendView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        NSLayoutConstraint.activate([
            chatSendView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            chatSendView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomConstaintChatBox!,
            chatSendView.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        chatSendView.addSubview(buttonSend)
        NSLayoutConstraint.activate([
            buttonSend.widthAnchor.constraint(equalToConstant: 44),
            buttonSend.heightAnchor.constraint(equalToConstant: 44),
            buttonSend.trailingAnchor.constraint(equalTo: chatSendView.trailingAnchor,constant: -5),
            buttonSend.centerYAnchor.constraint(equalTo: chatSendView.centerYAnchor),
        ])
        
        chatSendView.addSubview(buttonMedia)
        NSLayoutConstraint.activate([
            buttonMedia.widthAnchor.constraint(equalToConstant: 36),
            buttonMedia.heightAnchor.constraint(equalToConstant: 36),
            buttonMedia.leadingAnchor.constraint(equalTo: chatSendView.leadingAnchor, constant: 5),
            buttonMedia.centerYAnchor.constraint(equalTo: chatSendView.centerYAnchor),
        ])
        
        chatSendView.addSubview(buttonExpand)
        NSLayoutConstraint.activate([
            buttonExpand.widthAnchor.constraint(equalToConstant: 36),
            buttonExpand.heightAnchor.constraint(equalToConstant: 36),
            buttonExpand.leadingAnchor.constraint(equalTo: chatSendView.leadingAnchor, constant: 5),
            buttonExpand.centerYAnchor.constraint(equalTo: chatSendView.centerYAnchor),
        ])
        
        chatSendView.addSubview(buttonImage)
        NSLayoutConstraint.activate([
            buttonImage.widthAnchor.constraint(equalToConstant: 36),
            buttonImage.heightAnchor.constraint(equalToConstant: 36),
            buttonImage.leadingAnchor.constraint(equalTo: buttonMedia.trailingAnchor),
            buttonImage.centerYAnchor.constraint(equalTo: chatSendView.centerYAnchor),
        ])
        
        chatSendView.addSubview(buttonFile)
        NSLayoutConstraint.activate([
            buttonFile.widthAnchor.constraint(equalToConstant: 36),
            buttonFile.heightAnchor.constraint(equalToConstant: 36),
            buttonFile.leadingAnchor.constraint(equalTo: buttonImage.trailingAnchor),
            buttonFile.centerYAnchor.constraint(equalTo: chatSendView.centerYAnchor),
        ])
        
        
        chatSendView.addSubview(textFieldChat)
        textFieldChat.delegate = self
        leadingConstraintMesageTextFieldCollapse = textFieldChat.leadingAnchor.constraint(equalTo: buttonFile.trailingAnchor, constant: 10)
        leadingConstraintMesageTextFieldExpanded = textFieldChat.leadingAnchor.constraint(equalTo: buttonExpand.trailingAnchor)
        NSLayoutConstraint.activate([
            textFieldChat.heightAnchor.constraint(equalToConstant: 36),
            textFieldChat.centerYAnchor.constraint(equalTo: chatSendView.centerYAnchor),
            leadingConstraintMesageTextFieldCollapse!,
            textFieldChat.trailingAnchor.constraint(equalTo: buttonSend.leadingAnchor, constant: -5),
        ])
    }
}

//MARK: - Delegate implementations

extension ChatVC: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
        chatTextFieldExpaned = true
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        sendMessage()
        return true
    }
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let message = messageData[indexPath.row]
        if message is SBDAdminMessage {
            if let adminMessage = message as? SBDAdminMessage{
                let adminMessageCell = tableView.dequeueReusableCell(with: MessageCellAdmin.self, for: indexPath)
                adminMessageCell.configure(message: adminMessage.message)
                cell = adminMessageCell
            }
        }
        else if message is SBDUserMessage {
            let userMessage = message as! SBDUserMessage
            if let sender = userMessage.sender {
                if sender.userId == SBDMain.getCurrentUser()!.userId {
                    let userMessageCell = tableView.dequeueReusableCell(with: MessageCell.self, for: indexPath)
                    userMessageCell.configure(message: userMessage.message)
                    cell = userMessageCell
                }
                else {
                    let userMessageCell = tableView.dequeueReusableCell(with: MessageCellUser.self, for: indexPath)
                    userMessageCell.configure(message: userMessage.message)
                    cell = userMessageCell
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageData.count
    }
}

extension ChatVC: SBDChannelDelegate{
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        if sender == openChannel{
            DispatchQueue.main.async {
                print("receive: \(message)")
                self.messageData.append(message)
                self.messageTableView.insertRows(at: [IndexPath(row: self.messageData.count - 1, section: 0)], with: .none)
                self.scrollToBottom(animation: true)
            }
        }
    }
}

//MARK: - actions
extension ChatVC{
    @objc func buttonCancelTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func buttonExpandChatTapped(){
        chatTextFieldExpaned = false
    }
    @objc func buttonSettingOpenChannelTapped(){
        print("setting tapped")
    }
    
    @objc func buttonSendMessageTapped(){
        sendMessage()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let (height, duration, _) = Utils.getKeyboardAnimationOptions(notification: notification as Notification)
        UIView.animate(withDuration: duration!, animations: {
            self.bottomConstaintChatBox?.constant =  self.view.safeAreaInsets.bottom - 10 - height!
            self.view.layoutIfNeeded()
        })
        self.scrollToBottom()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.bottomConstaintChatBox?.constant = -10
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        buttonSend.isEnabled = !(textField.text!.isEmpty)
        if textField.text!.isEmpty{
            if chatTextFieldExpaned{
                chatTextFieldExpaned = false
            }
        }else{
            if !chatTextFieldExpaned{
                chatTextFieldExpaned = true
            }
        }
    }
}

//MARK: - others

