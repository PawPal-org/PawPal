//
//  MeView.swift
//  sketch
//
//  Created by Cynthia Zhang on 11/19/23.
//

import UIKit

class MeView: UIView {

    var meTable: UITableView!
    var settingTable: UITableView!
    var logOutTable: UITableView!
    
    var upperProfileView:UIView!
    var imageUser:UIImageView!
    var labelName: UILabel!
    var labelUserName: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 240/255, green: 237/255, blue: 233/255, alpha: 1.0)
        
        setupMeTable()
        setupSettingTable()
        setupLogOutTable()
        
        setupUpperProfileView()
        setupImageUser()
        setupLabelName()
        setupLabelUserName()
        
        initConstraints()
    }

    func setupMeTable(){
        meTable = UITableView()
        meTable.register(MeTableViewCell.self, forCellReuseIdentifier: "MeTableViewCell")
        meTable.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(meTable)
    }
    
    func setupSettingTable(){
        settingTable = UITableView()
        settingTable.register(SettingTableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
        settingTable.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(settingTable)
    }
    
    func setupLogOutTable(){
        logOutTable = UITableView()
        logOutTable.register(LogOutTableViewCell.self, forCellReuseIdentifier: "LogOutTableViewCell")
        logOutTable.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logOutTable)
    }
    
    func setupUpperProfileView(){
        upperProfileView = UIView()
        upperProfileView.backgroundColor = .white
//        upperProfileView.layer.cornerRadius = 6
//        upperProfileView.layer.shadowColor = UIColor.lightGray.cgColor
        upperProfileView.layer.shadowOffset = .zero
//        upperProfileView.layer.shadowRadius = 4.0
//        upperProfileView.layer.shadowOpacity = 0.7
        upperProfileView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(upperProfileView)
    }
    
    func setupImageUser(){
        imageUser = UIImageView()
        imageUser.image = UIImage(systemName: "person.fill")
        imageUser.contentMode = .scaleToFill
        imageUser.clipsToBounds = true
        imageUser.layer.cornerRadius = 10
        imageUser.translatesAutoresizingMaskIntoConstraints = false
        upperProfileView.addSubview(imageUser)
    }
    
    func setupLabelName(){
        labelName = UILabel()
        labelName.font = UIFont.boldSystemFont(ofSize: 27)
        labelName.textAlignment = .left
        labelName.translatesAutoresizingMaskIntoConstraints = false
        upperProfileView.addSubview(labelName)
    }
    
    func setupLabelUserName(){
        labelUserName = UILabel()
        labelUserName.font = UIFont.systemFont(ofSize: 23)
        labelUserName.textAlignment = .left
        labelUserName.translatesAutoresizingMaskIntoConstraints = false
        upperProfileView.addSubview(labelUserName)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            //bottom add view...
            upperProfileView.topAnchor.constraint(equalTo: self.topAnchor),
            upperProfileView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            upperProfileView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            imageUser.topAnchor.constraint(equalTo: upperProfileView.topAnchor, constant: 97),
            imageUser.leadingAnchor.constraint(equalTo: upperProfileView.leadingAnchor, constant: 16),
            imageUser.heightAnchor.constraint(equalToConstant: 120),
            imageUser.widthAnchor.constraint(equalToConstant: 120),
            
            labelName.leadingAnchor.constraint(equalTo: imageUser.trailingAnchor, constant: 16),
            labelName.trailingAnchor.constraint(equalTo: upperProfileView.trailingAnchor, constant: -16),
            labelName.topAnchor.constraint(equalTo: imageUser.topAnchor, constant: 16),

            labelUserName.leadingAnchor.constraint(equalTo: imageUser.trailingAnchor, constant: 16),
            labelUserName.trailingAnchor.constraint(equalTo: upperProfileView.trailingAnchor, constant: -16),
            labelUserName.bottomAnchor.constraint(equalTo: imageUser.bottomAnchor, constant: -16),
            
            upperProfileView.bottomAnchor.constraint(equalTo: imageUser.bottomAnchor, constant: 32),
            
            
            meTable.topAnchor.constraint(equalTo: upperProfileView.bottomAnchor, constant: 8),
            meTable.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            meTable.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            meTable.bottomAnchor.constraint(equalTo: meTable.topAnchor, constant: 149),
            
            settingTable.topAnchor.constraint(equalTo: meTable.bottomAnchor, constant: 8),
            settingTable.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            settingTable.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            settingTable.bottomAnchor.constraint(equalTo: settingTable.topAnchor, constant: 48),
            
            logOutTable.topAnchor.constraint(equalTo: settingTable.bottomAnchor, constant: 8),
            logOutTable.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            logOutTable.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            logOutTable.bottomAnchor.constraint(equalTo: logOutTable.topAnchor, constant: 48),
            
        ])
    }
    
    
    //MARK: initializing constraints...
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
