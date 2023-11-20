//
//  LoginViewController.swift
//  PawPal
//
//  Created by Yitian Guo on 11/19/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    let loginView = LoginView()
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "PawPal"
        
        loginView.buttonLogin.addTarget(self, action: #selector(onLoginTapped), for: .touchUpInside)
        loginView.buttonSignUp.addTarget(self, action: #selector(onSignUpTapped), for: .touchUpInside)
        loginView.buttonForgotPassword.addTarget(self, action: #selector(onForgotPasswordTapped), for: .touchUpInside)
    }
    
    @objc func onLoginTapped() {
        
    }
    
    @objc func onSignUpTapped() {
        let registerViewController = RegisterViewController()
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    @objc func onForgotPasswordTapped() {
        
    }

}
