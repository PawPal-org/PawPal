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
                let imagesRepo = storageRef.child("imagesUsers")
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
    
//    func registerNewAccount(){
//        //MARK: create a Firebase user with email and password...
//        if let name = registerView.textFieldName.text,
//           let email = registerView.textFieldEmail.text,
//           let password = registerView.textFieldPassword.text{
//            //Validations....
//            Auth.auth().createUser(withEmail: email, password: password, completion: {result, error in
//                if error == nil{
//                    //MARK: the user creation is successful...
//                    self.setNameOfTheUserInFirebaseAuth(name: name)
//                }else{
//                    //MARK: there is a error creating the user...
//                    print(error ?? "error")
//                }
//            })
//        }
//    }
    
//    //MARK: We set the name of the user after we create the account...
//    func setNameOfTheUserInFirebaseAuth(name: String){
//        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
//        changeRequest?.displayName = name
//        changeRequest?.commitChanges(completion: {(error) in
//            if error == nil{
//                //MARK: the profile update is successful...
//                self.navigationController?.popViewController(animated: true)
//            }else{
//                //MARK: there was an error updating the profile...
//                print("Error occured: \(String(describing: error))")
//            }
//        })
//    }
    
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
        
        let collectionUsers = database.collection("users")
        
        let newUser = ["email": newUserEmail, "name": currentUser.displayName ?? ""]
            
        
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
