//
//  Message.swift
//  PawPal
//
//  Created by Yitian Guo on 11/28/23.
//

import Foundation
import FirebaseFirestore

struct Message: Codable {
    @DocumentID var id: String?
    var sender: String
    var messageText: String
    var timestamp: Date
    
    init(sender: String, messageText: String, timestamp: Date) {
        self.sender = sender
        self.messageText = messageText
        self.timestamp = timestamp
    }
}
