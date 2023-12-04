//
//  AddPetViewController.swift
//  PawPal
//
//  Created by Cynthia Zhang on 11/20/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import PhotosUI
import FirebaseStorage

class AddPetViewController: UIViewController {
    
    let addPetScreen = AddPetView()
    
    //MARK: add photo to Storage
    let storage = Storage.storage()
    
    //MARK: add user to Firestore
    let database = Firestore.firestore()
    var currentUser: FirebaseAuth.User?
    
    //MARK: variable to store the picked Image...
    var pickedBackgroundImage:UIImage?
    var pickedPetImage:UIImage?
    
    //MARK: distinguish between the button
    enum PickingImageFor {
        case background
        case pet
    }
    
    var pickingImageFor: PickingImageFor?
    
    override func loadView() {
        view = addPetScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save, target: self,
            action: #selector(onSaveBarButtonTapped)
        )
        
        addPetScreen.petBackgroundButton.menu = getMenuBGImagePicker()
        addPetScreen.petPicButton.menu = getMenuProfileImagePicker()
    }
    
    @objc func onSaveBarButtonTapped() {
        if (verifyInformation()) {
            //MARK: creating a new user on Firebase with photo...
            //showActivityIndicator()
            uploadPhotosToStorage()
        }
    }
    
    @objc func getTimestamp() {
        let selectedDate = addPetScreen.datePickerBDay.date
        let timestamp = selectedDate.timeIntervalSince1970
        print("Selected Timestamp: \(timestamp)")
    }
    
    func verifyInformation() -> Bool{
        let name = addPetScreen.textFieldName.text ?? ""
        let sex = addPetScreen.textFieldSex.text ?? ""
        let breed = addPetScreen.textFieldBreed.text ?? ""
        let city = addPetScreen.textFieldCity.text ?? ""
        let weight = addPetScreen.textFieldWeight.text ?? ""
        let vac = addPetScreen.textFieldVac.text ?? ""
        let descrip = addPetScreen.textFieldDescrip.text ?? ""
        
        if name.isEmpty || sex.isEmpty || breed.isEmpty || city.isEmpty || weight.isEmpty || vac.isEmpty || descrip.isEmpty {
            showAlert(title: "Oops!", message: "PIt looks like you forgot to fill in some fields!\nDon't leave your pet's profile feeling lonely")
            return false
        }
        
        return true
    }
    
    //MARK: Alert controller logics...
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    //MARK: menu for petBackgroundButton setup...
    func getMenuBGImagePicker() -> UIMenu{
        let menuItems = [
            UIAction(title: "Camera",handler: { [weak self] (_) in
                self?.pickingImageFor = .background
                self?.pickUsingCamera()
            }),
            UIAction(title: "Gallery",handler: { [weak self] (_) in
                self?.pickingImageFor = .background
                self?.pickPhotoFromGallery()
            })
        ]
        
        return UIMenu(title: "Select source", children: menuItems)
    }

    //MARK: menu for petPicButton setup...
    func getMenuProfileImagePicker() -> UIMenu{
        let menuItems = [
            UIAction(title: "Camera",handler: { [weak self] (_) in
                self?.pickingImageFor = .pet
                self?.pickUsingCamera()
            }),
            UIAction(title: "Gallery",handler: { [weak self] (_) in
                self?.pickingImageFor = .pet
                self?.pickPhotoFromGallery()
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

