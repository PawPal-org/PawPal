//
//  MomentsView.swift
//  PawPal
//
//  Created by Yitian Guo on 11/19/23.
//

import UIKit

class MomentsView: UIView {
    var profilePicButton: UIButton!
    var labelText: UILabel!
    var tableViewMoments: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupProfilePic()
        setupLabelText()
        setupTableViewMoments()
        initConstraints()
    }
    
    //MARK: initializing the UI elements...
    func setupProfilePic(){
        profilePicButton = UIButton()
        profilePicButton.setImage(UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        profilePicButton.imageView?.contentMode = .scaleAspectFill
        profilePicButton.contentMode = .scaleToFill
        profilePicButton.clipsToBounds = true
        profilePicButton.layer.masksToBounds = true
        profilePicButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profilePicButton)
    }
    
    func setupLabelText(){
        labelText = UILabel()
        labelText.font = .boldSystemFont(ofSize: 14)
        labelText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelText)
    }
    
    func setupTableViewMoments(){
        tableViewMoments = UITableView()
        tableViewMoments.register(MomentsTableViewCell.self, forCellReuseIdentifier: Configs.tableViewMomentsID)
        tableViewMoments.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewMoments)
    }
    
    //MARK: setting up constraints...
    func initConstraints(){
        NSLayoutConstraint.activate([
            profilePicButton.widthAnchor.constraint(equalToConstant: 32),
            profilePicButton.heightAnchor.constraint(equalToConstant: 32),
            profilePicButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            profilePicButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            labelText.topAnchor.constraint(equalTo: profilePicButton.topAnchor),
            labelText.bottomAnchor.constraint(equalTo: profilePicButton.bottomAnchor),
            labelText.leadingAnchor.constraint(equalTo: profilePicButton.trailingAnchor, constant: 8),
            
            tableViewMoments.topAnchor.constraint(equalTo: profilePicButton.bottomAnchor, constant: 8),
            tableViewMoments.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewMoments.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewMoments.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
