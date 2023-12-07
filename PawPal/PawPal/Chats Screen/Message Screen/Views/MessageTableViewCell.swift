//
//  MessageTableViewCell.swift
//  PawPal
//
//  Created by Yitian Guo on 11/28/23.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    var wrapperCellView: UIView!
    var labelSenderName: UILabel!
    var labelMessageText: UILabel!
    var labelTimeStamp: UILabel!
    
    var currentUserConstraints: [NSLayoutConstraint] = []
    var otherUserConstraints: [NSLayoutConstraint] = []
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none // prevent cell selection highlighting
        
        setupWrapperCellView()
        setupLabelSenderName()
        setupLabelMessageText()
        setupLabelTimeStamp()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UIView()
        
        //working with the shadows and colors...
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 6.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 4.0
        wrapperCellView.layer.shadowOpacity = 0.4
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(wrapperCellView) // Add to contentView, not self
    }
    
    func setupLabelSenderName(){
        labelSenderName = UILabel()
        labelSenderName.isHidden = true
        labelSenderName.font = UIFont.boldSystemFont(ofSize: 2)
        labelSenderName.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelSenderName)
    }
    
    func setupLabelMessageText(){
        labelMessageText = UILabel()
        labelMessageText.font = UIFont.systemFont(ofSize: 16)
        labelMessageText.numberOfLines = 0 // Allows unlimited lines
        labelMessageText.lineBreakMode = .byWordWrapping // Wraps text at word boundaries
        labelMessageText.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelMessageText)
    }
    
    func setupLabelTimeStamp(){
        labelTimeStamp = UILabel()
        labelTimeStamp.font = UIFont.boldSystemFont(ofSize: 6)
        labelTimeStamp.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelTimeStamp)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Common constraints for both current user and other users
            wrapperCellView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),

            labelSenderName.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            labelSenderName.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 8),
            labelSenderName.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -8),

            labelMessageText.topAnchor.constraint(equalTo: labelSenderName.bottomAnchor, constant: 4),
            labelMessageText.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 8),
            labelMessageText.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -8),

            labelTimeStamp.topAnchor.constraint(equalTo: labelMessageText.bottomAnchor, constant: 4),
            labelTimeStamp.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -8),
            labelTimeStamp.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -8),
            
        ])
        
        let wrapperLeadingConstraint = wrapperCellView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16)
        let wrapperTrailingConstraint = wrapperCellView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
        let maxWidthConstraint = wrapperCellView.widthAnchor.constraint(lessThanOrEqualTo: self.contentView.widthAnchor, multiplier: 0.75)
        
        // Storing constraints to be activated or deactivated later
        currentUserConstraints = [wrapperTrailingConstraint, maxWidthConstraint]
        otherUserConstraints = [wrapperLeadingConstraint, maxWidthConstraint]

        maxWidthConstraint.isActive = true
        
        let wrapperWidthConstraint = wrapperCellView.widthAnchor.constraint(greaterThanOrEqualTo: labelTimeStamp.widthAnchor)
        wrapperWidthConstraint.isActive = true

        labelTimeStamp.leadingAnchor.constraint(greaterThanOrEqualTo: wrapperCellView.leadingAnchor, constant: 8).isActive = true
    }
    
    func configureWithMessage(message: Message, isCurrentUser: Bool) {
        // labelSenderName.text = message.sender
        labelMessageText.text = message.messageText
        labelTimeStamp.text = formatDate(message.timestamp)
        
        wrapperCellView.layer.cornerRadius = 15
        wrapperCellView.clipsToBounds = true
        
        labelMessageText.font = UIFont.systemFont(ofSize: 14)
        labelTimeStamp.font = UIFont.systemFont(ofSize: 8)

        // clear any existing active constraints that might conflict
        NSLayoutConstraint.deactivate(currentUserConstraints)
        NSLayoutConstraint.deactivate(otherUserConstraints)

        if isCurrentUser {
            NSLayoutConstraint.activate(currentUserConstraints)
            wrapperCellView.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.2)
            wrapperCellView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner] // Rounded corners except top right
            labelMessageText.textColor = .darkText
        } else {
            NSLayoutConstraint.activate(otherUserConstraints)
            wrapperCellView.backgroundColor = UIColor.systemGray5.withAlphaComponent(0.5)
            wrapperCellView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner] // Rounded corners except top left
            labelMessageText.textColor = .black
        }
        
        // have updated constraints, need to lay out the view again
        self.layoutIfNeeded()
    }

    func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current

        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "'Yesterday, 'h:mm a"
            return formatter.string(from: date)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy, h:mm a"
            return formatter.string(from: date)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
