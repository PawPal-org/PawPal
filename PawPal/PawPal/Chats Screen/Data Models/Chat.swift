//
//  Chat.swift
//  PawPal
//
//  Created by Yitian Guo on 11/28/23.
//

import Foundation
import FirebaseFirestore

struct Chat: Codable {
    @DocumentID var id: String?
    var friends: [String]
    var lastMessage: String
    var lastMessageTimestamp: Timestamp

    init(friends: [String], lastMessage: String, lastMessageTimestamp: Timestamp) {
        self.friends = friends
        self.lastMessage = lastMessage
        self.lastMessageTimestamp = lastMessageTimestamp
    }
}
