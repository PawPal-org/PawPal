//
//  LoginViewController.swift
//  PawPal
//
//  Created by Yitian Guo on 11/19/23.
//

import UIKit
import FirebaseAuth

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
        //MARK: Log In Action...
        if let email = loginView.textFieldEmail.text,
           let password = loginView.textFieldPassword.text{
            //check if the textfile is empty
            if email.isEmpty || password.isEmpty{
                self.showAlert(title: "Error!", message: "Please fill in all information!")
            } else {
                //MARK: sign-in logic for Firebase...
                self.signInToFirebase(email: email, password: password)
            }
        }
    }
    
    @objc func onSignUpTapped() {
        let registerViewController = RegisterViewController()
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    @objc func onForgotPasswordTapped() {
        
    }
    
    func signInToFirebase(email: String, password: String){
        //MARK: display progress indicator here
        //showActivityIndicator()
        
        //MARK: authenticating the user...
        Auth.auth().signIn(withEmail: email, password: password, completion: {(result, error) in
            if error == nil{
                //MARK: user authenticated...
                //MARK: hide the progress indicator here
                //self.hideActivityIndicator()
                print("Login successful")
                UserDefaults.standard.set(email, forKey: "currentUserEmail")
                // Transition to the main tab bar controller
                let mainTabBarController = ViewController()
                mainTabBarController.modalPresentationStyle = .fullScreen
                self.present(mainTabBarController, animated: true, completion: nil)
            }else{
                //MARK: alert that no user found or password wrong...
                //MARK: hide the progress indicator here
                //self.hideActivityIndicator()
                self.showAlert(title: "Error!", message: "Incorrect user email or password")
            }
        })
    }
    
    //MARK: Alert controller logics...
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

}
