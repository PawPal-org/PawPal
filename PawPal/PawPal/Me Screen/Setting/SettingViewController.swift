//
//  SettingViewController.swift
//  PawPal
//
//  Created by Cynthia Zhang on 12/3/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import PhotosUI
import FirebaseStorage

class SettingViewController: UIViewController {
    
    //MARK: creating instance of DisplayView
    let settingScreen = SettingView()
    let childProgressView = ProgressSpinnerViewController()
    
    //MARK: variable to store the picked Image...
    var pickedImage:UIImage?
    var didChangeProfileImage = false
    var hasProfilePicBefore = true

    //MARK: add photo to Storage
    let storage = Storage.storage()
    let db = Firestore.firestore()
    var currentUser: FirebaseAuth.User?
    var userProfileImageUrl: String?

    //MARK: patch the view of the controller to the DisplayView
    override func loadView() {
        view = settingScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.prefersLargeTitles = false
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: titleFont, size: 18)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        title = "Account Information"
        
        settingScreen.buttonTakePhoto.menu = getMenuImagePicker()
        settingScreen.buttonSave.addTarget(self, action: #selector(onSaveTapped), for: .touchUpInside)
    
//        settingScreen.labelEmail.text = "Email"
//        settingScreen.textFieldName.text = "Name"
        
        //MARK: recognizing the taps on the app screen, not the keyboard
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        view.addGestureRecognizer(tapRecognizer)
    
        fetchUserProfilePicture()
        fetchUserName()
    }
    
    
    func fetchUserName() {
        guard let user = Auth.auth().currentUser, let email = user.email else { return }
        // Safely unwrapped email to avoid passing a nil value
        let docRef = db.collection("users").document(email)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Assuming 'dataDescription' is for debugging purposes
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                    
                // Extract 'email' and 'name' safely
                let email = document.get("email") as? String ?? ""
                let name = document.get("name") as? String ?? ""
                
                // Dispatch UI updates on the main thread
                DispatchQueue.main.async {
                    self.settingScreen.labelEmail.text = email
                    self.settingScreen.textFieldName.text = name
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func fetchUserProfilePicture() {
        guard let user = Auth.auth().currentUser, let email = user.email else {
            print("User email is not set")
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(email).getDocument { [weak self] documentSnapshot, error in
            guard let self = self, let document = documentSnapshot, error == nil else {
                print("Error fetching user profile: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let profileImageUrlString = document.data()?["profileImageUrl"] as? String {
                
                self.userProfileImageUrl = profileImageUrlString // Store the URL

                if let url = URL(string: profileImageUrlString) {
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data, error == nil, let image = UIImage(data: data)?.withRenderingMode(.alwaysOriginal) else {
                            print("Error downloading profile image: \(error?.localizedDescription ?? "Unknown error")")
                            return
                        }

                        DispatchQueue.main.async {
                            self.settingScreen.buttonTakePhoto.setImage(image, for: .normal)
                        }
                    }.resume()
                }
            } else {
                hasProfilePicBefore = false
                print("Profile image URL not found")
            }
        }
    }

    //Logic of update user info to firebase
    @objc func onSaveTapped(){
        //MARK: first verify the information...
        if (verifyInformation()) {
            //MARK: show the progress indicator...
            showActivityIndicator()
            //MARK: creating a new user on Firebase with photo...
            if didChangeProfileImage {
                if hasProfilePicBefore{
                    if let oldImageUrl = userProfileImageUrl {
                        deleteProfileImageUrlFromFirestore()
                        deleteOldProfilePhoto(oldPhotoURL: oldImageUrl)
                    }
                    uploadProfilePhotoToStorage()
                } else { uploadProfilePhotoToStorage() }
            }
            updateUserName()
        }
    }
    
    func verifyInformation() -> Bool{
        let name = settingScreen.textFieldName.text ?? ""
        if name.isEmpty {
            showAlert(title: "Error!", message: "Please fill in your name!")
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
    
    //MARK: Hide Keyboard
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen
        view.endEditing(true)
    }
}
