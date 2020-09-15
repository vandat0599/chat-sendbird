//
//  ViewController.swift
//  Test SendBird
//
//  Created by Đạt on 9/12/20.
//  Copyright © 2020 Tracker. All rights reserved.
//

import UIKit
import SendBirdSDK
import SendBirdUIKit

class OpenChannelVC: UIViewController {

    //MARK: - ui components
    lazy var channelTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    //MARK: - data
    var openChannels:[SBDOpenChannel] = []

    //MARK: - app lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //ui
        setupView()
        layoutChannelTableView()
        
        //data
        loadOpenChannels()
    }
    
    //MARK: - others
    func loadOpenChannels(){
        progressHub.show()
        SBManager.shared.loadOpenChannels { (openChannels, errorString) in
            guard errorString == nil else {
                progressHub.hide()
                chatAlert.showBasic(title: "Error!", message: "Something went wrong!! Please try again!", viewController: self)
                return
            }
            self.openChannels = openChannels
            self.channelTableView.reloadData()
            progressHub.hide()
        }
    }
}

    //MARK: - others

//MARK: - setup views
extension OpenChannelVC{
    
    func setupView(){
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        self.title = "Open Channels"
        self.navigationController?.title = "Open"
        self.navigationItem.largeTitleDisplayMode = .automatic
        let createChannelBarButton = UIBarButtonItem(image: UIImage(named: "img_btn_create_public_group_channel_blue"), style: .plain, target: self, action: #selector(self.buttonCreateChannelTapped))
        self.navigationItem.rightBarButtonItem = createChannelBarButton
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshChannelList), for: .valueChanged)
        self.channelTableView.refreshControl = refreshControl
    }
    
    func layoutChannelTableView(){
        view.addSubview(channelTableView)
        channelTableView.dataSource = self
        channelTableView.delegate = self
        NSLayoutConstraint.activate([
            channelTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            channelTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            channelTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            channelTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension OpenChannelVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SBManager.shared.enterToChannel(openChannels[indexPath.row]){ (errorString) in
            guard errorString == nil else {
                chatAlert.showBasic(title: "Error!", message: errorString, viewController: self)
                return
            }
            let chatVC = ChatVC(openChannel: self.openChannels[indexPath.row])
            self.parent?.navigationController?.pushViewController(chatVC!, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = openChannels[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openChannels.count
    }
}

//MARK: - actions
extension OpenChannelVC{
    @objc func buttonCreateChannelTapped(){
        chatAlert.showWithTextField(title: "Create Open Channel", message: nil, yesAction: "Create", noAction: "Cancel", placeholder: "Enter Channel Name", yesHandler: { (text) in
            if text == nil || text!.isEmpty{
                chatAlert.showBasic(title: "Error!", message: "Channel Name Can't not be empty!!", viewController: self)
                return
            }
            progressHub.show()
            SBManager.shared.createOpenChannel(name: text) { (openChannel, error) in
                guard let openChannel = openChannel else {
                    progressHub.hide()
                    chatAlert.showBasic(title: "Error!", message: error, viewController: self)
                    return
                }
                self.openChannels.append(openChannel)
                self.channelTableView.reloadData()
                progressHub.hide()
                
            }
        }, noHandler: nil, viewController: self)
    }
    
    @objc func refreshChannelList() {
        SBManager.shared.loadOpenChannels { (openChannels, errorString) in
            guard errorString == nil else {
                self.channelTableView.refreshControl?.endRefreshing()
                chatAlert.showBasic(title: "Error!", message: "Something went wrong!! Please try again!", viewController: self)
                return
            }
            self.openChannels = openChannels
            self.channelTableView.reloadData()
            self.channelTableView.refreshControl?.endRefreshing()
        }
    }
}

