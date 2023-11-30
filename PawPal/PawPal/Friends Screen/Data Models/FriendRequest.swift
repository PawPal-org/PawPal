//
//  FriendRequest.swift
//  PawPal
//
//  Created by Yitian Guo on 11/30/23.
//

import Foundation
import FirebaseFirestore

struct FriendRequest: Codable {

    var userEmail: String
    var userName: String?
    var userProfilePicUrl: String?
    var timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case userEmail
        case timestamp
    }

    init(userEmail: String, userName: String?, userProfilePicUrl: String?, timestamp: Date) {
        self.userEmail = userEmail
        self.userName = userName
        self.userProfilePicUrl = userProfilePicUrl
        self.timestamp = timestamp
    }
}
