//
//  MeViewController.swift
//  PawPal
//
//  Created by Yitian Guo on 11/19/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MeViewController: UIViewController {
    
    let meScreen = MeView()
    let db = Firestore.firestore()
    var userProfileImageUrl: String?
    
    var menuItems = [
        ("My Pets", "pawprint.circle"),
        ("My Posts", "photo.circle"),
        ("GPS", "mappin.circle")
    ]
    
    var settingItem = [
        ("Setting", "gearshape")
    ]
    
    var logOutItem = [
        ("Log Out", "rectangle.portrait.and.arrow.forward")
    ]
    
    override func loadView() {
        view = meScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: setting the delegate and data source...
        meScreen.meTable.dataSource = self
        meScreen.meTable.delegate = self
        
        meScreen.settingTable.dataSource = self
        meScreen.settingTable.delegate = self
        
        meScreen.logOutTable.dataSource = self
        meScreen.logOutTable.delegate = self
        
        // Disable scrolling for the table views
        meScreen.meTable.isScrollEnabled = false
        meScreen.settingTable.isScrollEnabled = false
        meScreen.logOutTable.isScrollEnabled = false
        
        fetchUserProfilePicture()
        fetchUserName()
    }
    
    func fetchUserName() {
        guard let user = Auth.auth().currentUser, let email = user.email else { return }
        // Safely unwrapped email to avoid passing a nil value
        let docRef = db.collection("users").document(email)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Assuming 'dataDescription' is for debugging purposes
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                    
                // Extract 'email' and 'name' safely
                let email = document.get("email") as? String ?? ""
                let name = document.get("name") as? String ?? ""
                
                // Dispatch UI updates on the main thread
                DispatchQueue.main.async {
                    self.meScreen.labelName.text = name
                    self.meScreen.labelUserName.text = email
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func fetchUserProfilePicture() {
        guard let user = Auth.auth().currentUser, let email = user.email else {
            print("User email is not set")
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(email).getDocument { [weak self] documentSnapshot, error in
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
                            self.meScreen.imageUser.image = image
                        }
                    }.resume()
                }
            } else {
                print("Profile image URL not found")
            }
        }
    }
    
}


extension MeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == meScreen.meTable {
            return menuItems.count
        } else if tableView == meScreen.settingTable {
            return settingItem.count
        } else if tableView == meScreen.logOutTable {
            return logOutItem.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == meScreen.meTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeTableViewCell", for: indexPath) as! MeTableViewCell
            let (title, iconName) = menuItems[indexPath.row]
            cell.labelTitle.text = title
            cell.imageIcon.image = UIImage(named: iconName)
            cell.accessoryType = .disclosureIndicator
            return cell
        } else if tableView == meScreen.settingTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
            let (title, iconName) = settingItem[indexPath.row]
            cell.labelTitle.text = title
            cell.imageIcon.image = UIImage(named: iconName)
            cell.accessoryType = .disclosureIndicator
            return cell
        } else if tableView == meScreen.logOutTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogOutTableViewCell", for: indexPath) as! LogOutTableViewCell
            let (title, iconName) = logOutItem[indexPath.row]
            cell.labelTitle.text = title
            cell.imageIcon.image = UIImage(named: iconName)
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
        // Return a default cell if none of the conditions is met
        return UITableViewCell()

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == meScreen.meTable {
            // Handle "My Pets", "My Posts", "GPS" cell tabbed
            if indexPath.row == 0 {
                let myPetsController = MyPetsViewController()
                navigationController?.pushViewController(myPetsController, animated: true)
            }
            else if indexPath.row == 1 {
                let myMomentsViewController = MyMomentsViewController()
                navigationController?.pushViewController(myMomentsViewController, animated: true)
            }
            else if indexPath.row == 2 {
                let mapViewController = MapViewController()
                navigationController?.pushViewController(mapViewController, animated: true)
            }
        } else if tableView == meScreen.settingTable {
            //Handle "Setting" cell tabbed
        } else if tableView == meScreen.logOutTable {
            let logoutAlert = UIAlertController(title: "Logging out!", message: "Are you sure want to log out?",
                preferredStyle: .actionSheet)
            logoutAlert.addAction(UIAlertAction(title: "Yes, log out!", style: .default, handler: {(_) in
                    do{
                        try Auth.auth().signOut()
                        
                        // Transition to the LoginViewController
                        let loginViewController = LoginViewController()
                        let navigationController = UINavigationController(rootViewController: loginViewController)
                        navigationController.modalPresentationStyle = .fullScreen
                        self.view.window?.rootViewController = navigationController
                        self.view.window?.makeKeyAndVisible()
                        
                    }catch{
                        print("Error occured!")
                    }
                })
            )
            logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self.present(logoutAlert, animated: true)
            

        }
    }
    
}
