//
//  SettingView.swift
//  PawPal
//
//  Created by Cynthia Zhang on 12/3/23.
//

import UIKit

class SettingView: UIView {

    var buttonTakePhoto: UIButton!
    var labelPhoto:UILabel!
    
    var labelEmail: UILabel!
    var textFieldName: UITextField!
    
    var buttonSave: UIButton!

    
    //MARK: View initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //setting the background color
        self.backgroundColor = .white
        
        setupbuttonTakePhoto()
        setuplabelPhoto()
        setupLabelEmail()
        setuptextFieldName()
        
        setupbuttonSave()
        
        initConstraints()
    }
    
    //MARK: initializing the UI elements
    
    func setupbuttonTakePhoto(){
        buttonTakePhoto = UIButton(type: .system)
        buttonTakePhoto.setTitle("", for: .normal)
        buttonTakePhoto.setImage(UIImage(systemName: "camera.circle.fill")?.withRenderingMode(.alwaysOriginal), for: .normal)
        buttonTakePhoto.contentHorizontalAlignment = .fill
        buttonTakePhoto.contentVerticalAlignment = .fill
        buttonTakePhoto.layer.cornerRadius = 50
        buttonTakePhoto.clipsToBounds = true
        buttonTakePhoto.imageView?.contentMode = .scaleAspectFill
        buttonTakePhoto.showsMenuAsPrimaryAction = true
        buttonTakePhoto.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonTakePhoto)
    }
    
    func setuplabelPhoto(){
        labelPhoto = UILabel()
        labelPhoto.text = "Tap to Change Photo"
        labelPhoto.font = UIFont.boldSystemFont(ofSize: 14)
        labelPhoto.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelPhoto)
    }
    
    func setupLabelEmail(){
        labelEmail = UILabel()
        labelEmail.font = labelEmail.font.withSize(24)
        labelEmail.textAlignment = .left
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelEmail)
    }
    
    func setuptextFieldName(){
            textFieldName = UITextField()
            textFieldName.placeholder = "Name"
            textFieldName.keyboardType = .default
            textFieldName.borderStyle = .roundedRect
            textFieldName.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(textFieldName)
        }
    
    func setupbuttonSave(){
        buttonSave = UIButton(type: .system)
        buttonSave.setTitle("Save", for: .normal)
        buttonSave.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buttonSave.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonSave)
    }
    
    
    
    //MARK: initializing the constraints
    func initConstraints(){
        NSLayoutConstraint.activate([
            buttonTakePhoto.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            buttonTakePhoto.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            //MARK: set the height and width of an ImageView with constraints
            buttonTakePhoto.heightAnchor.constraint(equalToConstant: 100),
            buttonTakePhoto.widthAnchor.constraint(equalToConstant: 100),
            
            labelPhoto.topAnchor.constraint(equalTo: buttonTakePhoto.bottomAnchor),
            labelPhoto.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            labelEmail.topAnchor.constraint(equalTo: labelPhoto.bottomAnchor, constant: 32),
            labelEmail.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            labelEmail.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            textFieldName.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 16),
            textFieldName.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldName.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            buttonSave.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 32),
            buttonSave.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
