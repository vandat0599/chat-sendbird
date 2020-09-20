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
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.registerClass(cellType: MessageCellSend.self)
        view.registerClass(cellType: MessageCellReceive.self)
        view.registerClass(cellType: MessageCellSendImage.self)
        view.registerClass(cellType: MessageCellReceiveImage.self)
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonImageTapped))
        view.addGestureRecognizer(tapGesture)
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
    
    var imagePickerVC: UIImagePickerController = {
        let vc = UIImagePickerController()
        vc.sourceType = .savedPhotosAlbum
        vc.allowsEditing = false
        return vc
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
    let transition = PopAnimator()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
                self.addMessage(message: message!)
                self.textFieldChat.text = ""
                self.buttonSend.isEnabled = false
                self.chatTextFieldExpaned = false
            }
        }
    }
    
    private func sendImageMessage(image: UIImage){
        progressHub.show()
        SBManager.shared.sendImageMessage(openChannel, image: image) { (imageMessage, errorString) in
            progressHub.hide()
            guard let imageMessage = imageMessage else {
                chatAlert.showBasic(title: "Error!", message: "Unable to send image! Please try again!", viewController: self)
                return
            }
            self.addMessage(message: imageMessage)
            self.textFieldChat.text = ""
            self.buttonSend.isEnabled = false
            self.chatTextFieldExpaned = false
        }
    }
    
    private func addMessage(message: SBDBaseMessage){
        messageData.append(message)
        UIView.animate(withDuration: 0, animations: {
            self.messageTableView.insertRows(at: [IndexPath(row: self.messageData.count - 1, section: 0)], with: .none)
        }) { (_) in
            UIView.animate(withDuration: 0, animations: {
                self.messageTableView.reloadRows(at: [IndexPath(row: self.messageData.count - 2, section: 0)], with: .none)
            }) { (_) in
                self.scrollToBottom(animation: true)
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
        imagePickerVC.delegate = self
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
        guard
          let selectedCell = tableView.cellForRow(at: indexPath)
            as? MessageCellSendImage ?? tableView.cellForRow(at: indexPath)
            as? MessageCellReceiveImage
          else {
            return
        }
        var vc = UIViewController()
        if selectedCell is MessageCellSendImage{
            vc = ImageVC(image: ((selectedCell as! MessageCellSendImage).imageMessage.image ?? UIImage(color: .black))!)!
        }
        else {
            vc = ImageVC(image: ((selectedCell as! MessageCellReceiveImage).imageMessage.image ?? UIImage(color: .black))!)!
        }
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let message = messageData[indexPath.row]
        if message is SBDAdminMessage {
            if let adminMessage = message as? SBDAdminMessage{
                let messageCell = tableView.dequeueReusableCell(with: MessageCellReceive.self, for: indexPath)
                messageCell.configure(
                    name: "Admin",
                    profileUrl: openChannel.coverUrl ?? "",
                    message: adminMessage.message,
                    roleType: .admin,
                    sameTop: messageData.count > 1 && indexPath.row > 0 && (messageData[indexPath.row - 1].sender?.userId == adminMessage.sender?.userId),
                    sameBottom: indexPath.row < messageData.count - 1 && (messageData[indexPath.row + 1].sender?.userId == adminMessage.sender?.userId)
                )
                cell = messageCell
            }
        }
        else if message is SBDUserMessage {
            let userMessage = message as! SBDUserMessage
            if let sender = userMessage.sender {
                if sender.userId == SBDMain.getCurrentUser()!.userId {
                    let messageCell = tableView.dequeueReusableCell(with: MessageCellSend.self, for: indexPath)
                    messageCell.configure(
                        message: userMessage.message,
                        sameTop: messageData.count > 1 && indexPath.row > 0 && (messageData[indexPath.row - 1].sender?.userId == userMessage.sender?.userId),
                        sameBottom: indexPath.row < messageData.count - 1 && (messageData[indexPath.row + 1].sender?.userId == userMessage.sender?.userId)
                    )
                    cell = messageCell
                }
                else {
                    let messageCell = tableView.dequeueReusableCell(with: MessageCellReceive.self, for: indexPath)
                    messageCell.configure(
                        name: sender.nickname ?? "",
                        profileUrl: sender.profileUrl ?? "",
                        message: userMessage.message,
                        roleType: .user,
                        sameTop: messageData.count > 1 && indexPath.row > 0 && (messageData[indexPath.row - 1].sender?.userId == userMessage.sender?.userId),
                        sameBottom: indexPath.row < messageData.count - 1 && (messageData[indexPath.row + 1].sender?.userId == userMessage.sender?.userId)
                    )
                    cell = messageCell
                }
            }
        }
        else if let fileMessage = self.messageData[indexPath.row] as? SBDFileMessage {
            guard let sender = fileMessage.sender else { return cell }
            guard let currentUser = SBDMain.getCurrentUser() else { return cell }
            if sender.userId == currentUser.userId{
                let imageFileMessageCell = tableView.dequeueReusableCell(with: MessageCellSendImage.self, for: indexPath)
//                imageFileMessageCell.delegate = self
                imageFileMessageCell.configure(
                    imageURL: URL(string: fileMessage.url)!,
                    sameTop: messageData.count > 1 && indexPath.row > 0 && (messageData[indexPath.row - 1].sender?.userId == fileMessage.sender?.userId),
                    sameBottom: indexPath.row < messageData.count - 1 && (messageData[indexPath.row + 1].sender?.userId == fileMessage.sender?.userId)
                )
                cell = imageFileMessageCell
            }
            else {
                let imageFileMessageCell = tableView.dequeueReusableCell(with: MessageCellReceiveImage.self, for: indexPath)
                imageFileMessageCell.configure(
                    name: sender.nickname ?? "",
                    profileUrl: sender.profileUrl ?? "",
                    imageURL: URL(string: fileMessage.url)!,
                    roleType: .user,
                    sameTop: messageData.count > 1 && indexPath.row > 0 && (messageData[indexPath.row - 1].sender?.userId == fileMessage.sender?.userId),
                    sameBottom: indexPath.row < messageData.count - 1 && (messageData[indexPath.row + 1].sender?.userId == fileMessage.sender?.userId)
                )
                cell = imageFileMessageCell
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
                self.addMessage(message: message)
            }
        }
    }
}

extension ChatVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) { [weak self] in
            if let image = info[UIImagePickerController.InfoKey.originalImage]{
                self?.sendImageMessage(image: image as! UIImage)
            }else{
                chatAlert.showBasic(title: "Error!", message: "Unable to pick image", viewController: self!)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ChatVC: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard
          let selectedIndexPathCell = messageTableView.indexPathForSelectedRow,
          let selectedCell = messageTableView.cellForRow(at: selectedIndexPathCell)
            as? MessageCellSendImage ?? messageTableView.cellForRow(at: selectedIndexPathCell)
            as? MessageCellReceiveImage,
          let selectedCellSuperview = selectedCell.superview
          else {
            return nil
        }
        
        let screenWidth = Utils.screenSize.width
        
        transition.originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
        
        if selectedCell is MessageCellSendImage {
            let spaceTop: CGFloat = (selectedCell as? MessageCellSendImage)?.messagePosition == MessagePosition.top ? 20.0 : 0.0
            transition.originFrame = CGRect(
                x: transition.originFrame.origin.x + screenWidth*0.2 - 15,
                y: transition.originFrame.origin.y + spaceTop,
                width: screenWidth*0.8,
                height: screenWidth*0.8*9/16
            )
        } else {
            let spaceTop: CGFloat = (selectedCell as? MessageCellReceiveImage)?.messagePosition == MessagePosition.top ? 20.0 : 0.0
            transition.originFrame = CGRect(
                x: transition.originFrame.origin.x + 20 + 24,
                y: transition.originFrame.origin.y + spaceTop,
                width: screenWidth*0.8,
                height: screenWidth*0.8*9/16
            )
        }

        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
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
    
    @objc func buttonImageTapped(){
        self.present(self.imagePickerVC, animated: true, completion: nil)
    }
    
    @objc func backBarButtonTapped(){
        self.dismiss(animated: true, completion: nil)
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

