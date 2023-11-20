//
//  MomentsViewController.swift
//  PawPal
//
//  Created by Yitian Guo on 11/19/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MomentsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let momentsView = MomentsView()
    var moments = [Moment]()
    var currentUser: FirebaseAuth.User?
    
    override func loadView() {
        view = momentsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        momentsView.tableViewMoments.dataSource = self
        momentsView.tableViewMoments.delegate = self
        
        momentsView.profilePicButton.addTarget(self, action: #selector(profilePicButtonTapped), for: .touchUpInside)
        
        Auth.auth().currentUser?.reload(completion: { (error) in
            self.currentUser = Auth.auth().currentUser
            self.momentsView.labelText.text = "\(self.currentUser?.email ?? "Anonymous")"
        })

        let barIcon = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(onAddBarButtonTapped)
        )
        navigationItem.rightBarButtonItems = [barIcon]
        
        fetchFriendsMoments()
        
    }
    
    @objc func onAddBarButtonTapped(){
        let postAlert = UIAlertController(title: "Post a new moment", message: "Record your life with pets!",
            preferredStyle: .actionSheet)
        postAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(_) in
                self.presentImagePicker(sourceType: .camera)
            })
        )
        postAlert.addAction(UIAlertAction(title: "Choose from Album", style: .default, handler: {(_) in
                self.presentImagePicker(sourceType: .photoLibrary)
            })
        )
        postAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(postAlert, animated: true)
    }
    
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            print("Source type not available")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        self.present(imagePicker, animated: true)
    }
    
    // UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        let postMomentScreen = PostMomentViewController()
        postMomentScreen.selectedImage = selectedImage
        self.navigationController?.pushViewController(postMomentScreen, animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    
    @objc func profilePicButtonTapped() {
        // go to a single user's moments
    }
    
    func fetchFriendsMoments() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else { return }
        let db = Firestore.firestore()

        // fetch current user's friends list
        db.collection("users").document(currentUserEmail).getDocument { (document, error) in
            if let document = document, let data = document.data() {
                var friendsEmails = data["friends"] as? [String] ?? []
                friendsEmails.append(currentUserEmail) // include current user
                var allMoments = [Moment]()

                let group = DispatchGroup()

                for email in friendsEmails {
                    group.enter()
                    
                    // fetch moments for each user
                    self.fetchUserMoments(email: email) { moments in
                        allMoments.append(contentsOf: moments)
                        group.leave()
                    }
                }

                group.notify(queue: .main) {
                    self.moments = allMoments.sorted { $0.timestamp > $1.timestamp }
                    self.momentsView.tableViewMoments.reloadData()
                }
            } else if let error = error {
                print("Error fetching user document: \(error)")
            }
        }
    }

    func fetchUserMoments(email: String, completion: @escaping ([Moment]) -> Void) {
        let db = Firestore.firestore()

        db.collection("users").document(email).getDocument { (userDoc, err) in
            if let err = err {
                print("Error getting user document: \(err)")
                completion([])
                return
            }

            guard let userName = userDoc?.data()?["name"] as? String else {
                print("User name not found for email: \(email)")
                completion([])
                return
            }

            db.collection("users").document(email).collection("moments").getDocuments { (querySnapshot, err) in
                var moments = [Moment]()
                if let err = err {
                    print("Error getting moments: \(err)")
                    completion([])
                } else {
                    for document in querySnapshot!.documents {
                        do {
                            var moment = try document.data(as: Moment.self)
                            moment.name = userName // set the userName for each moment after decoding
                            moments.append(moment)
                        } catch {
                            print(error)
                        }
                    }
                    completion(moments)
                }
            }
        }
    }

}
