//
//  ContactsSearchBarManager.swift
//  PawPal
//
//  Created by Yitian Guo on 11/30/23.
//

import Foundation
import UIKit

extension FriendsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearchActive = false
            filteredContactsList = contactsList
        } else {
            isSearchActive = true
            filteredContactsList = contactsList.filter { contact in
                return contact.userName?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
        friendsView.tableViewContacts.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
        searchBar.text = ""
        friendsView.tableViewContacts.reloadData()
    }
}
