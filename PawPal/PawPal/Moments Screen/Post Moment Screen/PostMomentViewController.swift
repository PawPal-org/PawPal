//
//  PostMomentViewController.swift
//  PawPal
//
//  Created by Yitian Guo on 11/20/23.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class PostMomentViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var userEmail: String?
    let postMomentScreen = PostMomentView()
    var selectedImage: UIImage?
    var selectedImages: [UIImage] = []

    override func loadView() {
        view = postMomentScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: titleFont, size: 21)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        title = "New Post"

        postMomentScreen.collectionView.dataSource = self
        postMomentScreen.collectionView.delegate = self
        postMomentScreen.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
        postMomentScreen.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "addCell")

        if let selectedImage = selectedImage {
            selectedImages.append(selectedImage)
        }
        postMomentScreen.collectionView.reloadData()
        
        let barIcon = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.circle")?.withTintColor(.orange, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(onPostBarButtonTapped)
        )
        navigationItem.rightBarButtonItems = [barIcon]
        
        //MARK: recognizing the taps on the app screen, not the keyboard
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func onPostBarButtonTapped() {

        guard let userEmail = self.userEmail, let textContent = postMomentScreen.textView.text, !textContent.isEmpty else {
            let alert = UIAlertController(title: "Enter Text", message: "Don't forget to enter your text!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            return
        }

        guard !selectedImages.isEmpty else {
            let alert = UIAlertController(title: "No Images Selected", message: "Please select at least one image to post~", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            return
        }

        let firestore = Firestore.firestore()
        var imageUrlsMap: [String: String] = [:]
        let group = DispatchGroup()
        
        for (index, image) in selectedImages.enumerated() {
            group.enter() // Enter the group before starting the upload
            
            let imageName = UUID().uuidString + ".jpg"
            let storageRef = Storage.storage().reference().child("post_images").child(imageName)
            
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                storageRef.putData(imageData, metadata: nil) { metadata, error in
                    
                    if let error = error {
                        print("Error uploading image: \(error.localizedDescription)")
                        group.leave() // Leave the group on error
                        return
                    }
                    
                    storageRef.downloadURL { url, error in
                        if let error = error {
                            print("Error getting download URL: \(error.localizedDescription)")
                            group.leave()
                            return
                        }
                        
                        if let downloadURL = url {
                            let locationKey = "image\(index)"
                            imageUrlsMap[locationKey] = downloadURL.absoluteString
                        }
                        group.leave() // Leave the group after setting the URL
                    }
                }
            } else {
                print("Error converting image to JPEG data.")
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            
            let userDocRef = firestore.collection("users").document(userEmail)
            let momentID = UUID().uuidString
            
            let momentDocRef = userDocRef.collection("moments").document(momentID)
            
            let momentData = [
                "text": textContent,
                "timestamp": FieldValue.serverTimestamp(),
                "imageUrls": imageUrlsMap,
                "likes": [] as [String]
            ] as [String : Any]
            
            momentDocRef.setData(momentData) { [weak self] error in
                guard let strongSelf = self else { return }
                
                if let error = error {
                    print("\(error)")
                } else {
                    
                    // NotificationCenter.default.post(name: .didPostMoment, object: nil)

                    let alert = UIAlertController(title: "Success", message: "Your moment has been posted!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        strongSelf.navigationController?.popViewController(animated: true)
                    }))
                    strongSelf.present(alert, animated: true)
                }
            }
        }
    }
    
    //MARK: UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // the last cell will be 'Add' button
        if indexPath.row == selectedImages.count {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath)
            
            // Configure add button cell...
            if cell.contentView.subviews.isEmpty {
                let addButton = UIButton(frame: cell.bounds)
                addButton.backgroundColor = backgroundColorBeige
                addButton.setImage(UIImage(systemName: "plus"), for: .normal)
                addButton.tintColor = .black
                addButton.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
                cell.contentView.addSubview(addButton)
            }
            
            return cell
            
        } else {
            // normal image cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
            
            let imageView: UIImageView
            if let existingImageView = cell.contentView.subviews.first(where: { $0 is UIImageView }) as? UIImageView {
                imageView = existingImageView
            } else {
                imageView = UIImageView(frame: cell.bounds)
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
            imageView.image = selectedImages[indexPath.row]
            
            // delete button
            let deleteButton = UIButton(type: .system)
            deleteButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            deleteButton.tintColor = .white
            deleteButton.translatesAutoresizingMaskIntoConstraints = false
            deleteButton.tag = indexPath.row // Tag button with the index
            deleteButton.addTarget(self, action: #selector(deleteImageButtonTapped(_:)), for: .touchUpInside)
            
            cell.contentView.addSubview(deleteButton)
            
            NSLayoutConstraint.activate([
                deleteButton.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 5),
                deleteButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -5),
                deleteButton.widthAnchor.constraint(equalToConstant: 20),
                deleteButton.heightAnchor.constraint(equalToConstant: 20)
            ])
            
            return cell
        }
    }
    
    @objc func deleteImageButtonTapped(_ sender: UIButton) {
        let index = sender.tag

        let alert = UIAlertController(title: "Delete Image", message: "Are you sure you want to delete this image?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.selectedImages.remove(at: index)
            self?.postMomentScreen.collectionView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true)
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
    //MARK: Hide Keyboard
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen
        view.endEditing(true)
    }
}
