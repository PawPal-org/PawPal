//
//  OptionsTableViewCell.swift
//  PawPal
//
//  Created by Yitian Guo on 11/30/23.
//

import UIKit

class OptionsTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with option: String) {
        self.textLabel?.text = option
        //further styling
        if option == "Delete Contact" {
            self.textLabel?.textColor = .red
        }
    }

}
