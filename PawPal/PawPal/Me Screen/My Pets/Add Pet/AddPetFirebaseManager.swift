//
//  AddPetFirebaseManager.swift
//  PawPal
//
//  Created by Cynthia Zhang on 12/1/23.
//

import Foundation
import FirebaseAuth
import FirebaseStorage

import FirebaseFirestore
import FirebaseFirestoreSwift

extension AddPetViewController{
    
    //MARK: Authentication...
    func uploadPhotosToStorage(){
        var backgroundPhotoURL:URL?
        var petPhotoURL:URL?
        
        
        let dispatchGroup = DispatchGroup()

        // Upload the background image
        if let backgroundImage = pickedBackgroundImage, let jpegData = backgroundImage.jpegData(compressionQuality: 0.8) {
            dispatchGroup.enter()
            let backgroundRef = storage.reference().child("pet_images/pet_background_images/\(UUID().uuidString).jpg")
            backgroundRef.putData(jpegData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading background image: \(error.localizedDescription)")
                    dispatchGroup.leave()
                    return
                }
                backgroundRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting download URL for background image: \(error.localizedDescription)")
                    } else {
                        backgroundPhotoURL = url
                    }
                    dispatchGroup.leave()
                }
            }
        }

        // Upload the pet image
        if let petImage = pickedPetImage, let jpegData = petImage.jpegData(compressionQuality: 0.8) {
            dispatchGroup.enter()
            let petImageRef = storage.reference().child("pet_images/pet_profile_images/\(UUID().uuidString).jpg")
            petImageRef.putData(jpegData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading pet image: \(error.localizedDescription)")
                    dispatchGroup.leave()
                    return
                }
                petImageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting download URL for pet image: \(error.localizedDescription)")
                    } else {
                        petPhotoURL = url
                    }
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.uploadPetInformation(backgroundPhotoURL: backgroundPhotoURL, petPhotoURL: petPhotoURL)
        }
    }
    
    func uploadPetInformation(backgroundPhotoURL: URL?, petPhotoURL: URL?) {
        
        // Get the Firestore database reference
        let db = Firestore.firestore()
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            print("User is not logged in")
            return
        }
        
        // Collect pet information from the UI
        let name = addPetScreen.textFieldName.text ?? ""
        let sex = addPetScreen.textFieldSex.text ?? ""
        let breed = addPetScreen.textFieldBreed.text ?? ""
        let location = addPetScreen.textFieldCity.text ?? ""
        let weight = addPetScreen.textFieldWeight.text ?? ""
        let vac = addPetScreen.textFieldVac.text ?? ""
        let descrip = addPetScreen.textFieldDescrip.text ?? ""
        let birthday = addPetScreen.datePickerBDay.date
        
        // Create a new Pet instance
        let newPet = PetUpload(name: name, sex: sex, breed: breed, location: location, birthday: birthday, weight: weight, vaccinations: vac, descriptions: descrip, email: currentUserEmail, backgroundImageURL: backgroundPhotoURL?.absoluteString, petImageURL: petPhotoURL?.absoluteString)
        
        // Convert the Pet instance to a dictionary for Firestore
        guard let petDict = try? Firestore.Encoder().encode(newPet) else {
            print("Error encoding pet information")
            return
        }
        
        // Specify the collection where the pet information will be stored
        let petsCollection = db.collection("users").document(currentUserEmail).collection("myPets")
        
        // Add a new document to the myPets collection
        petsCollection.addDocument(data: petDict) { error in
            if let error = error {
                // Handle any errors
                print("Error writing document: \(error)")
            } else {
                // Document was successfully written
                print("Document successfully written!")
                // Handle success, e.g., navigate back or clear the form
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
