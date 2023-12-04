//
//  AddPetPhotoManager.swift
//  sketch
//
//  Created by Cynthia Zhang on 12/1/23.
//


import Foundation
import UIKit
import PhotosUI

//MARK: adopting required protocols for PHPicker...

extension AddPetViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
            DispatchQueue.main.async {
                if let uwImage = image as? UIImage {
                    switch self.pickingImageFor {
                    case .background:
                        let resizedImage = uwImage.resizedImageForButtonBackground(newSize: self.addPetScreen.petBackgroundButton.bounds.size)
                        if let resizedImage = resizedImage {
                            self.addPetScreen.petBackgroundButton.setBackgroundImage(resizedImage, for: .normal)
                            self.addPetScreen.isCustomBackgroundImageSet = true
                            self.pickedBackgroundImage = uwImage
                        }
                        
                        
                    case .pet:
                        self.addPetScreen.petPicButton.setBackgroundImage(uwImage, for: .normal)
                        self.addPetScreen.petPicButton.layer.borderWidth = 3
                        self.addPetScreen.petPicButton.layer.borderColor = UIColor.white.cgColor
                        self.pickedPetImage = uwImage
                    case .none:
                        break
                    }
                    self.pickingImageFor = nil // Reset the picking image for flag
                }
            }
        }
    }
}

extension AddPetViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage {
            switch pickingImageFor {
            case .background:
                let resizedImage = image.resizedImageForButtonBackground(newSize: self.addPetScreen.petBackgroundButton.bounds.size)
                if let resizedImage = resizedImage {
                    self.addPetScreen.petBackgroundButton.setBackgroundImage(resizedImage, for: .normal)
                    self.addPetScreen.isCustomBackgroundImageSet = true
                    self.pickedBackgroundImage = image
                }
            case .pet:
                self.addPetScreen.petPicButton.setBackgroundImage(image, for: .normal)
                self.addPetScreen.petPicButton.layer.borderWidth = 3
                self.addPetScreen.petPicButton.layer.borderColor = UIColor.white.cgColor
                self.pickedPetImage = image
            case .none:
                break
            }
            self.pickingImageFor = nil // Reset the picking image for flag
        }
    }
}
