//
//  MomentsTableViewManager.swift
//  PawPal
//
//  Created by Yitian Guo on 11/20/23.
//

import Foundation
import UIKit

extension MomentsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewMomentsID, for: indexPath) as! MomentsTableViewCell
        
        cell.selectionStyle = .none
        
        let moment = moments[indexPath.row]
        cell.labelName.text = moment.name
        cell.labelText.text = moment.text
        cell.imageUrls = moment.imageUrls
        cell.labelTimestamp.text = DateFormatter.localizedString(from: moment.timestamp, dateStyle: .short, timeStyle: .short)
                
        return cell
    }
}
