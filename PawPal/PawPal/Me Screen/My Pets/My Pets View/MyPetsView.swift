//
//  MyPetsView.swift
//  PawPal
//
//  Created by Cynthia Zhang on 11/20/23.
//

import UIKit

class MyPetsView: UIView {

    var tableViewPet: UITableView!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = backgroundColorBeige
        
        //MARK: initializing a TableView
        setupTableViewPet()
        initConstraints()
    }
    
    func setupTableViewPet(){
        tableViewPet = UITableView()
        tableViewPet.register(MyPetsTableViewCell.self, forCellReuseIdentifier: "pet")
        tableViewPet.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewPet)
    }
    
    //MARK: setting the constraints
    func initConstraints(){
        NSLayoutConstraint.activate([
            tableViewPet.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableViewPet.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewPet.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableViewPet.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

