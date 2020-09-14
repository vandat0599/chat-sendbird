//
//  ViewController.swift
//  Test SendBird
//
//  Created by Đạt on 9/12/20.
//  Copyright © 2020 Tracker. All rights reserved.
//

import UIKit
import SendBirdSDK

class GroupVC: UIViewController {

    //MARK: - ui components
    
    lazy var channelTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    //MARK: - data
    var groups:[SBDBaseChannel] = []

    //MARK: - app lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        layoutChannelTableView()
    }
}

    //MARK: - others

//MARK: - setup views
extension GroupVC{
    
    func setupView(){
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        self.title = "Groups"
        self.navigationController?.title = "Group"
    }
    
    func layoutChannelTableView(){
        view.addSubview(channelTableView)
        channelTableView.dataSource = self
        channelTableView.delegate = self
        channelTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        channelTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        channelTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        channelTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension GroupVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped: \(groups[indexPath.row])")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = groups[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
}

//MARK: - actions


