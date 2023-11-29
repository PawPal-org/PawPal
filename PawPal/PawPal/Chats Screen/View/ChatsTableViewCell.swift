//
//  ChatsTableViewCell.swift
//  PawPal
//
//  Created by Yitian Guo on 11/28/23.
//

import UIKit

class ChatsTableViewCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    
    var buttonProfilePic: UIButton!
    var labelName: UILabel!
    var labelLastMessage: UILabel!
    var labelTimestamp: UILabel!
    var accessoryImageView: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupButtonProfilePic()
        setupLabelName()
        setupLabelLastMessage()
        setupLabelTimestamp()
        setupAccessoryImageView()
        
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
        buttonProfilePic.layer.cornerRadius = 15
        buttonProfilePic.clipsToBounds = true
        // profilePicButton.layer.masksToBounds = true
        // maintain a square shape
        let buttonSize: CGFloat = 50
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
    
    func setupLabelLastMessage(){
        labelLastMessage = UILabel()
        labelLastMessage.font = UIFont.systemFont(ofSize: 14)
        labelLastMessage.textColor = .darkGray
        labelLastMessage.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelLastMessage)
    }
    
    func setupLabelTimestamp(){
        labelTimestamp = UILabel()
        labelTimestamp.font = UIFont.systemFont(ofSize: 10)
        labelTimestamp.textColor = .darkGray
        labelTimestamp.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelTimestamp)
    }
    
    func setupAccessoryImageView() {
        accessoryImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        accessoryImageView.tintColor = .systemGray
        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(accessoryImageView)
    }

    
    func initConstraints(){
        NSLayoutConstraint.activate([
            
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            buttonProfilePic.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 2),
            buttonProfilePic.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor),
            buttonProfilePic.widthAnchor.constraint(equalToConstant: 50),
            buttonProfilePic.heightAnchor.constraint(equalToConstant: 50),
            
            labelName.topAnchor.constraint(equalTo: buttonProfilePic.topAnchor),
            labelName.leadingAnchor.constraint(equalTo: buttonProfilePic.trailingAnchor, constant: 8),
            labelName.heightAnchor.constraint(equalToConstant: 20),
            labelName.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            labelLastMessage.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 2),
            labelLastMessage.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            labelLastMessage.heightAnchor.constraint(equalToConstant: 16),
            labelLastMessage.widthAnchor.constraint(lessThanOrEqualTo: labelName.widthAnchor),
            
            accessoryImageView.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 2),
            accessoryImageView.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -2),
            accessoryImageView.widthAnchor.constraint(equalToConstant: 10),
            accessoryImageView.heightAnchor.constraint(equalToConstant: 10),
            
            labelTimestamp.topAnchor.constraint(equalTo: wrapperCellView.topAnchor),
            labelTimestamp.trailingAnchor.constraint(equalTo: accessoryImageView.trailingAnchor, constant: -10),
            labelTimestamp.heightAnchor.constraint(equalToConstant: 16),
            
            labelName.trailingAnchor.constraint(lessThanOrEqualTo: labelTimestamp.leadingAnchor, constant: -8),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 60)
            
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
