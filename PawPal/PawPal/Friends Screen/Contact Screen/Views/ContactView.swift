//
//  ContactView.swift
//  PawPal
//
//  Created by Yitian Guo on 11/30/23.
//

import UIKit

class ContactView: UIView {
    
    var profilePicButton: UIButton!
    var tableViewOptions: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupProfilePicButton()
        setupTableViewOptions()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupProfilePicButton() {
        profilePicButton = UIButton()
        profilePicButton.setBackgroundImage(UIImage(systemName: "person.crop.circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        profilePicButton.imageView?.contentMode = .scaleAspectFill
        profilePicButton.clipsToBounds = true
        profilePicButton.layer.masksToBounds = true
        // maintain a square shape
        let buttonSize: CGFloat = 100
        profilePicButton.layer.cornerRadius = buttonSize / 2
        profilePicButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profilePicButton)
    }
    
    func setupTableViewOptions() {
        tableViewOptions = UITableView()
        tableViewOptions.register(NewFriendsTableViewCell.self, forCellReuseIdentifier: Configs.tableViewNewFriendsID)
        tableViewOptions.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewOptions)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            profilePicButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 64),
            profilePicButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profilePicButton.widthAnchor.constraint(equalToConstant: 100),
            profilePicButton.heightAnchor.constraint(equalToConstant: 100),
            
            tableViewOptions.topAnchor.constraint(equalTo: self.profilePicButton.bottomAnchor, constant: 20),
            tableViewOptions.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewOptions.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewOptions.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
        self.layoutIfNeeded()
    }
    
}
