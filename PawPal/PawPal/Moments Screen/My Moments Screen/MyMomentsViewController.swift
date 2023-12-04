//
//  MyMomentsViewController.swift
//  PawPal
//
//  Created by Yitian Guo on 11/22/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MyMomentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let myMomentsView = MyMomentsView()
    var myMoments = [Moment]()
    var userEmail: String?
    var userName: String?
    var currentUser: FirebaseAuth.User?
    var userProfileImageUrl: String?
    
    override func loadView() {
        view = myMomentsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        myMomentsView.tableViewMoments.delegate = self
        myMomentsView.tableViewMoments.dataSource = self
        
        setupRefreshControl()
        
        myMomentsView.labelText.text = userName
        fetchUserProfilePicture()
        fetchMyPetsCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return myMoments.count
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewMomentsID, for: indexPath) as! MomentsTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        let moment = myMoments[indexPath.row]
        let isLiked = moment.likes.contains(Auth.auth().currentUser?.email ?? "")
        cell.configureCell(with: moment)
        cell.setLiked(isLiked)
        cell.configureCell(with: moment)
        return cell
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshMoments(_:)), for: .valueChanged)
        myMomentsView.tableViewMoments.refreshControl = refreshControl
    }
    
    @objc func refreshMoments(_ sender: UIRefreshControl) {
        print("refresh.")
        fetchMyMoments()
        checkForMomentsAndUpdateUI()
        sender.endRefreshing()
    }
    
    func fetchUserProfilePicture() {
        guard let userEmail = userEmail else {
            print("User email is not set")
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(userEmail).getDocument { [weak self] documentSnapshot, error in
            guard let self = self, let document = documentSnapshot, error == nil else {
                print("Error fetching user profile: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let profileImageUrlString = document.data()?["profileImageUrl"] as? String {
                
                self.userProfileImageUrl = profileImageUrlString // Store the URL

                if let url = URL(string: profileImageUrlString) {
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data, error == nil, let image = UIImage(data: data) else {
                            print("Error downloading profile image: \(error?.localizedDescription ?? "Unknown error")")
                            return
                        }

                        DispatchQueue.main.async {
                            self.myMomentsView.profilePicButton.setImage(image, for: .normal)
                            self.fetchMyMoments()
                        }
                    }.resume()
                }
            } else {
                self.fetchMyMoments()
                print("Profile image URL not found")
            }
        }
    }
    
    func fetchMyMoments() {
        guard let userEmail = userEmail else { return }
        let db = Firestore.firestore()
        db.collection("users").document(userEmail).collection("moments")
          .order(by: "timestamp", descending: true)
          .getDocuments { [weak self] (querySnapshot, err) in
              guard let self = self else { return }
              if let err = err {
                  print("Error getting documents: \(err)")
              } else {
                  self.myMoments.removeAll()
                  var totalLikes = 0
                  for document in querySnapshot!.documents {
                      do {
                          var moment = try document.data(as: Moment.self)
                          moment.name = userName
                          moment.profileImageUrl = self.userProfileImageUrl
                          self.myMoments.append(moment)
                          totalLikes += moment.likes.count
                      } catch {
                          print(error)
                      }
                  }
                  self.myMomentsView.tableViewMoments.reloadData()
                  self.myMomentsView.labelMomentsCountText.text = "\(self.myMoments.count)"
                  self.myMomentsView.labelLikesCountText.text = "\(totalLikes)"
              }
          }
        checkForMomentsAndUpdateUI()
    }
    
    func fetchMyPetsCount() {
        guard let userEmail = userEmail else { return }
        let db = Firestore.firestore()
        db.collection("users").document(userEmail).collection("myPets")
          .getDocuments { [weak self] (querySnapshot, err) in
              guard let self = self else { return }
              if let err = err {
                  print("Error getting documents: \(err)")
              } else {
                  let totalPets = querySnapshot?.documents.count ?? 0
                  self.myMomentsView.labelPetsCountText.text = "\(totalPets)"
              }
          }
    }
    
    func checkForMomentsAndUpdateUI() {
        if myMoments.isEmpty {
            let noDataLabel = UILabel()
            noDataLabel.text = "No moments yet"
            noDataLabel.textColor = UIColor.systemGray
            noDataLabel.textAlignment = .center
            noDataLabel.frame = CGRect(x: 0, y: 0, width: myMomentsView.tableViewMoments.bounds.size.width, height: myMomentsView.tableViewMoments.bounds.size.height)
            myMomentsView.tableViewMoments.backgroundView = noDataLabel
        } else {
            myMomentsView.tableViewMoments.backgroundView = nil
        }
        myMomentsView.tableViewMoments.reloadData()
    }

}

extension MyMomentsViewController: MomentsTableViewCellDelegate {
    func didTapLikeButton(on cell: MomentsTableViewCell) {
        guard let indexPath = myMomentsView.tableViewMoments.indexPath(for: cell),
              let currentUserEmail = Auth.auth().currentUser?.email else { return }

        let moment = myMoments[indexPath.row]
        var updatedLikes = moment.likes
        
        let isLiked: Bool
        if let index = updatedLikes.firstIndex(of: currentUserEmail) {
            updatedLikes.remove(at: index)
            isLiked = false
        } else {
            updatedLikes.append(currentUserEmail)
            isLiked = true
        }
        cell.setLiked(isLiked)

        let db = Firestore.firestore()
        db.collection("users").document(self.userEmail!).collection("moments").document(moment.id!).updateData([
            "likes": updatedLikes
        ]) { error in
            if let error = error {
                print("Error updating likes: \(error)")
            } else {
                print("Likes updated successfully")
            }
        }
    }
    
    func didTapUserImageButton(on cell: MomentsTableViewCell) {
        // nothing, won't navigate again
    }
    
}
