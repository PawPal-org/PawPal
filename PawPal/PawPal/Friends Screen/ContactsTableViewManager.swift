//
//  ContactsTableViewManager.swift
//  PawPal
//
//  Created by Yitian Guo on 11/30/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? filteredContactsList.count : contactsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewContactsID, for: indexPath) as! ContactsTableViewCell
        
        let contact = isSearchActive ? filteredContactsList[indexPath.row] : contactsList[indexPath.row]
        
        cell.labelName.text = contact.userName
        
        cell.buttonProfilePic.setBackgroundImage(UIImage(systemName: "person.crop.circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        if let imageUrlString = contact.userProfilePicUrl, let url = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data, error == nil, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.buttonProfilePic.setBackgroundImage(image, for: .normal)
                    }
                }
            }.resume()
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let selectedContact = isSearchActive ? filteredContactsList[indexPath.row] : contactsList[indexPath.row]

        //let email = selectedContact.userEmail
        //let messageScreen = MessageViewController()
        //messageScreen.currentUser = self.currentUser
        //self.navigationController?.pushViewController(messageScreen, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
