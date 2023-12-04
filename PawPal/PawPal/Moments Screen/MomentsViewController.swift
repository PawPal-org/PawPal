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
    var currentUserName: String?
    
    override func loadView() {
        view = momentsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // NotificationCenter.default.addObserver(self, selector: #selector(momentsNeedsReload), name: .didPostMoment, object: nil)
    
        // setting the tableView and other UI components
        momentsView.tableViewMoments.dataSource = self
        momentsView.tableViewMoments.delegate = self
        momentsView.profilePicButton.addTarget(self, action: #selector(profilePicButtonTapped), for: .touchUpInside)
        setupNavigationBar()
        
        // reloading the current user data and set up the refresh control
        reloadCurrentUser()
        setupRefreshControl()
        
        // fetching moments as soon as the view loads
        fetchFriendsMoments()
    }
    
    func setupNavigationBar() {
        let barIcon = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(onAddBarButtonTapped)
        )
        navigationItem.rightBarButtonItems = [barIcon]
    }
    
    func reloadCurrentUser() {
        Auth.auth().currentUser?.reload(completion: { (error) in
            self.currentUser = Auth.auth().currentUser
            self.currentUserName = self.currentUser?.displayName
            
            // Check if the user is logged in and has an email
            if let userEmail = self.currentUser?.email {
                let db = Firestore.firestore()
                db.collection("users").document(userEmail).getDocument { (document, error) in
                    if let document = document, document.exists, let data = document.data() {
                        let userName = data["name"] as? String ?? "Anonymous"
                        self.momentsView.labelText.text = userName
                    } else {
                        print("Document does not exist or failed to fetch user name")
                        self.momentsView.labelText.text = "Anonymous"
                    }
                }
            } else {
                self.momentsView.labelText.text = "Anonymous"
            }
            
            if let url = self.currentUser?.photoURL{
                URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                   guard let data = data, error == nil, let image = UIImage(data: data) else { return }
                   DispatchQueue.main.async {
                       self?.momentsView.profilePicButton.setImage(image, for: .normal)
                   }
               }.resume()
            }
        })
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshMoments(_:)), for: .valueChanged)
        momentsView.tableViewMoments.refreshControl = refreshControl
    }
    
    @objc func refreshMoments(_ sender: UIRefreshControl) {
        print("refresh.")
        fetchFriendsMoments()
        sender.endRefreshing()
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
//    @objc func momentsNeedsReload() {
//        fetchFriendsMoments()
//    }
    
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
        postMomentScreen.userEmail = self.currentUser?.email
        postMomentScreen.selectedImage = selectedImage
        self.navigationController?.pushViewController(postMomentScreen, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    @objc func profilePicButtonTapped() {
        let MyMomentScreen = MyMomentsViewController()
        MyMomentScreen.userEmail = self.currentUser?.email
        MyMomentScreen.userName = self.currentUserName
        MyMomentScreen.currentUser = self.currentUser
        self.navigationController?.pushViewController(MyMomentScreen, animated: true)
    }
    
    func fetchFriendsMoments() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else { return }
        let db = Firestore.firestore()

        db.collection("users").document(currentUserEmail).getDocument { [weak self] (document, error) in
            guard let self = self else { return }

            if let document = document, let data = document.data() {
                var friendsEmails = data["friends"] as? [String] ?? []
                friendsEmails.append(currentUserEmail) // Include current user

                var newMoments = [Moment]()
                let group = DispatchGroup()

                for email in friendsEmails {
                    group.enter()
                    db.collection("users").document(email).getDocument { (userDoc, userErr) in
                        guard let userName = userDoc?.data()?["name"] as? String else {
                            print("Error getting user name for email: \(email)")
                            group.leave()
                            return
                        }

                        db.collection("users").document(email).collection("moments")
                          .order(by: "timestamp", descending: true)
                          .limit(to: 10)
                          .getDocuments { (querySnapshot, err) in
                              if let err = err {
                                  print("Error getting moments for \(email): \(err)")
                                  group.leave()
                                  return
                              }
                              let profileImageUrlString = (userDoc?.data()?["profileImageUrl"] as? String) ?? ""
                              for document in querySnapshot!.documents {
                                  do {
                                      var moment = try document.data(as: Moment.self)
                                      moment.name = userName
                                      moment.profileImageUrl = profileImageUrlString
                                      moment.userEmail = email
                                      newMoments.append(moment)
                                  } catch {
                                      print(error)
                                  }
                              }
                              group.leave()
                          }
                    }
                }

                group.notify(queue: .main) {
                    self.updateMoments(newMoments)
                }
            } else if let error = error {
                print("Error fetching user document: \(error)")
            }
        }
    }
    
    
    func updateMoments(_ newMoments: [Moment]) {
        var sortedNewMoments = newMoments
        sortedNewMoments.sort { $0.timestamp > $1.timestamp }
        self.moments = sortedNewMoments
        self.momentsView.tableViewMoments.reloadData()
        checkForMomentsAndUpdateUI()
    }
    
    func checkForMomentsAndUpdateUI() {
        if moments.isEmpty {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: momentsView.tableViewMoments.bounds.size.width, height: momentsView.tableViewMoments.bounds.size.height))
            noDataLabel.text          = "No moments yet"
            noDataLabel.textColor     = UIColor.systemGray
            noDataLabel.textAlignment = .center
            momentsView.tableViewMoments.backgroundView = noDataLabel
            momentsView.tableViewMoments.separatorStyle = .none
        } else {
            momentsView.tableViewMoments.backgroundView = nil
            momentsView.tableViewMoments.separatorStyle = .singleLine
        }
    }

}
