//
//  SettingView.swift
//  PawPal
//
//  Created by Cynthia Zhang on 12/3/23.
//

import UIKit

class SettingView: UIView {

    var labelEmail: UILabel!
    var labelName: UILabel!
    var labelPassword: UILabel!

    //MARK: declaring the ImageView for contact image
    var imageContact: UIImageView!
    
    //MARK: View initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //setting the background color
        self.backgroundColor = .white
        
        setupLabelEmail()
        setupLabelName()
        setupLabelPassword()

        //MARK: defining the ImageView for contact image
        setupimageContact()
        
        initConstraints()
    }
    
    //MARK: initializing the UI elements
    func setupLabelEmail(){
        labelEmail = UILabel()
        labelEmail.font = labelEmail.font.withSize(24)
        labelEmail.textAlignment = .left
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelEmail)
    }
    
    func setupLabelName(){
        labelName = UILabel()
        labelName.textAlignment = .left
        labelName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelName)
    }
    
    func setupLabelPassword(){
        labelPassword = UILabel()
        labelPassword.textAlignment = .left
        labelPassword.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelPassword)
    }
    
    
    //Adding the ImageView for contact
    func setupimageContact(){
        imageContact = UIImageView()
        imageContact.image = UIImage(systemName: "person.crop.circle")
        imageContact.contentMode = .scaleToFill
        imageContact.clipsToBounds = true
        imageContact.layer.cornerRadius = 50
        imageContact.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageContact)
    }
    
    
    
    //MARK: initializing the constraints
    func initConstraints(){
        NSLayoutConstraint.activate([
            imageContact.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageContact.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            //MARK: set the height and width of an ImageView with constraints
            imageContact.heightAnchor.constraint(equalToConstant: 100),
            imageContact.widthAnchor.constraint(equalToConstant: 100),
            
            labelEmail.topAnchor.constraint(equalTo: imageContact.bottomAnchor, constant: 32),
            labelEmail.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            labelName.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 16),
            labelName.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            labelPassword.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 16),
            labelPassword.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

