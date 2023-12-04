//
//  SettingFirebaseManager.swift
//  PawPal
//
//  Created by Cynthia Zhang on 12/3/23.
//

import Foundation
import FirebaseAuth
import FirebaseStorage

import FirebaseFirestore
import FirebaseFirestoreSwift

extension SettingViewController{
    
    func deleteProfileImageUrlFromFirestore() {
        let email = settingScreen.labelEmail.text ?? ""
        let userDocument = db.collection("users").document(email)

        userDocument.updateData(["profileImageUrl": FieldValue.delete()]) { error in
            if let error = error {
                print("Error deleting profile image URL: \(error)")
            } else {
                print("Profile image URL deleted successfully.")
            }
        }
    }
    
    func deleteOldProfilePhoto(oldPhotoURL: String) {
        let storageRef = storage.reference(forURL: oldPhotoURL)
        storageRef.delete { error in
            if let error = error {
                print("Error deleting old profile photo: \(error)")
            } else {
                print("Old profile photo deleted successfully.")
            }
        }
    }
    
    //MARK: Authentication...
    func uploadProfilePhotoToStorage() {
        var profilePhotoURL: URL?

        //MARK: Upload the profile photo if there is any...
        if let image = pickedImage {
            if let jpegData = image.jpegData(compressionQuality: 80) {
                let storageRef = storage.reference()
                let imagesRepo = storageRef.child("user_images")
                let imageRef = imagesRepo.child("\(NSUUID().uuidString).jpg")

                let uploadTask = imageRef.putData(jpegData, completion: { (metadata, error) in
                    if error == nil {
                        imageRef.downloadURL(completion: { (url, error) in
                            if let url = url, error == nil {
                                profilePhotoURL = url
//                                self.saveUserPicToFireStore(photoURL: profilePhotoURL)
                                self.setNameAndPhotoOfTheUserInFirebaseAuth(newPhotoURL: profilePhotoURL)
                            } else {
                                print("Error downloading URL: \(error?.localizedDescription ?? "Unknown error")")
                            }
                        })
                    } else {
                        print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
                    }
                })
            }
        } else {
            self.setNameAndPhotoOfTheUserInFirebaseAuth(newPhotoURL: profilePhotoURL)
        }
    }

    
    func setNameAndPhotoOfTheUserInFirebaseAuth(newPhotoURL: URL?){
        guard let user = Auth.auth().currentUser else { return }
        let name = settingScreen.textFieldName.text ?? ""
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.photoURL = newPhotoURL

        print("Auth changed\(String(describing: newPhotoURL))")
        changeRequest?.commitChanges(completion: {(error) in
            if error != nil{
                print("Error occured in Auth: \(String(describing: error))")
            }else{

                //Update the user to Firestore
                self.saveUserPicToFireStore(photoURL: newPhotoURL)

                //MARK: hide the progress indicator...
                //self.hideActivityIndicator()
            }
        })
    }
    
    //MARK: Firestore database...
    //MARK: logic to save a user profile to Firestore...
    func saveUserPicToFireStore(photoURL: URL?){
        guard let photoURL = photoURL else {
            print("Photo URL is nil")
            return
        }
        
        let email = settingScreen.labelEmail.text ?? ""
        let userDocument = db.collection("users").document(email)
        
        userDocument.setData(["profileImageUrl": photoURL.absoluteString], merge: true) { error in
            if let error = error {
                print("Error saving profile image URL to Firestore: \(error)")
            } else {
                print("Profile image URL successfully saved to Firestore.")
            }
        }

    }

                                                  
    func updateUserName(){
        let email = settingScreen.labelEmail.text ?? ""
        let userDocument = db.collection("users").document(email)
        
        if let name = settingScreen.textFieldName.text{
            userDocument.updateData(["name": name]) { error in
                if let error = error {
                    print("Error updating user profile: \(error)")
                } else {
                    print("User profile updated successfully.")
                    //MARK: pop the current controller...
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
                                                  
}
