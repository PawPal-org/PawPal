//
//  MessageView.swift
//  PawPal
//
//  Created by Yitian Guo on 11/28/23.
//

import UIKit

class MessageView: UIView {

    //MARK: tableView for message...
    var tableViewMessages: UITableView!
    
    //MARK: bottom view for sending a message...
    var bottomSendView: UIView!
    var textViewMessageText: UITextView!
    var buttonSend: UIButton!
    var bottomSendViewBottomConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupTableViewMessages()
        
        setupBottomSendView()
        setupTextViewMessageText()
        setupButtonSend()
        
        initConstraints()
    }
    
    //MARK: the table view to show the list of message...
    func setupTableViewMessages(){
        tableViewMessages = UITableView()
        tableViewMessages.register(MessageTableViewCell.self, forCellReuseIdentifier: Configs.tableViewMessageID)
        tableViewMessages.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewMessages)
    }
    
    //MARK: the bottom send view....
    func setupBottomSendView(){
        bottomSendView = UIView()
        bottomSendView.backgroundColor = .white
        bottomSendView.layer.cornerRadius = 6
        bottomSendView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomSendView.layer.shadowOffset = .zero
        bottomSendView.layer.shadowRadius = 4.0
        bottomSendView.layer.shadowOpacity = 0.7
        bottomSendView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomSendView)
    }
    
    func setupTextViewMessageText(){
        textViewMessageText = UITextView()
        textViewMessageText.font = .systemFont(ofSize: 16)
        textViewMessageText.layer.cornerRadius = 8
        textViewMessageText.layer.borderWidth = 1.0
        textViewMessageText.layer.borderColor = UIColor.lightGray.cgColor
        textViewMessageText.translatesAutoresizingMaskIntoConstraints = false
        bottomSendView.addSubview(textViewMessageText)
    }
    
    func setupButtonSend(){
        buttonSend = UIButton(type: .system)
        buttonSend.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buttonSend.setTitle("Send", for: .normal)
        buttonSend.translatesAutoresizingMaskIntoConstraints = false
        bottomSendView.addSubview(buttonSend)
    }
    
    func initConstraints() {
        bottomSendViewBottomConstraint = bottomSendView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        NSLayoutConstraint.activate([
            bottomSendViewBottomConstraint,
            
            bottomSendView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            bottomSendView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            bottomSendView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),

            buttonSend.centerYAnchor.constraint(equalTo: bottomSendView.centerYAnchor),
            buttonSend.trailingAnchor.constraint(equalTo: bottomSendView.trailingAnchor, constant: -8),
            buttonSend.widthAnchor.constraint(equalToConstant: 44),
            buttonSend.heightAnchor.constraint(equalTo: buttonSend.widthAnchor),

            textViewMessageText.centerYAnchor.constraint(equalTo: buttonSend.centerYAnchor),
            textViewMessageText.leadingAnchor.constraint(equalTo: bottomSendView.leadingAnchor, constant: 8),
            textViewMessageText.trailingAnchor.constraint(equalTo: buttonSend.leadingAnchor, constant: -8),
            textViewMessageText.heightAnchor.constraint(equalToConstant: 50),

            bottomSendView.topAnchor.constraint(equalTo: textViewMessageText.topAnchor, constant: -8),
            
            tableViewMessages.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            tableViewMessages.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableViewMessages.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tableViewMessages.bottomAnchor.constraint(equalTo: bottomSendView.topAnchor, constant: -8),
        ])
    }


    
    //MARK: unused.....
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
