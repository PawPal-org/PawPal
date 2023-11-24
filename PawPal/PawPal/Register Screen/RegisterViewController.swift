//
//  RegisterViewController.swift
//  PawPal
//
//  Created by Schromeo on 11/19/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import PhotosUI
import FirebaseStorage

class RegisterViewController: UIViewController {

    let registerView = RegisterView()
    
    //MARK: add photo to Storage
    let storage = Storage.storage()
    
    //MARK: add user to Firestore
    let database = Firestore.firestore()
    
    //MARK: variable to store the picked Image...
    var pickedImage:UIImage?
    
    override func loadView() {
        view = registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        registerView.buttonRegister.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
        title = "Register"
        registerView.buttonTakePhoto.menu = getMenuImagePicker()
    }
    
    @objc func onRegisterTapped(){
        //MARK: creating a new user on Firebase
        //self.registerNewAccount()
        //MARK: first verify the information...
        if (verifyInformation()) {
            //MARK: creating a new user on Firebase with photo...
            //showActivityIndicator()
            uploadProfilePhotoToStorage()
        }
    }
    
    func verifyInformation() -> Bool{
        let name = registerView.textFieldName.text ?? ""
        let email = registerView.textFieldEmail.text ?? ""
        let password = registerView.textFieldPassword.text ?? ""
        let passwordAgain = registerView.textFieldPasswordAgain.text ?? ""
        if name.isEmpty || email.isEmpty || password.isEmpty || passwordAgain.isEmpty {
            showAlert(title: "Error!", message: "Please fill in all information!")
            return false
        }

        // Validate the email
        if !isValidEmail(email) {
            showAlert(title: "Error!", message: "A valid email is required!")
            return false
        }
        
        // Validate the password
        if !isValidPassword(password) {
            showAlert(title: "Error!", message: "Password must be at least 6 characters!")
            return false
        }

        // Check if the passwords are the same
        if !isSamePassword(password1: password, password2: passwordAgain) {
            showAlert(title: "Error!", message: "Please enter the same password again!")
            return false
        }
        
        return true
    }
    
    //MARK: Check the email address...
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    //MARK: Check the password...
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    //MARK: Check the passwords match...
    func isSamePassword(password1: String, password2: String) -> Bool {
        return password1 == password2
    }
    
    //MARK: Alert controller logics...
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    //MARK: menu for buttonTakePhoto setup...
    func getMenuImagePicker() -> UIMenu{
        let menuItems = [
            UIAction(title: "Camera",handler: {(_) in
                self.pickUsingCamera()
            }),
            UIAction(title: "Gallery",handler: {(_) in
                self.pickPhotoFromGallery()
            })
        ]
        
        return UIMenu(title: "Select source", children: menuItems)
    }
    
    //MARK: take Photo using Camera...
    func pickUsingCamera(){
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.allowsEditing = true
        cameraController.delegate = self
        present(cameraController, animated: true)
    }
    
    //MARK: pick Photo using Gallery...
    func pickPhotoFromGallery(){
        //MARK: Photo from Gallery...
        var configuration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.any(of: [.images])
        configuration.selectionLimit = 1
        
        let photoPicker = PHPickerViewController(configuration: configuration)
        
        photoPicker.delegate = self
        present(photoPicker, animated: true, completion: nil)
    }
    
    
}
