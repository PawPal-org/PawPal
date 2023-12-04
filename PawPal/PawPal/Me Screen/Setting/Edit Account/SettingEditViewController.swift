//
//  SettingEditViewController.swift
//  PawPal
//
//  Created by Cynthia Zhang on 12/3/23.
//

import UIKit
import PhotosUI

class SettingEditViewController: UIViewController {
    
    //MARK: creating instance of DisplayView
    let settingEditScreen = SettingEditView()
    
    //MARK: variable to store the picked Image...
    var pickedImage:UIImage?

    //MARK: patch the view of the controller to the DisplayView
    override func loadView() {
        view = settingEditScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Edit Account Information"
        
        settingEditScreen.buttonTakePhoto.menu = getMenuImagePicker()
        settingEditScreen.buttonSave.addTarget(self, action: #selector(onSaveTapped), for: .touchUpInside)
        
        settingEditScreen.labelEmail.text = "Email"
    }
    
    @objc func onSaveTapped(){
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
        let name = settingEditScreen.textFieldName.text ?? ""
        let password = settingEditScreen.textFieldPassword.text ?? ""
        let passwordAgain = settingEditScreen.textFieldPasswordAgain.text ?? ""
        if name.isEmpty || password.isEmpty || passwordAgain.isEmpty {
            showAlert(title: "Error!", message: "Please fill in all information!")
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
