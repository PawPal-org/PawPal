//
//  MeViewController.swift
//  PawPal
//
//  Created by Yitian Guo on 11/19/23.
//

import UIKit
import FirebaseAuth

class MeViewController: UIViewController {
    
    let meScreen = MeView()
    
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
        
        meScreen.labelName.text = "Name"
        meScreen.labelUserName.text = "Username"
        
        // Disable scrolling for the table views
        meScreen.meTable.isScrollEnabled = false
        meScreen.settingTable.isScrollEnabled = false
        meScreen.logOutTable.isScrollEnabled = false
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
            // Using indexPath.row
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
