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
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearchActive ? 1 : contactSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? filteredContactsList.count : contactSections[section].contacts.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isSearchActive ? nil : contactSections[section].letter
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return isSearchActive ? nil : contactSections.map { $0.letter }
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return isSearchActive ? 0 : contactSections.firstIndex { $0.letter == title } ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewContactsID, for: indexPath) as! ContactsTableViewCell
        
        let contact = isSearchActive ? filteredContactsList[indexPath.row] : contactSections[indexPath.section].contacts[indexPath.row]
        
        cell.labelName.text = contact.userName
        if !contact.isFriend! {
            cell.labelName.textColor = .red
        }else {
            cell.labelName.textColor = .black
        }
        
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
        let selectedContact = isSearchActive ? filteredContactsList[indexPath.row] : contactSections[indexPath.section].contacts[indexPath.row]
        
        let contactScreen = ContactViewController()
        contactScreen.currentUser = self.currentUser
        contactScreen.contact = selectedContact
        
        self.navigationController?.pushViewController(contactScreen, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
