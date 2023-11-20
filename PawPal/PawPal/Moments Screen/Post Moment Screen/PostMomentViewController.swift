//
//  PostMomentViewController.swift
//  PawPal
//
//  Created by Yitian Guo on 11/20/23.
//

import UIKit

class PostMomentViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    let postMomentScreen = PostMomentView()
    var selectedImage: UIImage?
    var selectedImages: [UIImage] = []

    override func loadView() {
        view = postMomentScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "New Post"

        postMomentScreen.collectionView.dataSource = self
        postMomentScreen.collectionView.delegate = self
        postMomentScreen.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
        postMomentScreen.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "addCell")

        if let selectedImage = selectedImage {
            selectedImages.append(selectedImage)
        }
        postMomentScreen.collectionView.reloadData()
    }
    
    //MARK: UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // the last cell which will be 'Add' button
        if indexPath.row == selectedImages.count {
            
            // Dequeue a different cell or reuse the same type but configure for the 'Add' button
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath)
            
            if cell.contentView.subviews.isEmpty {
                let addButton = UIButton(frame: cell.bounds)
                addButton.setImage(UIImage(systemName: "plus"), for: .normal)
                addButton.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
                cell.contentView.addSubview(addButton)
            }
            return cell
            
        } else {
            //normal image cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
            // add an imageView to the cell if it doesn't already contain one
            if cell.contentView.subviews.isEmpty {
                let imageView = UIImageView(frame: cell.bounds)
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(imageView)
                
                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                    imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                    imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                    imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)
                ])
            }
           
            let imageView = cell.contentView.subviews[0] as! UIImageView
            imageView.image = selectedImages[indexPath.row]
            return cell
        }
    }

    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 30
        let collectionViewSize = collectionView.frame.size.width - padding
        let width = collectionViewSize / 3
        return CGSize(width: width, height: width)
    }
    
    @objc func addImageButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        if let newImage = info[.originalImage] as? UIImage {
            selectedImages.append(newImage)
            postMomentScreen.collectionView.reloadData()
        }
    }
}
