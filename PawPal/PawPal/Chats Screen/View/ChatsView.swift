//
//  ChatsView.swift
//  PawPal
//
//  Created by Yitian Guo on 11/19/23.
//

import UIKit

class ChatsView: UIView{

    var searchBar: UISearchBar!
    var tableViewChats: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupSearchBar()
        setupTableViewChats()
        initConstraints()
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search Chats"
        searchBar.sizeToFit()
        searchBar.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func setupTableViewChats(){
        tableViewChats = UITableView()
        tableViewChats.register(ChatsTableViewCell.self, forCellReuseIdentifier: Configs.tableViewChatsID)
        tableViewChats.tableHeaderView = searchBar
        tableViewChats.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewChats)
    }
    
    //MARK: setting up constraints...
    func initConstraints(){
        NSLayoutConstraint.activate([
            tableViewChats.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableViewChats.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewChats.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewChats.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
