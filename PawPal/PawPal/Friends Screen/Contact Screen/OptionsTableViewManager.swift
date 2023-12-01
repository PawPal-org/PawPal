//
//  OptionsTableViewManager.swift
//  PawPal
//
//  Created by Yitian Guo on 11/30/23.
//

import Foundation
import UIKit

extension ContactViewController {
    
    // MARK: Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewOptionsID, for: indexPath) as? OptionsTableViewCell else {
            fatalError("Cell not found")
        }
        cell.configure(with: options[indexPath.row])
        return cell
    }
    
    // MARK: Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle cell tap events
        print("Tapped option: \(options[indexPath.row])")
    }
}
