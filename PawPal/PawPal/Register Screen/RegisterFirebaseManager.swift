//
//  RegisterFirebaseManager.swift
//  PawPal
//
//  Created by Schromeo on 11/19/23.
//

import Foundation
import FirebaseAuth
import FirebaseStorage

import FirebaseFirestore
import FirebaseFirestoreSwift

extension RegisterViewController{
    
    //MARK: Authentication...
    func uploadProfilePhotoToStorage(){
        var profilePhotoURL:URL?
        
        //MARK: Upload the profile photo if there is any...
        if let image = pickedImage{
            if let jpegData = image.jpegData(compressionQuality: 80){
                let storageRef = storage.reference()
                let imagesRepo = storageRef.child("user_images")
                let imageRef = imagesRepo.child("\(NSUUID().uuidString).jpg")
                
                let uploadTask = imageRef.putData(jpegData, completion: {(metadata, error) in
                    if error == nil{
                        imageRef.downloadURL(completion: {(url, error) in
                            if error == nil{
                                profilePhotoURL = url
                                self.registerUser(photoURL: profilePhotoURL)
                            }
                        })
                    }
                })
            }
        }else{
            registerUser(photoURL: profilePhotoURL)
        }
    }
    
    func registerUser(photoURL: URL?){
        //MARK: display the progress indicator...
        //showActivityIndicator()
        //MARK: create a Firebase user with email and password...
        if let name = registerView.textFieldName.text,
           let email = registerView.textFieldEmail.text,
           let password = registerView.textFieldPassword.text{
            //Validations....
            Auth.auth().createUser(withEmail: email, password: password, completion: {result, error in
                if error == nil{
                    self.setNameAndPhotoOfTheUserInFirebaseAuth(name: name, email: email, photoURL: photoURL)
                    let alertController = UIAlertController(title: nil, message: "Sign up successfully!\n Please Log in", preferredStyle: .alert)
                            self.present(alertController, animated: true) {
                                // 在两秒后自动消失
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    alertController.dismiss(animated: true, completion: nil)
                                }
                            }
                    self.navigationController?.popViewController(animated: true)
                } else {
                    let errorMessage = error?.localizedDescription ?? "Registration failed."
                    let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    //MARK: hide the progress indicator...
                    //self.hideActivityIndicator()
                    //Clean all the fields
                    self.registerView.textFieldName.text = ""
                    self.registerView.textFieldEmail.text = ""
                    self.registerView.textFieldPassword.text = ""
                    self.registerView.textFieldPasswordAgain.text = ""
                }
            })
        }
    }

    
    func setNameAndPhotoOfTheUserInFirebaseAuth(name: String, email: String, photoURL: URL?){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.photoURL = photoURL
        
        print("\(String(describing: photoURL))")
        changeRequest?.commitChanges(completion: {(error) in
            if error != nil{
                print("Error occured: \(String(describing: error))")
            }else{
                
                //add the user to Firestore
                self.saveUserToFireStore()
                
                //MARK: hide the progress indicator...
                //self.hideActivityIndicator()
                //MARK: pop the current controller...
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    //MARK: Firestore database...
    //MARK: logic to add a user to Firestore...
    func saveUserToFireStore(){
        guard let currentUser = Auth.auth().currentUser else {
            print("No signed in user")
            return
        }
        
        guard let newUserEmail = currentUser.email else {
            print("Email is missing")
            return
        }
        
        var newUser = ["email": newUserEmail, "name": currentUser.displayName ?? ""]
        if let photoURL = currentUser.photoURL {
            newUser["profileImageUrl"] = photoURL.absoluteString
        }
        
        let collectionUsers = database.collection("users")
        // Using the email as the document ID
        collectionUsers.document(newUserEmail).setData(newUser) { error in
            if let error = error {
                print("Error setting document: \(error)")
            } else {
                print("User added to Firestore with email as document ID.")
            }
        }

    }
}
