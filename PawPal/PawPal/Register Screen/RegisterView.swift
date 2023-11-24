//
//  RegisterView.swift
//  PawPal
//
//  Created by Schromeo on 11/19/23.
//

import UIKit

class RegisterView: UIView {
    
    var labelPhoto:UILabel!
    var buttonTakePhoto: UIButton!

    var textFieldName: UITextField!
    var textFieldEmail: UITextField!
    var textFieldPassword: UITextField!
    var textFieldPasswordAgain: UITextField!
    var buttonRegister: UIButton!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setuplabelPhoto()
        setupbuttonTakePhoto()
        
        setuptextFieldName()
        setuptextFieldEmail()
        setuptextFieldPassword()
        setuptextFieldPasswordAgain()
        setupbuttonRegister()
        
        initConstraints()
    }
    
    func setuplabelPhoto(){
        labelPhoto = UILabel()
        labelPhoto.text = "Add Profile Photo"
        labelPhoto.font = UIFont.boldSystemFont(ofSize: 14)
        labelPhoto.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelPhoto)
    }
    
    func setupbuttonTakePhoto(){
        buttonTakePhoto = UIButton(type: .system)
        buttonTakePhoto.setTitle("", for: .normal)
        buttonTakePhoto.setImage(UIImage(systemName: "camera.fill")?.withRenderingMode(.alwaysOriginal), for: .normal)
        //buttonTakePhoto.setImage(UIImage(systemName: "camera.fill")?.withRenderingMode(.alwaysOriginal), for: .normal)
        buttonTakePhoto.contentHorizontalAlignment = .fill
        buttonTakePhoto.contentVerticalAlignment = .fill
        buttonTakePhoto.imageView?.contentMode = .scaleAspectFit
        buttonTakePhoto.showsMenuAsPrimaryAction = true
        buttonTakePhoto.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonTakePhoto)
    }
    
    func setuptextFieldName(){
            textFieldName = UITextField()
            textFieldName.placeholder = "Name"
            textFieldName.keyboardType = .default
            textFieldName.borderStyle = .roundedRect
            textFieldName.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(textFieldName)
        }
        
        func setuptextFieldEmail(){
            textFieldEmail = UITextField()
            textFieldEmail.placeholder = "Email"
            textFieldEmail.keyboardType = .emailAddress
            textFieldEmail.borderStyle = .roundedRect
            textFieldEmail.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(textFieldEmail)
        }
        
        func setuptextFieldPassword(){
            textFieldPassword = UITextField()
            textFieldPassword.placeholder = "Password"
            textFieldPassword.textContentType = .password
            textFieldPassword.isSecureTextEntry = true
            textFieldPassword.borderStyle = .roundedRect
            textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(textFieldPassword)
        }
    
        func setuptextFieldPasswordAgain(){
            textFieldPasswordAgain = UITextField()
            textFieldPasswordAgain.placeholder = "Password again"
            textFieldPasswordAgain.textContentType = .password
            textFieldPasswordAgain.isSecureTextEntry = true
            textFieldPasswordAgain.borderStyle = .roundedRect
            textFieldPasswordAgain.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(textFieldPasswordAgain)
        }
        
        func setupbuttonRegister(){
            buttonRegister = UIButton(type: .system)
            buttonRegister.setTitle("Register", for: .normal)
            buttonRegister.titleLabel?.font = .boldSystemFont(ofSize: 16)
            buttonRegister.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(buttonRegister)
        }
        
        func initConstraints(){
            NSLayoutConstraint.activate([
                textFieldName.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
                textFieldName.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
                textFieldName.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
                
                textFieldEmail.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 16),
                textFieldEmail.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
                textFieldEmail.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
                
                textFieldPassword.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 16),
                textFieldPassword.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
                textFieldPassword.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
                
                textFieldPasswordAgain.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 16),
                textFieldPasswordAgain.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
                textFieldPasswordAgain.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
                
                buttonTakePhoto.topAnchor.constraint(equalTo: textFieldPasswordAgain.bottomAnchor, constant: 16),
                buttonTakePhoto.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
                buttonTakePhoto.widthAnchor.constraint(equalToConstant: 100),
                buttonTakePhoto.heightAnchor.constraint(equalToConstant: 100),
                
                labelPhoto.topAnchor.constraint(equalTo: buttonTakePhoto.bottomAnchor),
                labelPhoto.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
                
                buttonRegister.topAnchor.constraint(equalTo: labelPhoto.bottomAnchor, constant: 32),
                buttonRegister.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

}
