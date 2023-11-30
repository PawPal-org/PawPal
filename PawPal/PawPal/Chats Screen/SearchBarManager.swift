//
//  SearchBarManager.swift
//  PawPal
//
//  Created by Yitian Guo on 11/30/23.
//

import Foundation
import UIKit

extension ChatsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearchActive = false
            filteredChatsList = chatsList
        } else {
            isSearchActive = true
            filteredChatsList = chatsList.filter { chat in
                //filter by friend's name
                return chat.friends.contains(where: { $0.lowercased().contains(searchText.lowercased()) })
            }
        }
        chatsView.tableViewChats.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
        searchBar.text = ""
        chatsView.tableViewChats.reloadData()
    }
}
