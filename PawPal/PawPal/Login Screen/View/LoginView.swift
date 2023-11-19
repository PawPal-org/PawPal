//
//  LoginView.swift
//  PawPal
//
//  Created by Yitian Guo on 11/17/23.
//

import UIKit

class LoginView: UIView {
    
    var buttonEmail: UIButton!
    var buttonPhone: UIButton!

    var textFieldEmail: UITextField!
    var textFieldPassword: UITextField!
    
    var textFieldPhoneNumber: UITextField!
    var textFieldOTP: UITextField!
    
    var buttonLogin: UIButton!
    
    var buttonSignUp: UIButton!
    var buttonForgotPassword: UIButton!
    var stack: UIStackView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        styleButtonAsSelected(buttonEmail, selected: !textFieldEmail.isHidden)
        styleButtonAsSelected(buttonPhone, selected: !textFieldPhoneNumber.isHidden)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupButtonEmail()
        setupButtonPhone()
        
        setupTextFieldEmail()
        setupTextFieldPassword()
        
        setupTextFieldPhoneNumber()
        setupTextFieldOTP()
        
        setupHorizontalStack()
        setupButtonLogin()
        setupButtonForgotPassword()
        setupButtonSignUp()
        
        initConstraints()
    }
    
    func styleButtonAsSelected(_ button: UIButton, selected: Bool) {
        let underlineThickness: CGFloat = 2
        let underlineLayer = CALayer()

        if selected {
            underlineLayer.backgroundColor = UIColor.black.cgColor
            underlineLayer.frame = CGRect(x: 0, y: button.frame.size.height - underlineThickness, width: button.frame.size.width, height: underlineThickness)
            button.layer.addSublayer(underlineLayer)
        } else {
            button.layer.sublayers?.forEach { if $0 != button.titleLabel?.layer { $0.removeFromSuperlayer() } }
        }
    }
    
    @objc func toggleEmailFields() {
        textFieldEmail.isHidden = false
        textFieldPassword.isHidden = false
        textFieldPhoneNumber.isHidden = true
        textFieldOTP.isHidden = true
        
        styleButtonAsSelected(buttonEmail, selected: true)
        styleButtonAsSelected(buttonPhone, selected: false)
        
        buttonEmail.tintColor = .black
        buttonPhone.tintColor = .gray
    }
    
    @objc func togglePhoneFields() {
        textFieldPhoneNumber.isHidden = false
        textFieldOTP.isHidden = false
        textFieldEmail.isHidden = true
        textFieldPassword.isHidden = true
        
        styleButtonAsSelected(buttonEmail, selected: false)
        styleButtonAsSelected(buttonPhone, selected: true)
        
        buttonPhone.tintColor = .black
        buttonEmail.tintColor = .gray
        
    }
    
    func setupButtonEmail() {
        buttonEmail = UIButton(type: .system)
        buttonEmail.setTitle("Email", for: .normal)
        buttonEmail.addTarget(self, action: #selector(toggleEmailFields), for: .touchUpInside)
        buttonEmail.tintColor = .gray
        styleButtonAsSelected(buttonEmail, selected: true) // Default selected
        buttonEmail.layer.cornerRadius = 10
        buttonEmail.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonEmail)
    }
    
    func setupButtonPhone() {
        buttonPhone = UIButton(type: .system)
        buttonPhone.setTitle("Phone", for: .normal)
        buttonPhone.addTarget(self, action: #selector(togglePhoneFields), for: .touchUpInside)
        buttonPhone.tintColor = .gray
        styleButtonAsSelected(buttonPhone, selected: false) // Default unselected
        buttonPhone.layer.cornerRadius = 10
        buttonPhone.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonPhone)
    }
    
    func setupTextFieldEmail() {
        textFieldEmail = UITextField()
        textFieldEmail.placeholder = "Email"
        textFieldEmail.keyboardType = .emailAddress
        textFieldEmail.borderStyle = .roundedRect
        textFieldEmail.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldEmail)
    }
    
    func setupTextFieldPassword() {
        textFieldPassword = UITextField()
        textFieldPassword.placeholder = "Password"
        textFieldPassword.textContentType = .password
        textFieldPassword.isSecureTextEntry = true
        textFieldPassword.borderStyle = .roundedRect
        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldPassword)
    }
    
    func setupTextFieldPhoneNumber() {
        textFieldPhoneNumber = UITextField()
        textFieldPhoneNumber.placeholder = "Phone Number"
        textFieldPhoneNumber.keyboardType = .phonePad
        textFieldPhoneNumber.borderStyle = .roundedRect
        textFieldPhoneNumber.translatesAutoresizingMaskIntoConstraints = false
        textFieldPhoneNumber.isHidden = true // Initially hidden
        self.addSubview(textFieldPhoneNumber)
    }

    func setupTextFieldOTP() {
        textFieldOTP = UITextField()
        textFieldOTP.placeholder = "One Time Code"
        textFieldOTP.keyboardType = .numberPad
        textFieldOTP.borderStyle = .roundedRect
        textFieldOTP.translatesAutoresizingMaskIntoConstraints = false
        textFieldOTP.isHidden = true // Initially hidden
        self.addSubview(textFieldOTP)
    }
    
    func setupButtonLogin() {
        buttonLogin = UIButton(type: .system)
        buttonLogin.setTitle("Login", for: .normal)
        buttonLogin.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buttonLogin.backgroundColor = .systemGray
        buttonLogin.tintColor = .white
        buttonLogin.layer.cornerRadius = 10
        buttonLogin.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonLogin)
    }
    func setupHorizontalStack() {
        stack = UIStackView()
        stack.axis = .horizontal //the stack grows horizontally...
        //stack.alignment = .center // Useful for vertical stacks. The stack will be centrally aligned
        stack.distribution = .fillProportionally //make spaces in between UI elements proportionately and automatically...
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stack)
    }
    
    func setupButtonForgotPassword() {
        buttonForgotPassword = UIButton(type: .system)
        buttonForgotPassword.setTitle("Forgot Password?", for: .normal)
        buttonForgotPassword.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buttonForgotPassword.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(buttonForgotPassword)
    }
    
    func setupButtonSignUp() {
        buttonSignUp = UIButton(type: .system)
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.systemGray
        ]
        let boldTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.systemBlue
        ]
        let normalText = NSAttributedString(string: "New User?\n", attributes: normalTextAttributes)
        let boldText = NSAttributedString(string: "Sign Up!", attributes: boldTextAttributes)

        let attributedTitle = NSMutableAttributedString()
        attributedTitle.append(normalText)
        attributedTitle.append(boldText)
        buttonSignUp.setAttributedTitle(attributedTitle, for: .normal)
        buttonSignUp.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buttonSignUp.titleLabel?.numberOfLines = 0 // Allow multiple lines
        buttonSignUp.titleLabel?.lineBreakMode = .byWordWrapping
        buttonSignUp.titleLabel?.textAlignment = .center
        buttonSignUp.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(buttonSignUp)
    }

    
    func initConstraints() {
        NSLayoutConstraint.activate([
            
            buttonEmail.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            buttonEmail.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 96),

            buttonPhone.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            buttonPhone.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -96),
            
            textFieldEmail.topAnchor.constraint(equalTo: buttonEmail.bottomAnchor, constant: 32),
            textFieldEmail.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldEmail.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            textFieldPassword.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 16),
            textFieldPassword.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldPassword.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            textFieldPhoneNumber.topAnchor.constraint(equalTo: buttonEmail.bottomAnchor, constant: 32),
            textFieldPhoneNumber.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldPhoneNumber.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            textFieldOTP.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 16),
            textFieldOTP.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldOTP.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            buttonLogin.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 32),
            buttonLogin.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            buttonLogin.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            stack.topAnchor.constraint(equalTo: buttonLogin.bottomAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 2),
            stack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
