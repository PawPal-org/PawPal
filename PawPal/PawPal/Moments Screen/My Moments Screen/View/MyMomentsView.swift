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
    
    var labelMomentsCount: UILabel!
    var labelMomentsCountText: UILabel!
    
    var labelLikesCount: UILabel!
    var labelLikesCountText: UILabel!
    
    var labelPetsCount: UILabel!
    var labelPetsCountText: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupBackgroundView()
        setupProfilePic()
        setupLabelText()
        setupTableViewMoments()
        setupLabelMomentsCount()
        setupLabelLikesCount()
        setupLabelPetsCount()
        setupLabelMomentsCountText()
        setupLabelLikesCountText()
        setupLabelPetsCountText()
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
        labelText.font = UIFont(name: titleFont, size: 14)
        labelText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelText)
    }
    
    func setupTableViewMoments(){
        tableViewMoments = UITableView()
        tableViewMoments.register(MomentsTableViewCell.self, forCellReuseIdentifier: Configs.tableViewMomentsID)
        tableViewMoments.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewMoments)
    }
    
    func setupLabelMomentsCount(){
        labelMomentsCount = UILabel()
        labelMomentsCount.font = UIFont(name: titleFont, size: 12)
        labelMomentsCount.text = "Posts"
        labelMomentsCount.textColor = .darkGray
        labelMomentsCount.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelMomentsCount)
    }
    
    func setupLabelLikesCount(){
        labelLikesCount = UILabel()
        labelLikesCount.font = UIFont(name: titleFont, size: 12)
        labelLikesCount.text = "Likes"
        labelLikesCount.textColor = .darkGray
        labelLikesCount.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelLikesCount)
    }
    
    func setupLabelPetsCount(){
        labelPetsCount = UILabel()
        labelPetsCount.font = UIFont(name: titleFont, size: 12)
        labelPetsCount.text = "Pets"
        labelPetsCount.textColor = .darkGray
        labelPetsCount.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelPetsCount)
    }
    
    func setupLabelMomentsCountText(){
        labelMomentsCountText = UILabel()
        labelMomentsCountText.font = UIFont(name: titleFont, size: 12)
        labelMomentsCountText.text = "..."
        labelMomentsCountText.textColor = .darkGray
        labelMomentsCountText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelMomentsCountText)
        
    }
    func setupLabelLikesCountText(){
        labelLikesCountText = UILabel()
        labelLikesCountText.font = UIFont(name: titleFont, size: 12)
        labelLikesCountText.text = "..."
        labelLikesCountText.textColor = .darkGray
        labelLikesCountText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelLikesCountText)
        
    }
    func setupLabelPetsCountText(){
        labelPetsCountText = UILabel()
        labelPetsCountText.font = UIFont(name: titleFont, size: 12)
        labelPetsCountText.text = "..."
        labelPetsCountText.textColor = .darkGray
        labelPetsCountText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelPetsCountText)
        
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
            profilePicButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: -10),
            profilePicButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -13),
            
            labelText.bottomAnchor.constraint(equalTo: profilePicButton.bottomAnchor),
            labelText.trailingAnchor.constraint(equalTo: profilePicButton.leadingAnchor, constant: -2),
            
            labelMomentsCount.topAnchor.constraint(equalTo: profilePicButton.topAnchor, constant: 20),
            labelMomentsCount.trailingAnchor.constraint(equalTo: labelLikesCount.leadingAnchor, constant: -32),
            
            labelLikesCount.topAnchor.constraint(equalTo: profilePicButton.topAnchor, constant: 20),
            labelLikesCount.trailingAnchor.constraint(equalTo: labelPetsCount.leadingAnchor, constant: -32),
            
            labelPetsCount.topAnchor.constraint(equalTo: profilePicButton.topAnchor, constant: 20),
            labelPetsCount.trailingAnchor.constraint(equalTo: profilePicButton.leadingAnchor, constant: -68),
            
            labelMomentsCountText.bottomAnchor.constraint(equalTo: labelMomentsCount.topAnchor),
            labelMomentsCountText.trailingAnchor.constraint(equalTo: labelMomentsCount.trailingAnchor, constant: -4),
            
            labelLikesCountText.bottomAnchor.constraint(equalTo: labelLikesCount.topAnchor),
            labelLikesCountText.trailingAnchor.constraint(equalTo: labelLikesCount.trailingAnchor, constant: -4),
            
            labelPetsCountText.bottomAnchor.constraint(equalTo: labelPetsCount.topAnchor),
            labelPetsCountText.trailingAnchor.constraint(equalTo: labelPetsCount.trailingAnchor, constant: -4),
            
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
