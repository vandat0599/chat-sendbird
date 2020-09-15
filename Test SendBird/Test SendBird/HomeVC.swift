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

class HomeVC: UITabBarController {

    //MARK: - ui components
    

    //MARK: - data
    
    //MARK: - init

    //MARK: - app lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        setupViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

    //MARK: - others

//MARK: - setup views
extension HomeVC{
    
    func setupView(){
        view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func setupViewControllers(){
        let groupVC = SBUChannelListViewController()
        let navGroupVC = UINavigationController(rootViewController: groupVC)
        navGroupVC.navigationItem.setHidesBackButton(true, animated: true)
        navGroupVC.tabBarItem = UITabBarItem(title: "Group", image: UIImage(named: "img_tab_group_channel_normal"), selectedImage: UIImage(named: "img_tab_group_channel_selected"))
        let openChannelVC = OpenChannelVC()
        let navOpenChannelVC = UINavigationController(rootViewController: openChannelVC)
        navOpenChannelVC.tabBarItem = UITabBarItem(title: "Open", image: UIImage(named: "img_tab_open_channel_normal"), selectedImage: UIImage(named: "img_tab_open_channel_selected"))
        viewControllers = [navGroupVC, navOpenChannelVC]
    }
}


//MARK: - actions


