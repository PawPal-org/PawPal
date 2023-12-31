//
//  NewFriendsView.swift
//  PawPal
//
//  Created by Yitian Guo on 11/30/23.
//

import UIKit

class NewFriendsView: UIView {

    var backgroundView: UIView!
    var tableViewNewFriends: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupBackgroundView()
        setupTableViewNewFriends()
        initConstraints()
    }
    
    func setupBackgroundView() {
        backgroundView = UIView()
        backgroundView.backgroundColor = backgroundColorBeige
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backgroundView)
        self.sendSubviewToBack(backgroundView)
    }
    
    func setupTableViewNewFriends(){
        tableViewNewFriends = UITableView()
        tableViewNewFriends.register(NewFriendsTableViewCell.self, forCellReuseIdentifier: Configs.tableViewNewFriendsID)
        tableViewNewFriends.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewNewFriends)
    }
    
    //MARK: setting up constraints...
    func initConstraints(){
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: tableViewNewFriends.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            tableViewNewFriends.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableViewNewFriends.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewNewFriends.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewNewFriends.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
