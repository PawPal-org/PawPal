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
    
    enum CodingKeys: String, CodingKey {
        case userEmail
    }

    init(userEmail: String, userName: String?, userProfilePicUrl: String?) {
        self.userEmail = userEmail
        self.userName = userName
        self.userProfilePicUrl = userProfilePicUrl
    }
}
