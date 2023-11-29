//
//  MessageTableViewManager.swift
//  PawPal
//
//  Created by Yitian Guo on 11/28/23.
//

import Foundation
import UIKit

extension MessageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewMessageID, for: indexPath) as! MessageTableViewCell
        let message = messages[indexPath.row]
        
        let isCurrentUser = message.sender == currentUser?.email
             
        cell.configureWithMessage(message: message, isCurrentUser: isCurrentUser)
        return cell
    }
}
