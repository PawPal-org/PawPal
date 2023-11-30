//
//  NewFriendsTableViewCell.swift
//  PawPal
//
//  Created by Yitian Guo on 11/30/23.
//

import UIKit

class NewFriendsTableViewCell: UITableViewCell {

    var wrapperCellView: UIView!
    
    var buttonProfilePic: UIButton!
    var labelName: UILabel!
    var labelTimestamp: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupButtonProfilePic()
        setupLabelName()
        setupLabelTimestamp()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UIView()
        
        //working with the shadows and colors...
        wrapperCellView.backgroundColor = .clear
        wrapperCellView.layer.cornerRadius = 0
        wrapperCellView.layer.shadowOpacity = 0
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupButtonProfilePic(){
        buttonProfilePic = UIButton()
        buttonProfilePic.setBackgroundImage(UIImage(systemName: "person.crop.circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        buttonProfilePic.imageView?.contentMode = .scaleAspectFill
        buttonProfilePic.tintColor = .gray
        buttonProfilePic.layer.cornerRadius = 15
        buttonProfilePic.clipsToBounds = true
        // profilePicButton.layer.masksToBounds = true
        // maintain a square shape
        let buttonSize: CGFloat = 40
        buttonProfilePic.layer.cornerRadius = buttonSize / 2
        buttonProfilePic.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(buttonProfilePic)
    }
    
    func setupLabelName(){
        labelName = UILabel()
        labelName.font = UIFont.boldSystemFont(ofSize: 20)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelName)
    }
    
    func setupLabelTimestamp(){
        labelTimestamp = UILabel()
        labelTimestamp.font = UIFont.systemFont(ofSize: 10)
        labelTimestamp.textColor = .darkGray
        labelTimestamp.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelTimestamp)
    }

    
    func initConstraints(){
        NSLayoutConstraint.activate([
            
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            buttonProfilePic.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
            buttonProfilePic.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor),
            buttonProfilePic.widthAnchor.constraint(equalToConstant: 40),
            buttonProfilePic.heightAnchor.constraint(equalToConstant: 40),
            
            labelName.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
            labelName.leadingAnchor.constraint(equalTo: buttonProfilePic.trailingAnchor, constant: 8),
            labelName.heightAnchor.constraint(equalToConstant: 20),
            labelName.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            labelTimestamp.topAnchor.constraint(equalTo: wrapperCellView.topAnchor),
            labelTimestamp.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -10),
            labelTimestamp.heightAnchor.constraint(equalToConstant: 16),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
