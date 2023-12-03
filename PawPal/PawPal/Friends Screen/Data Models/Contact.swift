//
//  Contact.swift
//  PawPal
//
//  Created by Yitian Guo on 11/30/23.
//

import Foundation
import FirebaseFirestore

struct Contact: Codable {

    var userEmail: String
    var userName: String?
    var userProfilePicUrl: String?
    var isFriend: Bool?
    
    enum CodingKeys: String, CodingKey {
        case userEmail
    }

    init(userEmail: String, userName: String?, userProfilePicUrl: String?, isFriend: Bool?) {
        self.userEmail = userEmail
        self.userName = userName
        self.userProfilePicUrl = userProfilePicUrl
        self.isFriend = isFriend
    }
}
