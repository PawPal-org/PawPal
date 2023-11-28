//
//  MyMomentsView.swift
//  PawPal
//
//  Created by Yitian Guo on 11/22/23.
//

import UIKit

class MyMomentsView: UIView {

    var backgroundView: UIView!
    var profilePicButton: UIButton!
    var labelText: UILabel!
    var tableViewMoments: UITableView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupBackgroundView()
        setupProfilePic()
        setupLabelText()
        setupTableViewMoments()
        initConstraints()
    }
    
    //MARK: initializing the UI elements...
    func setupBackgroundView() {
        backgroundView = UIView()
        backgroundView.backgroundColor = backgroundColorBeige
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backgroundView)
        self.sendSubviewToBack(backgroundView)
    }
    
    func setupProfilePic(){
        profilePicButton = UIButton()
        profilePicButton.setBackgroundImage(UIImage(systemName: "person.crop.circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        profilePicButton.imageView?.contentMode = .scaleAspectFill
        profilePicButton.clipsToBounds = true
        // profilePicButton.layer.masksToBounds = true
        // maintain a square shape
        let buttonSize: CGFloat = 50
        profilePicButton.layer.cornerRadius = buttonSize / 2
        profilePicButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profilePicButton)
    }
    
    func setupLabelText(){
        labelText = UILabel()
        labelText.font = UIFont(name: titleFont, size: 20)
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
            
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: tableViewMoments.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            profilePicButton.widthAnchor.constraint(equalToConstant: 50),
            profilePicButton.heightAnchor.constraint(equalToConstant: 50),
            profilePicButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: -12),
            profilePicButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -13),
            
            labelText.topAnchor.constraint(equalTo: profilePicButton.topAnchor),
            labelText.bottomAnchor.constraint(equalTo: profilePicButton.bottomAnchor),
            labelText.trailingAnchor.constraint(equalTo: profilePicButton.leadingAnchor, constant: -8),
            
            tableViewMoments.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 48),
            tableViewMoments.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewMoments.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            tableViewMoments.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
